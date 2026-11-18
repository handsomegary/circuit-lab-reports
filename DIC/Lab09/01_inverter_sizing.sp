DIC Lab 9: 01_inverter_sizing
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
.param WPREF=1.8u
XREF in y vdd 0 INV wp=WPREF
CL y 0 20f
.dc VIN 0 1 0.0005
.tran 1p 15n
.print dc V(in) V(y)
.print tran V(in) V(y)
.measure dc vth FIND V(in) WHEN V(y)=0.5 CROSS=1
.measure tran tr_y TRIG V(y) VAL='0.1*VS' RISE=1 TARG V(y) VAL='0.9*VS' RISE=1
.measure tran tf_y TRIG V(y) VAL='0.9*VS' FALL=1 TARG V(y) VAL='0.1*VS' FALL=1
.measure tran tphl_y TRIG V(in) VAL='0.5*VS' RISE=1 TARG V(y) VAL='0.5*VS' FALL=1
.measure tran tplh_y TRIG V(in) VAL='0.5*VS' FALL=1 TARG V(y) VAL='0.5*VS' RISE=1
.alter ratio_4
.param WPREF=2.4u
.alter ratio_5
.param WPREF=3u
.alter ratio_6
.param WPREF=3.6u
.alter ratio_7
.param WPREF=4.2u

.end
