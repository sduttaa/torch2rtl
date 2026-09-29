"""Deterministic integer graphs described by benchmark input data."""

import torch
from torch import nn
from torch.nn import functional as F


class IntegerGraph(nn.Module):
    def __init__(self,case):
        super().__init__()
        self.nodes=case["nodes"]
        self.output=case["output"]
        channels={"input":case["shape"][1]}
        generator=torch.Generator().manual_seed(case["seed"])
        for index,node in enumerate(self.nodes):
            inputs=node["inputs"]
            incoming=sum(channels[name] for name in inputs)
            if node["op"]=="conv":
                shape=(node["channels"],incoming//node.get("groups",1),*node["kernel"])
                self.register_buffer(f"weight_{index}",torch.randint(-3,4,shape,generator=generator,dtype=torch.int32))
                self.register_buffer(f"bias_{index}",torch.randint(-8,9,(node["channels"],),generator=generator,dtype=torch.int32))
                self.register_buffer(f"scale_{index}",torch.tensor(node.get("multiplier",1),dtype=torch.int64))
            if node["op"]=="concat":
                for port,scale in enumerate(node["multipliers"]):
                    self.register_buffer(f"scale_{index}_{port}",torch.tensor(scale,dtype=torch.int64))
            channels[node["name"]]=node.get("channels",incoming)

    def forward(self,image):
        values={"input":image}
        for index,node in enumerate(self.nodes):
            inputs=[values[name] for name in node["inputs"]]
            operation=node["op"]
            if operation=="conv":
                weight,bias=getattr(self,f"weight_{index}"),getattr(self,f"bias_{index}")
                dilation=node.get("dilation",1)
                stride=node.get("stride",1)
                padding=node.get("padding",0)
                if dilation==1:
                    value=F.conv2d(inputs[0].to(torch.int32),weight,bias,stride=stride,padding=padding,groups=node.get("groups",1))
                else:
                    # ATen's CPU dilation kernel lacks integer arithmetic. This
                    # equivalent exported unfold/matmul form keeps it exact.
                    if node.get("groups",1)!=1:
                        raise ValueError("Benchmark dilated reference requires groups=1")
                    kh,kw=node["kernel"]
                    padded=F.pad(inputs[0].to(torch.int32),(padding,padding,padding,padding))
                    patches=padded.unfold(2,(kh-1)*dilation+1,stride).unfold(3,(kw-1)*dilation+1,stride)
                    patches=patches[...,::dilation,::dilation].permute(0,2,3,1,4,5).flatten(3)
                    value=(patches@weight.flatten(1).t()).permute(0,3,1,2)+bias[None,:,None,None]
                value=value.to(torch.int64)*getattr(self,f"scale_{index}")
            elif operation=="pool":
                value=F.max_pool2d(inputs[0],node["kernel"],node.get("stride",node["kernel"]))
            elif operation=="resize":
                value=F.interpolate(inputs[0],size=node["size"],mode=node["mode"])
            elif operation=="concat":
                value=torch.cat([data.to(torch.int64)*getattr(self,f"scale_{index}_{port}") for port,data in enumerate(inputs)],dim=1)
            else:
                raise ValueError(f"Unsupported benchmark operation: {operation}")
            if operation in {"conv","concat"}:
                value=((value+node["offset"])>>node["shift"]).clamp(node["low"],node["high"])
                value=value.to(torch.int8 if node["low"]<0 else torch.uint8)
            values[node["name"]]=value
        return values[self.output]
