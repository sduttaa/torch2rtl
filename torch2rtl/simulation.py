"""Drive generated hardware with independent PyTorch vectors and backpressure."""

from pathlib import Path
import subprocess


def simulate(directory: Path, rtl: str, input_bits: int, output_bits: int,
             input_words: list[int], expected_words: list[int], stalls: bool, max_cycles: int | None = None,
             transfer_cycles: tuple[list[int], list[int]] | None = None, reset_after: int | None = None):
    if reset_after is not None and (type(reset_after) is not int or reset_after<1):
        raise ValueError("reset_after must be a positive cycle")
    if max_cycles is None:
        max_cycles = 100 + (len(input_words) + len(expected_words)) * 30
    directory.mkdir(parents=True, exist_ok=True)
    (directory / "inference.sv").write_text(rtl)
    (directory / "input.hex").write_text("\n".join(f"{x:x}" for x in input_words) + "\n")
    (directory / "expected.hex").write_text("\n".join(f"{x:x}" for x in expected_words) + "\n")
    schedule_declarations = schedule_initial = schedule_checks = ""
    input_offer = f"({int(not stalls)} || random_state[0])"
    output_ready = f"{int(not stalls)} || random_state[1]"
    if transfer_cycles is not None:
        input_cycles, output_cycles = transfer_cycles
        assert len(input_cycles) == len(input_words) and len(output_cycles) == len(expected_words)
        assert all(a < b for a, b in zip(input_cycles, input_cycles[1:]))
        assert all(a < b for a, b in zip(output_cycles, output_cycles[1:]))
        (directory / "input_cycles.hex").write_text("\n".join(f"{t:x}" for t in input_cycles)+"\n")
        (directory / "output_cycles.hex").write_text("\n".join(f"{t:x}" for t in output_cycles)+"\n")
        schedule_declarations = f"integer input_cycles [0:{len(input_words)-1}]; integer output_cycles [0:{len(expected_words)-1}];"
        schedule_initial = '$readmemh("input_cycles.hex",input_cycles); $readmemh("output_cycles.hex",output_cycles);'
        input_offer = "cycle+1 >= input_cycles[sent]"
        output_ready = f"received < {len(expected_words)} && cycle+1 == output_cycles[received]"
        schedule_checks = f"""
      if (input_accepted && cycle != input_cycles[sent]) $fatal(1, "Late input %0d at %0d, scheduled %0d", sent, cycle, input_cycles[sent]);
      if (received < {len(expected_words)} && cycle == output_cycles[received] && !out_valid)
        $fatal(1, "Late output %0d at scheduled cycle %0d", received, cycle);
"""
    restart="" if reset_after is None else f"""
    wait(cycle >= {reset_after});
    @(negedge clk); rst=1; in_valid=0; out_ready=0;
    $display("RESET");
    repeat(3) @(negedge clk);
    rst=0; restart_complete=1;
"""
    bench = f"""
module tb;
  reg clk=0;
  always #5 clk=~clk;
  reg rst=1;
  reg restart_complete={int(reset_after is None)};
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
  {schedule_declarations}
  initial begin
    $readmemh("input.hex",inputs);
    $readmemh("expected.hex",expected);
    {schedule_initial}
    repeat(3) @(negedge clk);
    rst=0;
    {restart}
  end
  always @(negedge clk) begin
    if (!rst) begin
      random_state = random_state ^ (random_state << 13);
      random_state = random_state ^ (random_state >> 17);
      random_state = random_state ^ (random_state << 5);
      // Hold an offered input word until it is accepted.
      if (!in_valid || input_accepted) begin
        in_valid = sent < {len(input_words)} && ({input_offer});
        if (sent < {len(input_words)}) in_data = inputs[sent];
      end
      out_ready = {output_ready};
    end
  end
  always @(posedge clk) begin
    if (rst) begin
      sent=0; received=0; cycle=0; was_stalled=0; input_accepted=0;
    end else begin
      cycle = cycle+1;
      if (was_stalled && (!out_valid || out_data !== held_data))
        $fatal(1,"Output changed while stalled");
      was_stalled = out_valid && !out_ready;
      held_data = out_data;
      input_accepted = in_valid && in_ready;
      {schedule_checks}
      if (input_accepted) begin
        $display("INPUT %0d %0d",sent,cycle);
        sent=sent+1;
      end
      if (out_valid && out_ready) begin
        if (received >= {len(expected_words)} || out_data !== expected[received])
          $fatal(1,"Mismatch word %0d: actual %h expected %h",received,out_data,expected[received]);
        $display("OUTPUT %0d %0d",received,cycle);
        received=received+1;
        if (received == {len(expected_words)} && restart_complete) begin
          $display("PASS %0d words in %0d cycles",received,cycle);
          $finish;
        end
      end
      if (cycle > {max_cycles})
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
    return [int(line.split()[2]) for line in result.stdout.rsplit("RESET",1)[-1].splitlines() if line.startswith("OUTPUT")]


def pack(values, bits, lanes):
    words = []
    values = list(values)
    for start in range(0, len(values), lanes):
        words.append(sum((int(value) & ((1 << bits) - 1)) << (index * bits)
                         for index, value in enumerate(values[start:start + lanes])))
    return words
