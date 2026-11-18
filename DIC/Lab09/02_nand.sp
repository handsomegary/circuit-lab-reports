DIC Lab 9: 02_nand
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
.param WPREF=3.6u KSTACK=2
.subckt GATE a b y vp vn
MPA y a vp vp pmos W=WPREF L=0.25u
MPB y b vp vp pmos W=WPREF L=0.25u
MNA y a mid vn nmos W='0.6u*KSTACK' L=0.25u
MNB mid b vn vn nmos W='0.6u*KSTACK' L=0.25u
.ends GATE
Vboth vboth 0 1
Xboth in in yboth vboth 0 GATE
Cboth yboth 0 20f
.measure tran tr_both TRIG V(yboth) VAL='0.1*VS' RISE=1 TARG V(yboth) VAL='0.9*VS' RISE=1
.measure tran tf_both TRIG V(yboth) VAL='0.9*VS' FALL=1 TARG V(yboth) VAL='0.1*VS' FALL=1
.measure tran tphl_both TRIG V(in) VAL='0.5*VS' RISE=1 TARG V(yboth) VAL='0.5*VS' FALL=1
.measure tran tplh_both TRIG V(in) VAL='0.5*VS' FALL=1 TARG V(yboth) VAL='0.5*VS' RISE=1
.measure tran p_both AVG PAR('-V(vboth)*I(Vboth)') FROM=5n TO=15n
.measure dc vth_both FIND V(in) WHEN V(yboth)=0.5 CROSS=1
Va va 0 1
Xa in vdd ya va 0 GATE
Ca ya 0 20f
.measure tran tr_a TRIG V(ya) VAL='0.1*VS' RISE=1 TARG V(ya) VAL='0.9*VS' RISE=1
.measure tran tf_a TRIG V(ya) VAL='0.9*VS' FALL=1 TARG V(ya) VAL='0.1*VS' FALL=1
.measure tran tphl_a TRIG V(in) VAL='0.5*VS' RISE=1 TARG V(ya) VAL='0.5*VS' FALL=1
.measure tran tplh_a TRIG V(in) VAL='0.5*VS' FALL=1 TARG V(ya) VAL='0.5*VS' RISE=1
.measure tran p_a AVG PAR('-V(va)*I(Va)') FROM=5n TO=15n
.measure dc vth_a FIND V(in) WHEN V(ya)=0.5 CROSS=1
Vb vb 0 1
Xb vdd in yb vb 0 GATE
Cb yb 0 20f
.measure tran tr_b TRIG V(yb) VAL='0.1*VS' RISE=1 TARG V(yb) VAL='0.9*VS' RISE=1
.measure tran tf_b TRIG V(yb) VAL='0.9*VS' FALL=1 TARG V(yb) VAL='0.1*VS' FALL=1
.measure tran tphl_b TRIG V(in) VAL='0.5*VS' RISE=1 TARG V(yb) VAL='0.5*VS' FALL=1
.measure tran tplh_b TRIG V(in) VAL='0.5*VS' FALL=1 TARG V(yb) VAL='0.5*VS' RISE=1
.measure tran p_b AVG PAR('-V(vb)*I(Vb)') FROM=5n TO=15n
.measure dc vth_b FIND V(in) WHEN V(yb)=0.5 CROSS=1
XREF in yref vdd 0 INV wp=WPREF
CREF yref 0 20f
.measure tran tr_ref TRIG V(yref) VAL='0.1*VS' RISE=1 TARG V(yref) VAL='0.9*VS' RISE=1
.measure tran tf_ref TRIG V(yref) VAL='0.9*VS' FALL=1 TARG V(yref) VAL='0.1*VS' FALL=1
.measure tran tphl_ref TRIG V(in) VAL='0.5*VS' RISE=1 TARG V(yref) VAL='0.5*VS' FALL=1
.measure tran tplh_ref TRIG V(in) VAL='0.5*VS' FALL=1 TARG V(yref) VAL='0.5*VS' RISE=1
.dc VIN 0 1 0.0005
.tran 1p 15n
.print dc V(in) V(yboth) V(ya) V(yb)
.print tran V(in) V(yboth) V(ya) V(yb)
.alter stack_1p5
.param KSTACK=1.5
.alter stack_2p5
.param KSTACK=2.5
.alter stack_3
.param KSTACK=3

.end
