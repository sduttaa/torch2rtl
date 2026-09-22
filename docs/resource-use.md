# Resource attribution

The implementation's memory and logic serve the neural network and its internal
data movement. The toolflow harness supplies a counter stream and consumes a
checksum. It does not include camera transport or an external image
preprocessing pipeline. Inputs must already follow the exported model's input
contract; reported core throughput is not measured camera-to-output throughput.

## Accepted automatic route

The automatic `build/automatic-throughput/clock-margin` selection packs as:

| BRAM use | Blocks |
| --- | ---: |
| Network weight ROMs | 13 |
| Convolution line/window storage | 13 |
| Fused resize/concatenation source and branch storage | 8 |
| Standalone pooling storage | 1 |
| External actor-to-actor FIFOs | 0 |
| Total | 35 |

Thus 13 blocks hold weights and 22 hold intermediate activation data. Some
weights are implemented as logic ROMs, so the BRAM count is not the total weight
storage cost. FIFOs use registers or distributed memory; zero FIFO BRAM does
not mean zero FIFO area. The packed design uses 96 signed 9-by-9 multiplier
slots and has a 17,250-site mandatory logic lower bound. Actual occupied
physical logic positions, including placement-added pass-through LUTs and
distributed-memory reservations, are:

| Logic owner | Sites |
| --- | ---: |
| Neural actors only | 16,807 |
| Inter-actor FIFOs only | 436 |
| Sites shared by actor and FIFO cells | 193 |
| Harness and other logic | 91 |
| Total | 17,527 |

About 99.5% serves the network or its internal interconnect. The final byte
decision actor touches only eight sites. This leaves 3,209 of 20,736 physical
logic positions free (15.5%) and 473 sites below the requested 18,000-site cap.
The route passes 108 MHz with a reported 110.509-MHz limit, supporting the
verified 3,085,714-cycle / 35.0000032-FPS schedule. Evidence is in
[the packaged resource breakdown](../results/automatic-throughput/resource-breakdown.json).
The result is not a physical-board measurement.

The previous `occupancy-ready` route used 14 weight BRAMs, 12 convolution-window
BRAMs, 8 fused-source BRAMs and 1 pooling BRAM. Its 17,931 logic positions split
into 16,111 actor-only, 1,569 FIFO-only, 161 shared and 90 harness/other sites.
It also failed timing, at 99.24 MHz. Both measurements support the same conclusion
about network versus external processing cost.

Neural-actor logic includes accumulators/reduction trees, logic weight ROMs,
requantization, activation and pooling operations, address generation, memory
selection, registers and handshake control. Dedicated multiplier and BRAM
blocks are separate from the logic-site count. Synthesis merges these functions;
there is no measured mutually exclusive arithmetic/control breakdown yet.
Cached fan-in-cone counts overlap and must not be added as if they partitioned
the design.

The main storage opportunity is therefore activation reuse and lifetime within
the network. The main logic opportunity is its arithmetic, storage access and
flow-control implementation. External pre/postprocessing is not consuming a
large hidden fraction of this core.
