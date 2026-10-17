* AIC Lab 01 - High-swing cascode and bias-device sizing
* Handout: AIC Lab.pdf, PDF pages 10-12 (one-based physical pages).
* supplied-model adaptation: 1 V is a teaching assumption, NOT a verified model rating.
* The original 0.35 um / 3.3 V numerical results are NOT supplied-model specifications.
* Device geometry is not blindly scaled to 90 nm.
* Nominal reference is 50 uA; separate 10 uA and 1 uA alters show headroom.
* Ideal current sources do NOT enforce supply compliance. Check every bias node.
.include '../../models/process.lib'
.option post=2 runlvl=5 accurate measdgt=8 numdgt=8 ingold=2
.temp 27
.param VDDVAL=1.0 IREFVAL=50u WUNIT=3u LUNIT=1.4u
* M4 length 7u follows handout p11, with W=3u (not a 90nm minimum).
.param LBIAS=7u
VDD vdd 0 'VDDVAL'
IREF vdd rtop 'IREFVAL'
IBIAS vdd bias 'IREFVAL'
M4 bias bias 0 0 nmos w='WUNIT' l='LBIAS'
M0 ref rtop 0 0 nmos w='WUNIT' l='LUNIT'
M1 mid rtop 0 0 nmos w='WUNIT' l='LUNIT' m=2
M2 rtop bias ref 0 nmos w='WUNIT' l='LUNIT'
M3 drain bias mid 0 nmos w='WUNIT' l='LUNIT' m=2
VTEST out 0 0.8 ac 1
VS out drain 0
.op
.dc VTEST 0 'VDDVAL' 0.001
.ac dec 20 1 1meg
.print dc v(out) v(ref) v(bias) v(mid) i(VS)
.print ac im(VS)
.measure dc iout find i(VS) at=0.8
.measure dc vref find v(ref) at=0.8
.measure dc vbias find v(bias) at=0.8
.measure dc vmid find v(mid) at=0.8
.measure dc isupply find i(VDD) at=0.8
.measure ac gout find im(VS) at=1
.measure ac rout param='1/gout'

.print dc v(rtop)
.measure ac phase_vs find ip(VS) at=1
.alter lower_current_10u
.param IREFVAL=10u WUNIT=3u
.alter lower_current_1u
.param IREFVAL=1u WUNIT=3u
.alter resized_50u_w30u
.param IREFVAL=50u WUNIT=30u

.alter bias_length_350u_at_1u
.param IREFVAL=1u WUNIT=3u LBIAS=3.5u
.alter bias_length_1400u_at_1u
.param IREFVAL=1u WUNIT=3u LBIAS=14u
.end
