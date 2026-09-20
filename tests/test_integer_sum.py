from pathlib import Path
import subprocess

import pytest

from torch2rtl import convolution


@pytest.mark.parametrize("words,bits", [(1, 5), (2, 8), (3, 8), (5, 18), (9, 2)])
def test_compressor_sum_is_exact_modular_addition(tmp_path, words, bits):
    source = (Path(convolution.__file__).parent / "templates/convolution.sv").read_text()
    source += f"""
module proof(input wire [{words*bits-1}:0] values);
  wire [{bits-1}:0] actual;
  reg [{bits-1}:0] expected;
  integer i;
  integer_sum #(.WORDS({words}), .BITS({bits})) dut(.values(values), .sum(actual));
  always @* begin
    expected = 0;
    for (i=0; i<{words}; i=i+1) expected = expected + values[i*{bits} +: {bits}];
    assert (actual == expected);
  end
endmodule
"""
    (tmp_path / "sum.sv").write_text(source)
    script = "read_verilog -formal -sv sum.sv; prep -top proof -flatten; chformal -lower; sat -prove-asserts -verify"
    result = subprocess.run(["yosys", "-Q", "-T", "-p", script], cwd=tmp_path,
                            capture_output=True, text=True, timeout=30)
    assert result.returncode == 0, result.stdout + result.stderr
