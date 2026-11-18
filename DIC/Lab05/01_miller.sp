DIC Lab 5: 01_miller
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
* PDF pages 21-23: three inverters; explicit coupling spans stage 2 input/output.
.param CCVAL=0 CLVAL=0
X1 in a vdd 0 INV
X2 a y vdd 0 INV
X3 y z vdd 0 INV
CC a y 'CCVAL'
CL y 0 'CLVAL'
.tran 1p 10n
.print tran V(in) V(a) V(y)
.measure tran ymax MAX V(y) FROM=0.8n TO=5n
.measure tran ymin MIN V(y) FROM=0.8n TO=5n
.measure tran overshoot PARAM='ymax-VS'
.measure tran undershoot PARAM='-ymin'
.measure tran tr_y TRIG V(y) VAL='0.1*VS' RISE=1 TARG V(y) VAL='0.9*VS' RISE=1
.measure tran tf_y TRIG V(y) VAL='0.9*VS' FALL=1 TARG V(y) VAL='0.1*VS' FALL=1
.alter coupling_2f
.param CCVAL=2f
.alter coupling_5f
.param CCVAL=5f
.alter coupling_10f
.param CCVAL=10f
.alter coupling_5f_load_10f
.param CCVAL=5f CLVAL=10f
.alter coupling_5f_load_40f
.param CCVAL=5f CLVAL=40f

.end
