import json
import subprocess

from rtl_check import simulate
from torch2rtl.graph import Graph,Value
from torch2rtl.link import prepare
from torch2rtl.lower import Tensor


def test_characterized_modules_link_without_internal_io_pads(tmp_path):
    source=Value('pixels','input',(),Tensor((1,1,2,3),8,False))
    output=Value('lookup','byte_lookup',(source,tuple(i^0xa7 for i in range(256))),source.tensor)
    graph=Graph(source,output,(source,output))
    config={'lanes':1,'output_lanes':{},'fifo_depths':{'pixels->lookup:0':1}}
    target={'synthesis':{'command':'synth_gowin','family':'gw2a'},'cell_costs':{'*':{'cells':1}}}
    prepare(graph,config,target,tmp_path/'cache',tmp_path/'linked')
    modules=json.loads((tmp_path/'linked/modules.json').read_text())['modules']
    assert all(c['type'] not in ('IBUF','OBUF') for m in modules.values() for c in m['cells'].values())
    script='read_verilog -sv +/gowin/cells_sim.v\nread_json modules.json\nread_verilog -sv structure.sv\nhierarchy -check -top inference\nproc\nflatten\nopt_clean\nwrite_verilog -noattr simulation.sv\n'
    subprocess.run(['yosys','-Q','-T','-p',script],cwd=tmp_path/'linked',check=True,capture_output=True,text=True)
    data=list(range(256))*2
    simulate(tmp_path/'simulation',(tmp_path/'linked/simulation.sv').read_text(),8,8,data,[i^0xa7 for i in data],True)
