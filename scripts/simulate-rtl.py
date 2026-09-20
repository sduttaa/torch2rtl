#!/usr/bin/env python3
"""Check a ready/valid RTL stream against hex vectors using Verilator.

Word widths are explicit inputs and limited to 64 bits by this small harness.
The simulator checks output stability during stalls and reports frame timing.
"""

import argparse
import json
from pathlib import Path
import subprocess

parser = argparse.ArgumentParser(description=__doc__)
parser.add_argument("--rtl", type=Path, required=True)
parser.add_argument("--input", type=Path, required=True)
parser.add_argument("--expected", type=Path, required=True)
parser.add_argument("--input-bits", type=int, required=True)
parser.add_argument("--output-bits", type=int, required=True)
parser.add_argument("--outputs-per-frame", type=int, required=True)
parser.add_argument("--max-cycles", type=int, required=True)
parser.add_argument("--stalls", action="store_true")
parser.add_argument("--input-cycles", type=Path, help="Optional exact input-transfer cycles as hexadecimal words")
parser.add_argument("--output-cycles", type=Path, help="Optional exact output-transfer cycles as hexadecimal words")
parser.add_argument("--output", type=Path, required=True)
args = parser.parse_args()
if not 1 <= args.input_bits <= 64 or not 1 <= args.output_bits <= 64:
    parser.error("The simulator accepts stream words from 1 to 64 bits")
if min(args.max_cycles, args.outputs_per_frame) < 1:
    parser.error("Cycle and frame sizes must be positive")
if bool(args.input_cycles) != bool(args.output_cycles) or (args.input_cycles and args.stalls):
    parser.error("Supply both cycle files, without random stalls, to check scheduled transfers")
args.output.mkdir(parents=True, exist_ok=True)
for source, name in ((args.rtl, "inference.sv"), (args.input, "input.hex"), (args.expected, "expected.hex")):
    (args.output / name).write_bytes(source.read_bytes())
if args.input_cycles:
    for source, name in ((args.input_cycles, "input_cycles.hex"), (args.output_cycles, "output_cycles.hex")):
        (args.output / name).write_bytes(source.read_bytes())
