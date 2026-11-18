DIC Lab 12: 01_delay_elements
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
X1_1 in n1_1 vdd 0 INV wp=3.6u wn=1.2u ll=0.25u
X1_2 n1_1 n1_2 vdd 0 INV wp=3.6u wn=1.2u ll=0.25u
X1_3 n1_2 n1_3 vdd 0 INV wp=3.6u wn=1.2u ll=0.25u
X1_4 n1_3 n1_4 vdd 0 INV wp=3.6u wn=1.2u ll=0.25u
X1_5 n1_4 n1_5 vdd 0 INV wp=3.6u wn=1.2u ll=0.25u
.measure tran tr_case1 TRIG V(n1_5) VAL='0.1*VS' RISE=1 TARG V(n1_5) VAL='0.9*VS' RISE=1
.measure tran tf_case1 TRIG V(n1_5) VAL='0.9*VS' FALL=1 TARG V(n1_5) VAL='0.1*VS' FALL=1
.measure tran tphl_case1 TRIG V(in) VAL='0.5*VS' RISE=1 TARG V(n1_5) VAL='0.5*VS' FALL=1
.measure tran tplh_case1 TRIG V(in) VAL='0.5*VS' FALL=1 TARG V(n1_5) VAL='0.5*VS' RISE=1
X2_1 in n2_1 vdd 0 INV wp=1.2u wn=1.2u ll=0.25u
X2_2 n2_1 n2_2 vdd 0 INV wp=1.2u wn=1.2u ll=0.25u
X2_3 n2_2 n2_3 vdd 0 INV wp=1.2u wn=1.2u ll=0.25u
X2_4 n2_3 n2_4 vdd 0 INV wp=1.2u wn=1.2u ll=0.25u
X2_5 n2_4 n2_5 vdd 0 INV wp=1.2u wn=1.2u ll=0.25u
.measure tran tr_case2 TRIG V(n2_5) VAL='0.1*VS' RISE=1 TARG V(n2_5) VAL='0.9*VS' RISE=1
.measure tran tf_case2 TRIG V(n2_5) VAL='0.9*VS' FALL=1 TARG V(n2_5) VAL='0.1*VS' FALL=1
.measure tran tphl_case2 TRIG V(in) VAL='0.5*VS' RISE=1 TARG V(n2_5) VAL='0.5*VS' FALL=1
.measure tran tplh_case2 TRIG V(in) VAL='0.5*VS' FALL=1 TARG V(n2_5) VAL='0.5*VS' RISE=1
X3_1 in n3_1 vdd 0 INV wp=3.6u wn=1.2u ll=0.5u
X3_2 n3_1 n3_2 vdd 0 INV wp=3.6u wn=1.2u ll=0.5u
X3_3 n3_2 n3_3 vdd 0 INV wp=3.6u wn=1.2u ll=0.5u
X3_4 n3_3 n3_4 vdd 0 INV wp=3.6u wn=1.2u ll=0.5u
X3_5 n3_4 n3_5 vdd 0 INV wp=3.6u wn=1.2u ll=0.5u
.measure tran tr_case3 TRIG V(n3_5) VAL='0.1*VS' RISE=1 TARG V(n3_5) VAL='0.9*VS' RISE=1
.measure tran tf_case3 TRIG V(n3_5) VAL='0.9*VS' FALL=1 TARG V(n3_5) VAL='0.1*VS' FALL=1
.measure tran tphl_case3 TRIG V(in) VAL='0.5*VS' RISE=1 TARG V(n3_5) VAL='0.5*VS' FALL=1
.measure tran tplh_case3 TRIG V(in) VAL='0.5*VS' FALL=1 TARG V(n3_5) VAL='0.5*VS' RISE=1
X4_1 in n4_1 vdd 0 INV wp=1.8u wn=1.2u ll=0.5u
X4_2 n4_1 n4_2 vdd 0 INV wp=1.8u wn=1.2u ll=0.5u
X4_3 n4_2 n4_3 vdd 0 INV wp=1.8u wn=1.2u ll=0.5u
X4_4 n4_3 n4_4 vdd 0 INV wp=1.8u wn=1.2u ll=0.5u
X4_5 n4_4 n4_5 vdd 0 INV wp=1.8u wn=1.2u ll=0.5u
.measure tran tr_case4 TRIG V(n4_5) VAL='0.1*VS' RISE=1 TARG V(n4_5) VAL='0.9*VS' RISE=1
.measure tran tf_case4 TRIG V(n4_5) VAL='0.9*VS' FALL=1 TARG V(n4_5) VAL='0.1*VS' FALL=1
.measure tran tphl_case4 TRIG V(in) VAL='0.5*VS' RISE=1 TARG V(n4_5) VAL='0.5*VS' FALL=1
.measure tran tplh_case4 TRIG V(in) VAL='0.5*VS' FALL=1 TARG V(n4_5) VAL='0.5*VS' RISE=1
.tran 1p 15n
.print tran V(in) V(n1_5) V(n2_5) V(n3_5) V(n4_5)

.end
