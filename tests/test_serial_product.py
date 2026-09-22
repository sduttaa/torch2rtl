from pathlib import Path
import subprocess

import pytest

from torch2rtl import convolution


@pytest.mark.parametrize('value_bits,coefficient_bits', [(1,1),(5,1),(3,4),(5,3)])
@pytest.mark.parametrize('signed', [False,True])
def test_serial_product_for_all_operand_bits(tmp_path,value_bits,coefficient_bits,signed):
    source=(Path(convolution.__file__).parent/'templates/convolution.sv').read_text()
    source+=f'''
module proof(input wire clk,
  input wire signed [{value_bits-1}:0] value,
  input wire [{coefficient_bits-1}:0] coefficient);
  reg [{coefficient_bits+1}:0] phase=1;
  reg signed [{value_bits-1}:0] held_value;
  reg [{coefficient_bits-1}:0] held_coefficient;
  wire signed [{value_bits+coefficient_bits-1}:0] product;
  wire signed [{coefficient_bits}:0] extended_coefficient=
    {{{int(signed)} && held_coefficient[{coefficient_bits-1}],held_coefficient}};
  wire signed [{value_bits+coefficient_bits-1}:0] expected=held_value*extended_coefficient;
  serial_product #(.VALUE_BITS({value_bits}),.COEFFICIENT_BITS({coefficient_bits}),
    .SIGNED_COEFFICIENT({int(signed)})) dut(
    .clk(clk),.start(phase[0]),.step(|phase[{coefficient_bits}:1]),
    .last(phase[{coefficient_bits}]),.value(held_value),.coefficient(coefficient),.product(product));
  always @(posedge clk) begin
    phase <= phase << 1;
    if (phase[0]) begin held_value <= value; held_coefficient <= coefficient; end
  end
  always @* if (phase[{coefficient_bits+1}]) assert(product == expected);
endmodule
'''
    (tmp_path/'product.sv').write_text(source)
    script=('read_verilog -formal -sv product.sv; prep -top proof -flatten; chformal -lower; '
            f'sat -seq {coefficient_bits+3} -set-init-zero -prove-asserts -verify')
    result=subprocess.run(['yosys','-Q','-T','-p',script],cwd=tmp_path,capture_output=True,text=True,timeout=30)
    assert result.returncode==0,result.stdout+result.stderr