bench = f"""
#include "Vinference.h"
#include "verilated.h"
#include <cstdint>
#include <fstream>
#include <iostream>
#include <stdexcept>
#include <vector>

std::vector<uint64_t> words(const char* path, unsigned bits) {{
  std::ifstream file(path);
  std::vector<uint64_t> values;
  uint64_t value;
  while (file >> std::hex >> value) {{
    if (bits < 64 && (value >> bits)) throw std::runtime_error("Word exceeds declared width");
    values.push_back(value);
  }}
  if (!file.eof() || values.empty()) throw std::runtime_error("Invalid or empty vector file");
  return values;
}}
void check_cycles(const std::vector<uint64_t>& cycles, size_t count) {{
  if (cycles.size() != count || cycles.empty() || cycles[0] == 0)
    throw std::runtime_error("Cycle vector has the wrong size or starts before cycle one");
  for (size_t i=1; i<cycles.size(); ++i)
    if (cycles[i] <= cycles[i-1]) throw std::runtime_error("Transfer cycles must strictly increase");
}}
int main(int argc, char** argv) {{
  Verilated::commandArgs(argc, argv);
  const auto input = words("input.hex", {args.input_bits});
  const auto expected = words("expected.hex", {args.output_bits});
  const bool scheduled = {str(bool(args.input_cycles)).lower()};
  const auto input_cycles = scheduled ? words("input_cycles.hex", 64) : std::vector<uint64_t>{{}};
  const auto output_cycles = scheduled ? words("output_cycles.hex", 64) : std::vector<uint64_t>{{}};
  if (scheduled) {{ check_cycles(input_cycles, input.size()); check_cycles(output_cycles, expected.size()); }}
  if (expected.size() % {args.outputs_per_frame}) throw std::runtime_error("Partial expected frame");
  Vinference dut;
  dut.rst = 1; dut.in_valid = 0; dut.out_ready = 0; dut.in_data = 0;
  for (int i=0; i<3; ++i) {{ dut.clk=0; dut.eval(); dut.clk=1; dut.eval(); }}
  dut.rst = 0;
  size_t sent=0, received=0;
  uint32_t random=0x9e3779b9;
  bool accepted=false, stalled=false;
  uint64_t held=0;
  std::vector<uint64_t> frames;
  for (uint64_t cycle=1; cycle<={args.max_cycles}ULL; ++cycle) {{
    random ^= random << 13; random ^= random >> 17; random ^= random << 5;
    if (!dut.in_valid || accepted) {{
      dut.in_valid = sent < input.size() && (scheduled ? cycle >= input_cycles[sent] : ({int(not args.stalls)} || (random & 1)));
      if (sent < input.size()) dut.in_data = input[sent];
    }}
    dut.out_ready = scheduled ? received < expected.size() && cycle == output_cycles[received] :
      ({int(not args.stalls)} || (random & 2));
    dut.clk=0; dut.eval();
    if (stalled && (!dut.out_valid || uint64_t(dut.out_data) != held)) {{
      std::cerr << "Output changed while stalled at cycle " << cycle << '\\n'; return 1;
    }}
    stalled = dut.out_valid && !dut.out_ready; held = dut.out_data;
    accepted = dut.in_valid && dut.in_ready;
    if (scheduled && accepted && cycle != input_cycles[sent]) {{
      std::cerr << "Late input " << sent << " at cycle " << cycle << '\\n'; return 1;
    }}
    if (scheduled && received < expected.size() && cycle == output_cycles[received] && !dut.out_valid) {{
      std::cerr << "Late output " << received << " at cycle " << cycle << '\\n'; return 1;
    }}
    if (accepted) ++sent;
    if (dut.out_valid && dut.out_ready) {{
      if (received >= expected.size() || uint64_t(dut.out_data) != expected[received]) {{
        std::cerr << "Mismatch at word " << received << ": actual " << std::hex << dut.out_data
                  << " expected " << (received < expected.size() ? expected[received] : 0) << '\\n'; return 1;
      }}
      ++received;
      if (received % {args.outputs_per_frame} == 0) frames.push_back(cycle);
    }}
    dut.clk=1; dut.eval();
    if (received == expected.size() && sent == input.size()) {{
      std::cout << "{{\\\"cycles\\\":" << cycle << ",\\\"input_words\\\":" << sent
                << ",\\\"output_words\\\":" << received << ",\\\"frame_completion_cycles\\\":[";
      for (size_t i=0; i<frames.size(); ++i) std::cout << (i ? "," : "") << frames[i];
      std::cout << "]}}\\n";
      return 0;
    }}
  }}
  std::cerr << "Cycle limit exceeded; received " << received << " of " << expected.size() << '\\n';
  return 1;
}}
"""
(args.output / "simulate.cpp").write_text(bench)
with (args.output / "build.log").open("w") as log:
    subprocess.run(["verilator", "--cc", "--exe", "--build", "--top-module", "inference",
                    "--Mdir", "obj_dir", "inference.sv", "simulate.cpp", "-o", "sim"],
                   cwd=args.output, check=True, stdout=log, stderr=subprocess.STDOUT)
result = subprocess.run(["obj_dir/sim"], cwd=args.output, text=True, capture_output=True)
(args.output / "simulation.log").write_text(result.stdout + result.stderr)
result.check_returncode()
report = json.loads(result.stdout)
report["stalls"] = args.stalls
report["bit_exact"] = True
report["scheduled_transfers"] = bool(args.input_cycles)
(args.output / "report.json").write_text(json.dumps(report, indent=2) + "\n")
print(json.dumps(report, indent=2))
