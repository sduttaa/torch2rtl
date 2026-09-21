"""Compare all hard-block input pins with their outputs treated as free inputs."""
import argparse
import copy
import json
from pathlib import Path
import subprocess
import time

p=argparse.ArgumentParser()
for name in ('before','after','output'):p.add_argument('--'+name,type=Path,required=True)
a=p.parse_args();a.output.mkdir(parents=True,exist_ok=True)
def cut(path):
 j=json.loads(path.read_text());m=next(m for m in j['modules'].values() if m.get('attributes',{}).get('top') in ('1','00000000000000000000000000000001'))
 sources={};sinks={};hard={};logic={};constants={}
 for name,port in m['ports'].items():
  for i,bit in enumerate(port['bits']):(sources if port['direction']=='input' else sinks)[('top',name,i)]=bit
 for name,c in m['cells'].items():
  if c['type'] in ('VCC','GND'):
   for port,bits in c['connections'].items():
    if c['port_directions'][port]=='output':constants.update({b:'1' if c['type']=='VCC' else '0' for b in bits})
  elif c['type'] in ('LUT1','LUT2','LUT3','LUT4'):logic[name]=copy.deepcopy(c)
  else:
   hard[name]=(c['type'],c['parameters'],c['port_directions'])
   for port,bits in c['connections'].items():
    for i,bit in enumerate(bits):(sources if c['port_directions'][port]=='output' else sinks)[(name,port,i)]=bit
 for c in logic.values():
  c['connections']={p:[constants.get(b,b) for b in bs] for p,bs in c['connections'].items()}
 inputs=[sources[k] for k in sorted(sources)]
 assert all(isinstance(b,int) for b in inputs) and len(set(inputs))==len(inputs), 'Cut sources must be independent'
 module={'attributes':{},'ports':{'source':{'direction':'input','bits':inputs},'sink':{'direction':'output','bits':[constants.get(sinks[k],sinks[k]) for k in sorted(sinks)]}},'cells':logic,'netnames':{}}
 return module,hard,set(sources),set(sinks)
before,hb,sb,ob=cut(a.before);after,ha,sa,oa=cut(a.after)
assert hb==ha and sb==sa and ob==oa, 'Remapping changed hard blocks or cut endpoints'
(a.output/'cuts.json').write_text(json.dumps({'modules':{'before':before,'after':after}}))
(a.output/'prove.ys').write_text('''read_verilog +/gowin/cells_sim.v
read_json cuts.json
proc
flatten before after
opt_clean
equiv_make before after equiv
hierarchy -top equiv
equiv_simple
equiv_status -assert
''')
start=time.monotonic()
with (a.output/'proof.log').open('w') as log:
 result=subprocess.run(['yosys','-Q','-T','-s','prove.ys'],cwd=a.output,stdout=log,stderr=subprocess.STDOUT,timeout=180)
report={'passed':result.returncode==0,'hard_blocks':len(hb),'input_bits':len(sb),'compared_pins':len(ob),'seconds':time.monotonic()-start}
(a.output/'report.json').write_text(json.dumps(report,indent=2)+'\n');print(report,flush=True)
raise SystemExit(result.returncode)
