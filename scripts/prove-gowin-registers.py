import argparse
import copy
import json
from pathlib import Path
import subprocess

p=argparse.ArgumentParser()
p.add_argument('--before',type=Path,required=True);p.add_argument('--after',type=Path,required=True);p.add_argument('--mapping',type=Path,required=True);p.add_argument('--output',type=Path,required=True)
a=p.parse_args();a.output.mkdir(parents=True,exist_ok=True)
before=json.loads(a.before.read_text());after=json.loads(a.after.read_text());mapping=json.loads(a.mapping.read_text())
inputs={};outputs={};before_cells={};after_cells={}
for change in mapping['changes']:
 module=change['module'];name=change['multiplier'];old=before['modules'][module]['cells'][name];new=after['modules'][module]['cells'][name]
 before_cells[name]=copy.deepcopy(old);after_cells[name]=copy.deepcopy(new)
 for reg in change['removed_registers']:before_cells[reg]=copy.deepcopy(before['modules'][module]['cells'][reg])
 for cell in [old,new,*[before_cells[r] for r in change['removed_registers']]]:
  for port,bits in cell['connections'].items():
   if cell['port_directions'][port]=='input':
    for bit in bits:
     if isinstance(bit,int):inputs[bit]={'direction':'input','bits':[bit]}
 for reg in change['removed_registers']:
  bit=before_cells[reg]['connections']['Q'][0];outputs[bit]={'direction':'output','bits':[bit]}
for cell in before_cells.values():
 for port,bits in cell['connections'].items():
  if cell['port_directions'][port]=='output':
   for bit in bits:inputs.pop(bit,None)
ports={**{f'in_{b}':v for b,v in inputs.items()},**{f'out_{b}':v for b,v in outputs.items()}}
for label,cells in [('before',before_cells),('after',after_cells)]:
 fragment={'modules':{'fragment':{'attributes':{},'ports':ports,'netnames':{n:{'hide_name':0,'bits':v['bits'],'attributes':{}} for n,v in ports.items()},'cells':cells}}}
 (a.output/(label+'.json')).write_text(json.dumps(fragment))
(a.output/'model.sv').write_text('''// Functional contract from Gowin UG287: bypassed inputs/pipeline and optional CE output register.
module MULT9X9(input [8:0] A, B, SIA, SIB, input ASIGN, BSIGN, ASEL, BSEL, CE, CLK, RESET,
              output [17:0] DOUT, output [8:0] SOA, SOB);
 parameter AREG=0, BREG=0, OUT_REG=0, PIPE_REG=0, ASIGN_REG=0, BSIGN_REG=0, SOA_REG=0;
 parameter MULT_RESET_MODE="SYNC";
 wire signed [9:0] a_value={ASIGN && A[8],A};
 wire signed [9:0] b_value={BSIGN && B[8],B};
 wire [17:0] product=a_value*b_value;
 reg [17:0] held;
 always @(posedge CLK) if (RESET) held<=0; else if (CE) held<=product;
 assign DOUT=OUT_REG ? held : product;
 assign SOA=A; assign SOB=B;
endmodule
module DFFE(input CLK,D,CE,output reg Q); always @(posedge CLK) if(CE) Q<=D; endmodule
module DFF(input CLK,D,output reg Q); always @(posedge CLK) Q<=D; endmodule
module GND(output G); assign G=0; endmodule
module VCC(output V); assign V=1; endmodule
''')
# Include physical constant drivers referenced by the fragments as values.
for label in ('before','after'):
 path=a.output/(label+'.json');design=json.loads(path.read_text());fragment=design['modules']['fragment']
 for module in before['modules'].values():
  for name,cell in module.get('cells',{}).items():
   if cell['type'] in ('GND','VCC'):
    fragment['cells'][name]=cell
    for bit in next(iter(cell['connections'].values())):
     fragment['ports'].pop(f'in_{bit}',None)
 path.write_text(json.dumps(design))
script='''read_verilog -formal -sv model.sv
read_json before.json
hierarchy -top fragment
proc; flatten; opt
rename -hide
rename fragment gold
design -stash gold
read_verilog -formal -sv model.sv
read_json after.json
hierarchy -top fragment
proc; flatten; opt
rename -hide
rename fragment gate
design -stash gate
design -copy-from gold -as gold gold
design -copy-from gate -as gate gate
equiv_make gold gate equiv
hierarchy -top equiv
equiv_simple
equiv_induct -seq 3
equiv_status -assert
'''
(a.output/'proof.ys').write_text(script)
with (a.output/'proof.log').open('w') as log:
 result=subprocess.run(['yosys','-Q','-T','-s','proof.ys'],cwd=a.output,stdout=log,stderr=subprocess.STDOUT,timeout=120)
report={'returncode':result.returncode,'multipliers':mapping['multipliers'],'register_bits':mapping['removed_registers'],'reference':'Gowin UG287 optional output-register functional contract; not timing or transistor-level validation','sources':{k:str(getattr(a,k)) for k in ('before','after','mapping')}}
(a.output/'report.json').write_text(json.dumps(report,indent=2)+'\n');print(report)
raise SystemExit(result.returncode)
