import json
from pathlib import Path
import runpy
import subprocess
import sys

import pytest

from torch2rtl import gowin


@pytest.mark.parametrize('achieved,error,expected',[
    (110.5,None,'bitstream'),
    (99.2,"Max frequency for clock 'core': 99.20 MHz (FAIL at 108.00 MHz)",'report'),
    (99.2,"Hold/min time violation for clock 'core':",'failure'),
    (99.2,"Unable to route net",'failure'),
])
def test_route_reports_frequency_miss_without_packing_unsafe_bitstream(tmp_path,monkeypatch,achieved,error,expected):
    target={'clock_hz':108_000_000,'resources':{'lut_sites':100},
            'synthesis':{'command':'synth_gowin'},
            'place_route':{'executable':'fake-nextpnr','device':'supplied','family':'supplied'}}
    (tmp_path/'target.json').write_text(json.dumps(target))
    (tmp_path/'core.sv').write_text('module inference; endmodule\n')
    monkeypatch.setattr(gowin,'map_netlist',lambda *args:tmp_path/'netlist.json')
    packed=[]

    def run(command,**kwargs):
        command=[str(value) for value in command]
        status=0
        if command[0]=='yosys':
            (tmp_path/'netlist.json').write_text('{}')
        elif command[0]=='fake-nextpnr':
            packing='--pack-only' in command
            report={'utilization':{'LUT4':{'used':10,'available':100}},
                    'fmax':{'core':{'achieved':achieved,'constraint':108}}}
            (tmp_path/('packing-report.json' if packing else 'route-report.json')).write_text(json.dumps(report))
            (tmp_path/('packed.json' if packing else 'routed.json')).write_text('{}')
            if error and not packing:
                kwargs['stdout'].write('ERROR: '+error+'\n')
                status=1
        elif len(command)>1 and command[1].endswith('check-gowin-capacity.py'):
            (tmp_path/'capacity.json').write_text(json.dumps({
                'lut_site_lower_bound':10,'lut_sites_available':100,'routed_logic_sites':12}))
        elif command[0]=='gowin_pack':
            packed.append(True)
            (tmp_path/'harness.fs').write_text('test bitstream')
        else:
            raise AssertionError(command)
        return subprocess.CompletedProcess(command,status)

    monkeypatch.setattr(subprocess,'run',run)
    script=Path(__file__).parents[1]/'scripts/route-smoke.py'
    monkeypatch.setattr(sys,'argv',[str(script),'--rtl',str(tmp_path/'core.sv'),
        '--input-bits','8','--output-bits','8','--target',str(tmp_path/'target.json'),
        '--constraints',str(tmp_path/'pins.cst'),'--output',str(tmp_path)])
    if expected=='failure':
        with pytest.raises(subprocess.CalledProcessError):
            runpy.run_path(str(script),run_name='__main__')
        assert not packed
        assert not (tmp_path/'toolflow-summary.json').exists()
    else:
        runpy.run_path(str(script),run_name='__main__')
        report=json.loads((tmp_path/'toolflow-summary.json').read_text())
        assert report['tool_timing_checks_passed']==(expected=='bitstream')
        assert bool(packed)==(expected=='bitstream')
        assert (tmp_path/'harness.fs').exists()==(expected=='bitstream')
