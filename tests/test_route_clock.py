import json
from pathlib import Path
import runpy
import subprocess
import sys

import pytest


def test_generated_clock_holds_reset_until_lock_and_restarts_after_lock_loss(tmp_path, monkeypatch):
    (tmp_path/'core.sv').write_text("""
module inference(input clk, rst, input [7:0] in_data, input in_valid,
                 output in_ready, output [7:0] out_data, output out_valid, input out_ready);
  assign in_ready = !rst && out_ready;
  assign out_valid = !rst && in_valid;
  assign out_data = in_data;
endmodule
""")
    (tmp_path/'clock.sv').write_text("""
module inference_clock(input clock_in, output clock_out, output reg locked = 0);
  assign clock_out = clock_in;
endmodule
""")
    target = {"synthesis": {"command": "synth_gowin"}, "clock_hz": 10_000_000,
              "place_route": {"executable": "nextpnr", "device": "supplied", "family": "supplied"}}
    (tmp_path/'target.json').write_text(json.dumps(target))
    script = Path(__file__).parents[1]/'scripts/route-smoke.py'
    command = [str(script), '--rtl', str(tmp_path/'core.sv'), '--target', str(tmp_path/'target.json'),
               '--input-bits', '8', '--output-bits', '8', '--constraints', str(tmp_path/'pins.cst'),
               '--output', str(tmp_path), '--clock-rtl', str(tmp_path/'clock.sv'), '--reference-clock-hz', '10000000']

    class HarnessReady(Exception):
        pass

    def stop_before_tools(*args, **kwargs):
        raise HarnessReady()

    with monkeypatch.context() as patch:
        patch.setattr(sys, 'argv', command)
        patch.setattr(subprocess, 'run', stop_before_tools)
        with pytest.raises(HarnessReady):
            runpy.run_path(str(script), run_name='__main__')
    (tmp_path/'test.sv').write_text("""
module test;
  reg clk = 0, rst = 0;
  wire observed;
  harness dut(.*);
  always #5 clk = !clk;
  task tick; begin @(posedge clk); #1; end endtask
  initial begin
    repeat (3) tick;
    if (dut.core_reset !== 1 || dut.source !== 0) $fatal(1, "unlocked core ran");
    @(negedge clk); dut.clock_source.locked = 1;
    tick;
    if (dut.core_reset !== 1) $fatal(1, "reset released before synchronization");
    tick;
    if (dut.core_reset !== 0 || dut.source !== 0) $fatal(1, "incorrect reset release");
    tick;
    if (dut.source !== 1) $fatal(1, "locked core did not start");
    @(negedge clk); dut.clock_source.locked = 0; #1;
    if (dut.core_reset !== 1) $fatal(1, "lock loss did not assert reset asynchronously");
    tick;
    if (dut.source !== 0) $fatal(1, "lock loss did not clear core");
    @(negedge clk); dut.clock_source.locked = 1; rst = 1;
    repeat (2) tick;
    if (dut.core_reset !== 1) $fatal(1, "external reset ignored");
    @(negedge clk); rst = 0;
    repeat (3) tick;
    if (dut.source !== 1) $fatal(1, "core did not restart after reset");
    $display("clock reset passed");
    $finish;
  end
endmodule
""")
    subprocess.run(['iverilog', '-g2012', '-s', 'test', '-o', 'sim', 'harness.sv', 'test.sv'],
                   cwd=tmp_path, capture_output=True, text=True, check=True, timeout=30)
    result = subprocess.run(['vvp', 'sim'], cwd=tmp_path, capture_output=True, text=True, timeout=30)
    assert result.returncode == 0, result.stdout+result.stderr
    assert 'clock reset passed' in result.stdout
