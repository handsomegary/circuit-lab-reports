DIC Lab 12: 02_taper_buffer
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
VIN in 0 PULSE(0 1 2n 0.1n 0.1n 20n 45n)
.param F=2
X1 in n1 vdd 0 INV wn='0.6u*F**0' wp='1.8u*F**0'
X2 n1 n2 vdd 0 INV wn='0.6u*F**1' wp='1.8u*F**1'
X3 n2 n3 vdd 0 INV wn='0.6u*F**2' wp='1.8u*F**2'
X4 n3 n4 vdd 0 INV wn='0.6u*F**3' wp='1.8u*F**3'
X5 n4 n5 vdd 0 INV wn='0.6u*F**4' wp='1.8u*F**4'
CL n5 0 2p
.tran 2p 90n
.print tran V(in) V(n5)
.measure tran tr_n5 TRIG V(n5) VAL='0.1*VS' RISE=1 TARG V(n5) VAL='0.9*VS' RISE=1
.measure tran tf_n5 TRIG V(n5) VAL='0.9*VS' FALL=1 TARG V(n5) VAL='0.1*VS' FALL=1
.measure tran tphl_n5 TRIG V(in) VAL='0.5*VS' RISE=1 TARG V(n5) VAL='0.5*VS' FALL=1
.measure tran tplh_n5 TRIG V(in) VAL='0.5*VS' FALL=1 TARG V(n5) VAL='0.5*VS' RISE=1
.alter taper_3
.param F=3
.alter taper_4
.param F=4
.alter taper_5
.param F=5

.end
