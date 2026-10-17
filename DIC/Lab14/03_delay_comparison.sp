DIC Lab 14: 03_delay_comparison
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
.subckt SCH a y vp vn f=1
MP1 p a vp vp pmos W=3.6u L=0.25u
MP2 y a p vp pmos W=3.6u L=0.25u
MN1 n a vn vn nmos W=1.2u L=0.25u
MN2 y a n vn nmos W=1.2u L=0.25u
MP3 vn y p vp pmos W='1.8u*f' L=0.25u
MN3 vp y n vn nmos W='0.6u*f' L=0.25u
.ends SCH
* Alternative: a strong input inverter drives a weak cross-coupled inverter pair.
.subckt ALT a y vp vn
XIN a y vp vn INV wn=1.2u wp=3.6u
XFB q y vp vn INV wn=0.6u wp=1.8u
XSENSE y q vp vn INV wn=0.6u wp=1.8u
.ends ALT
XINV in yi vdd 0 INV
XS1 in ys1 vdd 0 SCH f=1
XS2 in ys2 vdd 0 SCH f=2
XS3 in ys3 vdd 0 SCH f=3
XALT in ya vdd 0 ALT
VIN in 0 PULSE(0 'VS' 1n 0.1n 0.1n 2n 5n)
Cyi yi 0 8f
.measure tran tr_yi TRIG V(yi) VAL='0.1*VS' RISE=1 TARG V(yi) VAL='0.9*VS' RISE=1
.measure tran tf_yi TRIG V(yi) VAL='0.9*VS' FALL=1 TARG V(yi) VAL='0.1*VS' FALL=1
.measure tran tphl_yi TRIG V(in) VAL='0.5*VS' RISE=1 TARG V(yi) VAL='0.5*VS' FALL=1
.measure tran tplh_yi TRIG V(in) VAL='0.5*VS' FALL=1 TARG V(yi) VAL='0.5*VS' RISE=1
Cys1 ys1 0 8f
.measure tran tr_ys1 TRIG V(ys1) VAL='0.1*VS' RISE=1 TARG V(ys1) VAL='0.9*VS' RISE=1
.measure tran tf_ys1 TRIG V(ys1) VAL='0.9*VS' FALL=1 TARG V(ys1) VAL='0.1*VS' FALL=1
.measure tran tphl_ys1 TRIG V(in) VAL='0.5*VS' RISE=1 TARG V(ys1) VAL='0.5*VS' FALL=1
.measure tran tplh_ys1 TRIG V(in) VAL='0.5*VS' FALL=1 TARG V(ys1) VAL='0.5*VS' RISE=1
Cys2 ys2 0 8f
.measure tran tr_ys2 TRIG V(ys2) VAL='0.1*VS' RISE=1 TARG V(ys2) VAL='0.9*VS' RISE=1
.measure tran tf_ys2 TRIG V(ys2) VAL='0.9*VS' FALL=1 TARG V(ys2) VAL='0.1*VS' FALL=1
.measure tran tphl_ys2 TRIG V(in) VAL='0.5*VS' RISE=1 TARG V(ys2) VAL='0.5*VS' FALL=1
.measure tran tplh_ys2 TRIG V(in) VAL='0.5*VS' FALL=1 TARG V(ys2) VAL='0.5*VS' RISE=1
Cys3 ys3 0 8f
.measure tran tr_ys3 TRIG V(ys3) VAL='0.1*VS' RISE=1 TARG V(ys3) VAL='0.9*VS' RISE=1
.measure tran tf_ys3 TRIG V(ys3) VAL='0.9*VS' FALL=1 TARG V(ys3) VAL='0.1*VS' FALL=1
.measure tran tphl_ys3 TRIG V(in) VAL='0.5*VS' RISE=1 TARG V(ys3) VAL='0.5*VS' FALL=1
.measure tran tplh_ys3 TRIG V(in) VAL='0.5*VS' FALL=1 TARG V(ys3) VAL='0.5*VS' RISE=1
Cya ya 0 8f
.measure tran tr_ya TRIG V(ya) VAL='0.1*VS' RISE=1 TARG V(ya) VAL='0.9*VS' RISE=1
.measure tran tf_ya TRIG V(ya) VAL='0.9*VS' FALL=1 TARG V(ya) VAL='0.1*VS' FALL=1
.measure tran tphl_ya TRIG V(in) VAL='0.5*VS' RISE=1 TARG V(ya) VAL='0.5*VS' FALL=1
.measure tran tplh_ya TRIG V(in) VAL='0.5*VS' FALL=1 TARG V(ya) VAL='0.5*VS' RISE=1
.tran 1p 15n
.print tran V(in) V(yi) V(ys1) V(ys2) V(ys3) V(ya)

.end
