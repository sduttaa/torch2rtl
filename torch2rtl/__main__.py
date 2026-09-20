import argparse
import hashlib
import json
from dataclasses import asdict
from pathlib import Path

from .analysis import analyze
from .frontend import load


def main():
    parser = argparse.ArgumentParser(description="Import, inspect, and compile frozen PyTorch exports")
    sub = parser.add_subparsers(dest="command", required=True)
    inspect = sub.add_parser("inspect", help="Verify through torch-mlir and account workload requirements")
    inspect.add_argument("model", type=Path)
    inspect.add_argument("--target", type=Path, required=True)
    inspect.add_argument("--fps", type=float)
    inspect.add_argument("--output", type=Path, required=True)
    compile_parser = sub.add_parser("compile", help="Compile the supported integer actor subset")
    compile_parser.add_argument("model", type=Path)
    compile_parser.add_argument("--target", type=Path, required=True)
    compile_parser.add_argument("--lanes", type=int, nargs="+", required=True)
    compile_parser.add_argument("--depths", type=int, nargs="+", required=True)
    compile_parser.add_argument("--seconds", type=float, default=30)
    compile_parser.add_argument("--output", type=Path, required=True)
    network_parser = sub.add_parser("emit-network", help="Emit spatial RTL from explicit actor/FIFO choices; does not optimize or prove fit")
    network_parser.add_argument("--configuration", type=Path, required=True)
    network_parser.add_argument("--output", type=Path, required=True)
    schedule_parser = sub.add_parser("schedule-network", help="Jointly select spatial actors and FIFOs from an explicit cost catalogue")
    schedule_parser.add_argument("--catalogue", type=Path, required=True)
    schedule_parser.add_argument("--target", type=Path, required=True)
    schedule_parser.add_argument("--seconds", type=float, default=30)
    schedule_parser.add_argument("--output", type=Path, required=True)
    args = parser.parse_args()
    if args.command == "schedule-network":
        from .graph import actors, read
        from .schedule import Limits
        from .spatial_compile import compile_network
        catalogue = json.loads(args.catalogue.read_text())
        model_path = Path(catalogue["model"])
        model_hash = hashlib.sha256(model_path.read_bytes()).hexdigest()
        if "model_sha256" in catalogue and catalogue["model_sha256"] != model_hash:
            raise ValueError("Catalogue refers to different model contents")
        catalogue["model_sha256"] = model_hash
        _, module = load(model_path)
        report = compile_network(actors(read(module)), catalogue, json.loads(args.target.read_text()), args.output,
                                 Limits(seconds=args.seconds))
        (args.output / "model.mlir").write_text(str(module))
        print(json.dumps(report, indent=2))
        return
    if args.command == "emit-network":
        from .graph import actors, read
        from .network import emit
        from .ranges import bounds, storage_bits
        config = json.loads(args.configuration.read_text())
        model_path = Path(config["model"])
        model_hash = hashlib.sha256(model_path.read_bytes()).hexdigest()
        if "model_sha256" in config and config["model_sha256"] != model_hash:
            raise ValueError("Configuration refers to different model contents")
        _, module = load(model_path)
        graph = actors(read(module))
        rtl = emit(graph, config["lanes"], config["output_lanes"], config["fifo_depths"],
                   config.get("memories"), config.get("reduction_lanes"))
        args.output.mkdir(parents=True, exist_ok=True)
        (args.output / "inference.sv").write_text(rtl)
        (args.output / "model.mlir").write_text(str(module))
        report = {"model_sha256": model_hash, "configuration": config,
                  "actors": [{"name": value.name, "operation": value.operation, "tensor": asdict(value.tensor),
                              "value_range": bounds(value), "stream_storage_bits": storage_bits(value)}
                             for value in graph.values],
                  "solver_verified": False, "hardware_fit_verified": False, "timing_verified": False}
        (args.output / "emission.json").write_text(json.dumps(report, indent=2) + "\n")
        print(f"Explicit-configuration RTL emitted to {args.output.resolve()}; scheduling, fit and timing remain to be checked")
        return
    target = json.loads(args.target.read_text())
    program, module = load(args.model)
    if args.command == "compile":
        from .compiler import compile_module
        from .schedule import Limits
        report = compile_module(module, target, args.lanes, args.depths, args.output, Limits(seconds=args.seconds))
        print(json.dumps({key: value for key, value in report["solution"].items() if key != "offsets"}, indent=2))
        print(f"Scheduled throughput (before timing closure): {report['scheduled_fps']:.3f} inferences/s")
        print(f"RTL and synthesis outputs: {args.output.resolve()}")
        return
    report = analyze(program, target, args.fps)
    report["model"] = {"path": str(args.model.resolve()),
                       "sha256": hashlib.sha256(args.model.read_bytes()).hexdigest()}
    report["target"] = target
    args.output.mkdir(parents=True, exist_ok=True)
    from .cp_sat import solve
    from .storage import storage_problem
    storage = report["constant_storage_candidates"]
    allowance = storage["optimistic_all_storage_bytes"] or storage["fabric_ram_bytes"]
    problem = storage_problem(storage, allowance)
    storage["storage_relaxation"] = asdict(solve(problem))
    (args.output / "storage-problem.json").write_text(json.dumps(asdict(problem), indent=2) + "\n")
    (args.output / "model.mlir").write_text(str(module))
    (args.output / "analysis.json").write_text(json.dumps(report, indent=2) + "\n")
    print(json.dumps(report["summary"], indent=2))
    for finding in report["findings"]:
        print(f"{finding['code']}: {finding['message']}")
    print(f"Lossless storage catalogue: {storage['storage_relaxation']['status']} "
          f"within an optimistic {allowance}-byte allowance")
    print(f"Verified MLIR and report: {args.output.resolve()}")


if __name__ == "__main__":
    try:
        main()
    except ValueError as error:
        raise SystemExit(f"error: {error}") from None
