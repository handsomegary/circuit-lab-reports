* AIC Lab 01 - Wilson, modified Wilson and diode-swapped variant
* Handout: AIC Lab.pdf, PDF pages 13-17 (one-based physical pages).
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
VTEST out 0 0.8 ac 1
* Original Wilson, handout p16.
IW vdd rw 'IREFVAL'
MW0 rw mw 0 0 nmos w='WUNIT' l='LUNIT'
MW1 mw mw 0 0 nmos w='WUNIT' l='LUNIT' m=2
MW2 dw rw mw 0 nmos w='WUNIT' l='LUNIT' m=2
VSW out dw 0
* Modified Wilson: equalizes the input and output lower-device VDS.
IM vdd rm 'IREFVAL'
MM0 lm mm 0 0 nmos w='WUNIT' l='LUNIT'
MM3 rm rm lm 0 nmos w='WUNIT' l='LUNIT'
MM1 mm mm 0 0 nmos w='WUNIT' l='LUNIT' m=2
MM2 dm rm mm 0 nmos w='WUNIT' l='LUNIT' m=2
VSM out dm 0
* p17 Q1: swap which branch has diode-connected M0/M2 vs M1/M3.
* This is an experiment, not an asserted valid feedback mirror.
IQ vdd rq 'IREFVAL'
MQ0 lq lq 0 0 nmos w='WUNIT' l='LUNIT'
MQ3 rq dq lq 0 nmos w='WUNIT' l='LUNIT'
MQ1 mq lq 0 0 nmos w='WUNIT' l='LUNIT' m=2
MQ2 dq dq mq 0 nmos w='WUNIT' l='LUNIT' m=2
VSQ out dq 0
.op
.dc VTEST 0 'VDDVAL' 0.001
.ac dec 20 1 1meg
.print dc v(out) i(VSW) i(VSM) i(VSQ) v(rw) v(rm) v(rq)
+ v(mw) v(mm) v(mq) v(lm) v(lq)
.print ac im(VSW) im(VSM) im(VSQ)
.measure dc iwout find i(VSW) at=0.8
.measure dc imout find i(VSM) at=0.8
.measure dc iqout find i(VSQ) at=0.8
.measure dc vrw find v(rw) at=0.8
.measure dc vrm find v(rm) at=0.8
.measure dc vrq find v(rq) at=0.8
.measure dc isupply find i(VDD) at=0.8
.measure ac gw find im(VSW) at=1
.measure ac rwout param='1/gw'
.measure ac gm find im(VSM) at=1
.measure ac rmout param='1/gm'
.measure ac gq find im(VSQ) at=1
.measure ac rqout param='1/gq'

.measure ac phase_vsw find ip(VSW) at=1

.measure ac phase_vsm find ip(VSM) at=1

.measure ac phase_vsq find ip(VSQ) at=1
.alter lower_current_10u
.param IREFVAL=10u WUNIT=3u
.alter lower_current_1u
.param IREFVAL=1u WUNIT=3u
.alter resized_50u_w30u
.param IREFVAL=50u WUNIT=30u
.end
