# Timing coverage audit

**The existing nextpnr timing passes do not establish complete timing closure.**
The 6,262,820-cycle schedule and bit-exact RTL results remain valid. Dividing
135 MHz by that period gives 21.56 scheduled FPS, conditional on that clock
being safe. Placement and bitstream packing succeeded, but the clock has not
been verified across all datapaths or tested on hardware. This correction
supersedes earlier descriptions of 21.56 FPS as a verified physical result.

An audit of the installed nextpnr source and the timing tables generated from
its actual Apicula database found:

- No `MULT9X9` timing variant. The routed design has 59 such cells. The database
  has no DSP timing group, and Apicula's `parse_dsp` function is unimplemented.
- Only `LUT4` has a timing variant; the routed netlist also contains 161 `LUT1`,
  2,964 `LUT2` and 4,493 `LUT3` cells. The Gowin architecture supplies no timing
  override for these types.
- The distributed RAM data-input timing entry spells `DI[n` without its closing
  bracket, leaving the actual `DI[n]` pins without their intended setup/hold arcs.

In this nextpnr revision, `Arch::get_port_timing_class_default` returns
`TMG_IGNORE` for cells with no timing variant. Therefore an ordinary timing
pass cannot prove these paths meet the configured period. Clock/constant/IO
bookkeeping types also lack variants; their appearance in the raw inventory
is not itself evidence of a datapath error.

The earlier BRAM B-address correction fixes a separate, real error. It does not
remedy these coverage gaps. No timing error suppression was used, but enabling
all existing checks is insufficient when checks are missing.

