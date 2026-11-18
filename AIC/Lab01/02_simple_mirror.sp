* AIC Lab 01 - Simple mirror ratios and original four output voltages
* Handout: AIC Lab.pdf, PDF pages 4-7 (one-based physical pages).
* supplied-model adaptation: 1 V is a teaching assumption, NOT a verified model rating.
* The original 0.35 um / 3.3 V numerical results are NOT supplied-model specifications.
* Device geometry is not blindly scaled to 90 nm.
* Nominal reference is 50 uA; separate 10 uA and 1 uA alters show headroom.
* Ideal current sources do NOT enforce supply compliance. Check every bias node.
* MODEL_SETUP_REQUIRED
.option post=2 runlvl=5 accurate measdgt=8 numdgt=8 ingold=2
.temp 27
.param VDDVAL=1.0 IREFVAL=50u WUNIT=3u LUNIT=1.4u
VDD vdd 0 'VDDVAL'
IREF vdd ref 'IREFVAL'
M0 ref ref 0 0 nmos w='WUNIT' l='LUNIT'
* Fixed-output example from handout p5, kept separately from compliance sweep.
VO1 o1 0 1.0 ac 0
VO2 o2 0 0.6 ac 0
VO3 o3 0 0.3 ac 0
VO4 o4 0 0.1 ac 0
VS1 o1 d1 0
VS2 o2 d2 0
VS3 o3 d3 0
VS4 o4 d4 0
M1 d1 ref 0 0 nmos w='WUNIT' l='LUNIT' m=2
M2 d2 ref 0 0 nmos w='WUNIT' l='LUNIT' m=4
M3 d3 ref 0 0 nmos w='WUNIT' l='LUNIT' m=8
M4 d4 ref 0 0 nmos w='WUNIT' l='LUNIT' m=16
* Independent 1:2 replica for equal-point comparisons against other mirrors.
VTEST out 0 0.8 ac 1
VS out ds 0
MS ds ref 0 0 nmos w='WUNIT' l='LUNIT' m=2
.op
.dc VTEST 0 'VDDVAL' 0.001
.ac dec 20 1 1meg
.print dc v(out) v(ref) i(VS) i(VS1) i(VS2) i(VS3) i(VS4)
+ rout=par('1/max(abs(lx8(MS)),1e-30)')
* Saturation is checked from HSPICE .op region and vds/vdsat, not guessed LX indices.
.print ac im(VS)
.measure dc iout find i(VS) at=0.8
.measure dc i1 find i(VS1) at=0.8
.measure dc i2 find i(VS2) at=0.8
.measure dc i3 find i(VS3) at=0.8
.measure dc i4 find i(VS4) at=0.8
.measure dc vref find v(ref) at=0.8
.measure dc isupply find i(VDD) at=0.8
.measure ac gout find im(VS) at=1
.measure ac rout param='1/gout'
* Fixed-output branch intrinsic ro=1/gds is taken from its .op table.
* Only VTEST has AC=1. Other output ports must be AC-grounded for port Rout.

.measure ac phase_vs find ip(VS) at=1
.alter lower_current_10u
.param IREFVAL=10u WUNIT=3u
.alter lower_current_1u
.param IREFVAL=1u WUNIT=3u
.alter resized_50u_w30u
.param IREFVAL=50u WUNIT=30u
.end
