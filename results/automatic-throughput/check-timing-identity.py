"""Compare decoded BBA timing records and link the original BBA to its binary."""
import argparse
import hashlib
import json
from pathlib import Path


def digest(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


def timing(path):
    labels = {}
    current = None
    with path.open() as source:
        for raw in source:
            line = raw.strip()
            if line.startswith("label "):
                name = line[6:]
                current = [] if name.startswith("sg") or name in (
                    "speed_grades", "constids", "constids_strs") else None
                if current is not None:
                    labels[name] = current
            elif current is not None:
                if line.startswith("str "):
                    current.append(line[5:-1])
                elif line.startswith("u32 "):
                    current.append(int(line[4:]))
                elif line.startswith("ref "):
                    current.append(line[4:])
                else:
                    raise ValueError(f"Unexpected timing directive: {line}")
    known = labels["constids"][0]

    def name(index):
        return f"constid:{index}" if index < known else labels["constids_strs"][index-known]

    def records(label, count, width):
        values = labels[label]
        assert len(values) == count * width, (label, len(values), count, width)
        return [values[offset:offset+width] for offset in range(0, len(values), width)]

    result = {}
    grades = labels["speed_grades"]
    assert len(grades) % 8 == 0
    for offset in range(0, len(grades), 8):
        grade, pips, npips, nodes, nnodes, cells, ncells, extra = grades[offset:offset+8]
        assert extra == 0
        types = {}
        for cell, pins, npins in records(cells, ncells, 3):
            types[name(cell)] = {}
            for pin, flags, comb, ncomb, reg, nreg in records(pins, npins, 6):
                types[name(cell)][name(pin)] = {
                    "flags": flags,
                    "comb": sorted([name(a[0]), *a[1:]] for a in records(comb, ncomb, 5)),
                    "reg": sorted([name(a[0]), *a[1:]] for a in records(reg, nreg, 14)),
                }
        result[name(grade)] = {"cells": types,
            "pip_classes": records(pips, npips, 13),
            "node_classes": records(nodes, nnodes, 12)}
    return result


parser = argparse.ArgumentParser(description=__doc__)
for key in ("original", "regenerated", "binary", "reassembled", "generator", "timing-table", "output"):
    parser.add_argument("--"+key, type=Path, required=True)
args = parser.parse_args()
original = timing(args.original)
regenerated = timing(args.regenerated)
same_timing = original == regenerated
same_binary = digest(args.binary) == digest(args.reassembled)
report = {
    "passed": same_timing and same_binary,
    "decoded_timing_identical": same_timing,
    "original_bba_reassembles_to_routed_database": same_binary,
    "speed_grades": len(original),
    "cell_variants_per_grade": {k: len(v["cells"]) for k, v in original.items()},
    "scope": "All decoded cell timing and indexed pip/node timing classes match. Routing-graph serialization differs; whole regenerated databases are not claimed identical. The archived original BBA assembles byte-identically to the database used for routing.",
    "evidence": {key: {"path": str(path.resolve()), "sha256": digest(path)}
        for key, path in vars(args).items() if key != "output"},
}
args.output.write_text(json.dumps(report, indent=2)+"\n")
print(json.dumps(report, indent=2))
assert report["passed"], "Timing database identity failed"
