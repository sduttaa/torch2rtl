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