The audit reads the real database and generator for all eight speed grades.
Its input hashes and table inventory are in
[`build/verification/timing-coverage/report.json`](../build/verification/timing-coverage/report.json).
The local source revision is `3e53a0bf`. Relevant primary sources are the
[nextpnr generator](https://github.com/YosysHQ/nextpnr/blob/3e53a0bf/himbaechel/uarch/gowin/gowin_arch_gen.py),
[timing lookup](https://github.com/YosysHQ/nextpnr/blob/3e53a0bf/himbaechel/arch.cc),
and [Apicula timing parser](https://github.com/YosysHQ/apicula/blob/master/apycula/tm_parser.py).

The [device datasheet](https://cdn.gowinsemi.com.cn/DS226E.pdf), tables 3-15 and
3-16, lists register clock-to-output values and multiplier frequency limits.
Those aggregate numbers do not provide the missing pin-to-pin and setup/hold
arcs for the actual primitive configurations. They must not be substituted for
a complete timing model without further evidence.

The routing smoke script now labels its output as tool-reported timing with
coverage unverified. Completing the speed claim requires validated timing data
and path coverage, or independent vendor timing analysis; physical inference
measurement is a further, separate check. The 30-FPS goal remains incomplete.

## Verified local corrections

[`patches/nextpnr-gowin-logic-timing.patch`](../patches/nextpnr-gowin-logic-timing.patch)
adds `LUT1`, `LUT2` and `LUT3` variants using the corresponding physical LUT4
input arcs, and fixes the distributed RAM `DI[n]` spelling. All four LUT widths
and all four RAM data-input arcs pass regression checks for all eight speed
grades. The separately generated database is
`.tools/build/nextpnr-chipdb/logic-timing.bin`; the older databases are preserved.
The DSP timing omission remains unresolved.

A one-register LUT-feedback circuit provides a behavioral control for timing
coverage. With the previous database, nextpnr returns success but reports no
internal timing path and an empty Fmax table. With the correction, the identical
netlist has a reported clock path and a 1018.33 MHz setup limit. This tiny
control establishes that the LUT path is now analyzed; its speed is not a
network inference result.
[Before](../build/verification/timing-coverage/lut-feedback/physical/route-report.json),
[after](../build/verification/timing-coverage/lut-feedback/corrected/route-report.json),
[table regression](../build/verification/timing-coverage/regression.json).

Re-running the previous full model with these additional checks **fails at
135 MHz**, reporting a 65.1593 MHz setup limit. The critical path runs from a
convolution dot-step counter through window-address logic and distributed RAM
to the input-word register. The former 135-MHz timing pass is superseded.
DSP timing remains missing even in this stronger check, so 65.1593 MHz is not
a complete certified limit either.
[Full-model report](../build/verification/timing-coverage/full-model/route-report.json),
[database hashes and comparison](../build/verification/timing-coverage/correction-summary.json).

## Additional hardware validation risk

An upstream [Apicula issue](https://github.com/YosysHQ/apicula/issues/514)
reports incorrect silicon results for one composed ALU design on this device,
despite successful RTL and mapped-netlist simulation. Its reported workaround
is `synth_gowin -noalu`; the issue remains open. This is not evidence that our
design fails, nor that every ALU operation is affected. It does mean the custom
carry mapping and its functional equivalence proofs cannot establish correct
bitstream execution. Vendor comparison and eventual board tests must cover
this separately from the known timing omissions.

## Independent vendor analysis

The official native Gowin Education 1.9.11.03 installation now runs under
Documents. A one-multiplier test completes synthesis, placement/routing and
setup/hold analysis, emitting explicit DSP timing arcs in SDF.

The registered-FIFO-readiness network also completes an independent vendor run.
Yosys exports the mapped primitive netlist using `write_verilog -noattr -noexpr
-decimal`; the decimal option is necessary for the vendor's ALU parameter
parser. Gowin imports those primitives, synthesizes its netlist format and runs
its own placement/routing. The 27-MHz input constraint produces the intended
156-MHz generated PLL clock in the vendor report.

The vendor report **fails timing**, with **84.198 MHz Fmax**, 2,861 setup-violating
endpoints and no hold violations. It analyzes 37,866 paths and 19,933 endpoints.
The longest path starts at a DSP output and ends at a convolution accumulator,
with 11.842 ns reported data delay. All 86 output-registered multipliers appear
in the post-route model and SDF. This exposes a path omitted by the current
nextpnr DSP timing model. The vendor generated a bitstream despite timing
failure; file creation is not timing closure.

This run uses the configuration before the separate prefetch counter. It is
independent vendor routing, not timing certification of the nextpnr result;
mapped/post-route functional equivalence and physical-board execution have not
been established by this run. Full nextpnr DSP timing coverage remains open.
[Report, scope and hashes](../build/verification/vendor-timing/network-synthesis/summary.json).

## Registered DSP timing experiment and BRAM output correction

The explicit minimum carry width of eight maps the 15-bit accumulator that
previously used LUT arithmetic. The unchanged production RTL, with that mapping
and the existing DSP output-register packing, reaches **99.228 MHz** in the
independent vendor route, versus 84.198 MHz for the earlier configuration.
It still has 2,817 setup violations at 156 MHz and no hold violations.
The 5,033,085-cycle schedule needs 150.99255 MHz for 30 FPS.

All 86 registered multipliers have identical vendor SDF tables: 18 clock-output
arcs and 24 setup/hold pairs. An experimental database imports these data for
the supplied part/speed and exact primitive configuration only. A netlist guard
checks parameters, constant control inputs, bus widths and unused cascade
outputs. Negative controls reject a bypassed output register and a different
part. Explicit input data maps SDF names such as `A[0]` to packed names such as
`A0`; all 66 arcs, edge polarities and delay bounds are checked against the
generated table and packed netlist.

A DSP feedback circuit has no reported internal path with the previous database;
with the added arcs, nextpnr reports the register-to-multiplier path. This proves
the checks are active, not the physical speed of the small circuit. Formal
comparison also verifies all 1,298 absorbed register bits across 86 multipliers
for the carry-width-eight network.
[Experiment, controls and hashes](../build/verification/vendor-timing/registered-dsp-summary.json),
[packing proof](../build/verification/multiplier-registers/carry-min-8-prefetch/report.json).

The DSP-only reroute reports 103.3485 MHz. A subsequent audit found a further
coverage bug: dual-port BRAM B outputs are named `DOB0`, `DOB1`, etc. by the
packer, but their timing table used `DO0`, `DO1`, etc. The candidate has 26 such
memories with used B outputs. Therefore the 103.3485 MHz result is also partial.
The [BRAM output patch](../patches/nextpnr-gowin-bram-output-timing.patch) preserves
the existing B-port delay values and attaches them to the actual output names.
All four dual-port variants pass checks across all eight speed grades.
[Regression](../build/verification/timing-coverage/bram-output-regression.json),
[reusable checker](../scripts/check-gowin-timing.py).

The reroute with both scoped DSP arcs and corrected BRAM B outputs reports
**97.3994 MHz**, failing the required 156-MHz clock. Its longest reported path
runs from an actor's output-block counter to its window-offset register.
The independent vendor route of the same input netlist reports 99.228 MHz.
These are separate placements, and neither meets the 150.99255-MHz requirement.
[Latest report, scope and hashes](../build/network/registered-ready-prefetch/carry-min-8/registered-multipliers/dsp-bram-timing/summary.json).

The scoped DSP data does not apply to other register configurations or speeds,
and does not replace Apicula interconnect timing. Complete timing closure and
physical-board inference remain unverified. Two additional address/control RTL
experiments were numerically correct but increased area and failed to improve
vendor timing; neither is retained in production.
