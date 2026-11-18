DIC Lab 9: 04_sizing_refinement
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
.param NP1=1.1 NP2=1.3 NK=2.2 PP=3.8 NA=2.7 NB=1.3
.subckt NANDM a b y vp vn
MPA y a vp vp pmos W='3.6u*NP1' L=0.25u
MPB y b vp vp pmos W='3.6u*NP2' L=0.25u
MNA y a n vn nmos W='0.6u*NK' L=0.25u
MNB n b vn vn nmos W='0.6u*NK' L=0.25u
.ends NANDM
.subckt NORM a b y vp vn
MPA p a vp vp pmos W='3.6u*PP' L=0.25u
MPB y b p vp pmos W='3.6u*PP' L=0.25u
MNA y a vn vn nmos W='0.6u*NA' L=0.25u
MNB y b vn vn nmos W='0.6u*NB' L=0.25u
.ends NORM
XREF in yr vdd 0 INV wp=3.6u
XNA in vdd yna vdd 0 NANDM
XNB vdd in ynb vdd 0 NANDM
XOA in 0 yoa vdd 0 NORM
XOB 0 in yob vdd 0 NORM
Cyr yr 0 20f
.measure tran tr_yr TRIG V(yr) VAL='0.1*VS' RISE=1 TARG V(yr) VAL='0.9*VS' RISE=1
.measure tran tf_yr TRIG V(yr) VAL='0.9*VS' FALL=1 TARG V(yr) VAL='0.1*VS' FALL=1
.measure tran tphl_yr TRIG V(in) VAL='0.5*VS' RISE=1 TARG V(yr) VAL='0.5*VS' FALL=1
.measure tran tplh_yr TRIG V(in) VAL='0.5*VS' FALL=1 TARG V(yr) VAL='0.5*VS' RISE=1
Cyna yna 0 20f
.measure tran tr_yna TRIG V(yna) VAL='0.1*VS' RISE=1 TARG V(yna) VAL='0.9*VS' RISE=1
.measure tran tf_yna TRIG V(yna) VAL='0.9*VS' FALL=1 TARG V(yna) VAL='0.1*VS' FALL=1
.measure tran tphl_yna TRIG V(in) VAL='0.5*VS' RISE=1 TARG V(yna) VAL='0.5*VS' FALL=1
.measure tran tplh_yna TRIG V(in) VAL='0.5*VS' FALL=1 TARG V(yna) VAL='0.5*VS' RISE=1
Cynb ynb 0 20f
.measure tran tr_ynb TRIG V(ynb) VAL='0.1*VS' RISE=1 TARG V(ynb) VAL='0.9*VS' RISE=1
.measure tran tf_ynb TRIG V(ynb) VAL='0.9*VS' FALL=1 TARG V(ynb) VAL='0.1*VS' FALL=1
.measure tran tphl_ynb TRIG V(in) VAL='0.5*VS' RISE=1 TARG V(ynb) VAL='0.5*VS' FALL=1
.measure tran tplh_ynb TRIG V(in) VAL='0.5*VS' FALL=1 TARG V(ynb) VAL='0.5*VS' RISE=1
Cyoa yoa 0 20f
.measure tran tr_yoa TRIG V(yoa) VAL='0.1*VS' RISE=1 TARG V(yoa) VAL='0.9*VS' RISE=1
.measure tran tf_yoa TRIG V(yoa) VAL='0.9*VS' FALL=1 TARG V(yoa) VAL='0.1*VS' FALL=1
.measure tran tphl_yoa TRIG V(in) VAL='0.5*VS' RISE=1 TARG V(yoa) VAL='0.5*VS' FALL=1
.measure tran tplh_yoa TRIG V(in) VAL='0.5*VS' FALL=1 TARG V(yoa) VAL='0.5*VS' RISE=1
Cyob yob 0 20f
.measure tran tr_yob TRIG V(yob) VAL='0.1*VS' RISE=1 TARG V(yob) VAL='0.9*VS' RISE=1
.measure tran tf_yob TRIG V(yob) VAL='0.9*VS' FALL=1 TARG V(yob) VAL='0.1*VS' FALL=1
.measure tran tphl_yob TRIG V(in) VAL='0.5*VS' RISE=1 TARG V(yob) VAL='0.5*VS' FALL=1
.measure tran tplh_yob TRIG V(in) VAL='0.5*VS' FALL=1 TARG V(yob) VAL='0.5*VS' RISE=1
.tran 1p 15n
.print tran V(in) V(yr) V(yna) V(ynb) V(yoa) V(yob)
.dc VIN 0 1 0.0005
.print dc V(in) V(yr) V(yna) V(ynb) V(yoa) V(yob)
.measure dc vm_yr FIND V(in) WHEN V(yr)=0.5 CROSS=1
.measure dc vm_yna FIND V(in) WHEN V(yna)=0.5 CROSS=1
.measure dc vm_ynb FIND V(in) WHEN V(ynb)=0.5 CROSS=1
.measure dc vm_yoa FIND V(in) WHEN V(yoa)=0.5 CROSS=1
.measure dc vm_yob FIND V(in) WHEN V(yob)=0.5 CROSS=1
.alter iteration_2
.param PP=5 NA=3.5 NB=1.5 NK=2.5 NP1=1.15 NP2=1.4
.alter iteration_3
.param PP=6 NA=4.5 NB=1.7 NK=2.5 NP1=1.15 NP2=1.4

.end
