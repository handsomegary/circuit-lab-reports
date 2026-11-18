* AIC Lab 01 - Finite-bandwidth feedback boost, conceptual experiment
* Handout: AIC Lab.pdf, PDF pages 21 (one-based physical pages).
* supplied-model adaptation: 1 V is a teaching assumption, NOT a verified model rating.
* The original 0.35 um / 3.3 V numerical results are NOT supplied-model specifications.
* Device geometry is not blindly scaled to 90 nm.
* Nominal reference is 50 uA; separate 10 uA and 1 uA alters show headroom.
* Ideal current sources do NOT enforce supply compliance. Check every bias node.
* MODEL_SETUP_REQUIRED
.option post=2 runlvl=5 accurate measdgt=8 numdgt=8 ingold=2
.temp 27
.param VDDVAL=1.0 IREFVAL=50u WUNIT=3u LUNIT=1.4u
* p21 Q2 prints gm^3/gd^5, whose units are ohm^2, not ohm.
* Therefore this deck tests dimensionally valid Rout ~ A*gm*ro^2 instead.
* Ideal gain block is a test fixture, NOT a completed transistor amplifier.
* A=1,10,100 are dimensionless. Pole1MHz exposes the gain/bandwidth tradeoff.
.param ALOOP=1 FP=1meg VSET=0.15 VG0=0.65
VDD vdd 0 'VDDVAL'
IREF vdd ref 'IREFVAL'
M0 ref ref 0 0 nmos w='WUNIT' l='LUNIT'
M1 mid ref 0 0 nmos w='WUNIT' l='LUNIT' m=2
M3 drain gate mid 0 nmos w='WUNIT' l='LUNIT' m=2
ECONT ctrl 0 vol='VG0+ALOOP*(VSET-v(mid))'
RPOLE ctrl gate 1k
CPOLE gate 0 '1/(6.283185307179586*FP*1k)'
VTEST out 0 dc 0.8 ac 1 pulse(0.6 0.8 2u 10n 10n 5u 10u)
VS out drain 0
.op
.dc VTEST 0 'VDDVAL' 0.001
.ac dec 50 1 100meg
.tran 5n 12u
.print dc v(out) i(VS) v(ref) v(mid) v(gate)
.print ac im(VS) ip(VS) vm(gate)
.print tran v(out) i(VS) v(mid) v(gate)
.measure dc iout find i(VS) at=0.8
.measure dc vgate find v(gate) at=0.8
.measure dc vmid find v(mid) at=0.8
.measure ac gout find im(VS) at=1
.measure ac rout param='1/gout'

.measure ac phase_vs find ip(VS) at=1
.alter gain10
.param ALOOP=10
.alter gain100
.param ALOOP=100
.end
