"""Drive generated hardware with independent PyTorch vectors and backpressure."""

from pathlib import Path
import subprocess


def simulate(directory: Path, rtl: str, input_bits: int, output_bits: int,
             input_words: list[int], expected_words: list[int], stalls: bool):
    directory.mkdir(parents=True, exist_ok=True)
    (directory / "inference.sv").write_text(rtl)
    (directory / "input.hex").write_text("\n".join(f"{x:x}" for x in input_words) + "\n")
    (directory / "expected.hex").write_text("\n".join(f"{x:x}" for x in expected_words) + "\n")
    bench = f"""
module tb;
  reg clk=0;
  always #5 clk=~clk;
  reg rst=1;
  reg [{input_bits-1}:0] in_data=0;
  reg in_valid=0;
  wire in_ready;
  wire [{output_bits-1}:0] out_data;
  wire out_valid;
  reg out_ready=0;
  inference dut(.*);
  reg [{input_bits-1}:0] inputs [0:{len(input_words)-1}];
  reg [{output_bits-1}:0] expected [0:{len(expected_words)-1}];
  reg [31:0] random_state=32'h9e3779b9;
  integer sent=0, received=0, cycle=0;
  reg was_stalled=0;
  reg input_accepted=0;
  reg [{output_bits-1}:0] held_data;
  initial begin
    $readmemh("input.hex",inputs);
    $readmemh("expected.hex",expected);
    repeat(3) @(negedge clk);
    rst=0;
  end
  always @(negedge clk) begin
    if (!rst) begin
      random_state = random_state ^ (random_state << 13);
      random_state = random_state ^ (random_state >> 17);
      random_state = random_state ^ (random_state << 5);
      // Hold an offered input word until it is accepted.
      if (!in_valid || input_accepted) begin
        in_valid = sent < {len(input_words)} && ({int(not stalls)} || random_state[0]);
        if (sent < {len(input_words)}) in_data = inputs[sent];
      end
      out_ready = {int(not stalls)} || random_state[1];
    end
  end
  always @(posedge clk) begin
    if (!rst) begin
      cycle = cycle+1;
      if (was_stalled && (!out_valid || out_data !== held_data))
        $fatal(1,"Output changed while stalled");
      was_stalled = out_valid && !out_ready;
      held_data = out_data;
      input_accepted = in_valid && in_ready;
      if (input_accepted) begin
        $display("INPUT %0d %0d",sent,cycle);
        sent=sent+1;
      end
      if (out_valid && out_ready) begin
        if (received >= {len(expected_words)} || out_data !== expected[received])
          $fatal(1,"Mismatch word %0d: actual %h expected %h",received,out_data,expected[received]);
        $display("OUTPUT %0d %0d",received,cycle);
        received=received+1;
        if (received == {len(expected_words)}) begin
          $display("PASS %0d words in %0d cycles",received,cycle);
          $finish;
        end
      end
      if (cycle > {100 + (len(input_words) + len(expected_words)) * 30})
        $fatal(1,"Deadlock or missing outputs");
    end
  end
endmodule
"""
    (directory / "tb.sv").write_text(bench)
    subprocess.run(["iverilog", "-g2012", "-s", "tb", "-o", "sim", "inference.sv", "tb.sv"],
                   cwd=directory, check=True, capture_output=True, text=True)
    result = subprocess.run(["vvp", "sim"], cwd=directory, capture_output=True, text=True)
    (directory / "simulation.log").write_text(result.stdout)
    assert result.returncode == 0, result.stdout + result.stderr
    return [int(line.split()[2]) for line in result.stdout.splitlines() if line.startswith("OUTPUT")]


def pack(values, bits, lanes):
    words = []
    values = list(values)
    for start in range(0, len(values), lanes):
        words.append(sum((int(value) & ((1 << bits) - 1)) << (index * bits)
                         for index, value in enumerate(values[start:start + lanes])))
    return words
