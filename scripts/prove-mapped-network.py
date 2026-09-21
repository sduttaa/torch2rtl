"""Prove each distinct cached actor's register absorption and LUT remapping."""
import argparse
import json
from pathlib import Path
import subprocess
import sys

parser=argparse.ArgumentParser(description=__doc__)
parser.add_argument('--mapped',type=Path,required=True)
parser.add_argument('--output',type=Path,required=True)
args=parser.parse_args()
args.output.mkdir(parents=True,exist_ok=True)
evidence=json.loads((args.mapped/'evidence.json').read_text())
verified={}
for name,record in evidence.items():
    source=Path(record['netlist_path']).resolve()
    key=record['netlist_sha256']
    if key in verified:
        continue
    mapping=source.parent
    raw=Path(json.loads((mapping/'report.json').read_text())['raw_cache_path']).resolve()
    changes=json.loads((mapping/'register-packing.json').read_text())
    directory=args.output/name
    directory.mkdir(exist_ok=True)
    multipliers=changes.get('multipliers',0)
    if multipliers:
        command=[sys.executable,str(Path(__file__).with_name('prove-gowin-registers.py')),
                 '--before',str(raw/'netlist.json'),'--after',str(mapping/'registered.json'),
                 '--mapping',str(mapping/'register-packing.json'),'--output',str(directory/'registers')]
        with (directory/'registers.log').open('w') as log:
            subprocess.run(command,stdout=log,stderr=subprocess.STDOUT,check=True)
    command=[sys.executable,str(Path(__file__).with_name('prove-gowin-luts.py')),
             '--before',str(mapping/'registered.json'),'--after',str(source),'--output',str(directory/'luts')]
    with (directory/'luts.log').open('w') as log:
        subprocess.run(command,stdout=log,stderr=subprocess.STDOUT,check=True)
    verified[key]={'module':name,'multipliers':multipliers,'proofs':str(directory)}
    print(name,'proved',flush=True)
report={'passed':True,'distinct_modules':len(verified),'instances':len(evidence),'proofs':verified,
        'scope':'Functional equivalence of mapped actors; linking and timing have separate checks.'}
(args.output/'report.json').write_text(json.dumps(report,indent=2)+'\n')
