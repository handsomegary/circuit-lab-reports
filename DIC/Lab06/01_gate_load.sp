DIC Lab 6: 01_gate_load
* Specification-based teaching adaptation; 1 V is a simulation condition, not a model rating.
* MODEL_SETUP_REQUIRED
.option post=2 nomod runlvl=6 measdgt=10 numdgt=10 ingold=2
.temp 25
.param VS=1
VDD vdd 0 'VS'
.subckt INV a y vp vn wn=0.6u wp=1.8u ll=0.25u
MN y a vn vn nmos W=wn L=ll
MP y a vp vp pmos W=wp L=ll
.ends INV
VIN in 0 PULSE(0 'VS' 1n 0.1n 0.1n 2n 5n)
* PDF pages 24-25: compare 1-4 doubled inverters against 8 fF per load.
* Multiplicity represents identical parallel loads, including their moving output.
.param NL=1
XDRV1 in ymos vdd 0 INV
XDRV2 in ycap vdd 0 INV
MNLOAD z ymos 0 0 nmos W=1.2u L=0.25u M=NL
MPLOAD z ymos vdd vdd pmos W=3.6u L=0.25u M=NL
CL ycap 0 'NL*8f'
.tran 1p 10n
.print tran V(in) V(ymos) V(ycap)
.measure tran tr_ymos TRIG V(ymos) VAL='0.1*VS' RISE=1 TARG V(ymos) VAL='0.9*VS' RISE=1
.measure tran tf_ymos TRIG V(ymos) VAL='0.9*VS' FALL=1 TARG V(ymos) VAL='0.1*VS' FALL=1
.measure tran tphl_ymos TRIG V(in) VAL='0.5*VS' RISE=1 TARG V(ymos) VAL='0.5*VS' FALL=1
.measure tran tplh_ymos TRIG V(in) VAL='0.5*VS' FALL=1 TARG V(ymos) VAL='0.5*VS' RISE=1
.measure tran tr_ycap TRIG V(ycap) VAL='0.1*VS' RISE=1 TARG V(ycap) VAL='0.9*VS' RISE=1
.measure tran tf_ycap TRIG V(ycap) VAL='0.9*VS' FALL=1 TARG V(ycap) VAL='0.1*VS' FALL=1
.measure tran tphl_ycap TRIG V(in) VAL='0.5*VS' RISE=1 TARG V(ycap) VAL='0.5*VS' FALL=1
.measure tran tplh_ycap TRIG V(in) VAL='0.5*VS' FALL=1 TARG V(ycap) VAL='0.5*VS' RISE=1
.alter two_loads
.param NL=2
.alter three_loads
.param NL=3
.alter four_loads
.param NL=4

.end
