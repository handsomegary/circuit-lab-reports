DIC Lab 10: 01_size_load
* MODEL_SETUP_REQUIRED
* Handout-based simulation at 1 V; this condition is not a model voltage rating.
.option post=2 nomod runlvl=6 measdgt=10 numdgt=10 ingold=2
.temp 27
.param VS=1
VDD vdd 0 'VS'
.subckt INV a y vp vn wn=0.6u wp=1.8u ll=0.25u
MN y a vn vn nmos W=wn L=ll
MP y a vp vp pmos W=wp L=ll
.ends INV
VIN in 0 PULSE(0 1 2n 'SLEW' 'SLEW' 10n 25n)
X1 in out vdd 0 INV wn='0.6u*SIZE' wp='1.8u*SIZE'
CL out 0 'max(LOAD,1e-21)'
.tran 5p 50n
.print tran V(in) V(out)
.measure tran tphl TRIG V(in) VAL='VS/2' RISE=1 TARG V(out) VAL='VS/2' FALL=1
.measure tran tplh TRIG V(in) VAL='VS/2' FALL=1 TARG V(out) VAL='VS/2' RISE=1
.measure tran tr TRIG V(out) VAL='VS*0.1' RISE=1 TARG V(out) VAL='VS*0.9' RISE=1
.measure tran tf TRIG V(out) VAL='VS*0.9' FALL=1 TARG V(out) VAL='VS*0.1' FALL=1
.param SIZE=1 LOAD=0p SLEW=0.2n
.temp 27

.alter case_001
.param SIZE=1 LOAD=0.1p SLEW=0.2n
.temp 27

.alter case_002
.param SIZE=1 LOAD=0.2p SLEW=0.2n
.temp 27

.alter case_003
.param SIZE=1 LOAD=0.3p SLEW=0.2n
.temp 27

.alter case_004
.param SIZE=2 LOAD=0p SLEW=0.2n
.temp 27

.alter case_005
.param SIZE=2 LOAD=0.1p SLEW=0.2n
.temp 27

.alter case_006
.param SIZE=2 LOAD=0.2p SLEW=0.2n
.temp 27

.alter case_007
.param SIZE=2 LOAD=0.3p SLEW=0.2n
.temp 27

.alter case_008
.param SIZE=3 LOAD=0p SLEW=0.2n
.temp 27

.alter case_009
.param SIZE=3 LOAD=0.1p SLEW=0.2n
.temp 27

.alter case_010
.param SIZE=3 LOAD=0.2p SLEW=0.2n
.temp 27

.alter case_011
.param SIZE=3 LOAD=0.3p SLEW=0.2n
.temp 27

.alter case_012
.param SIZE=4 LOAD=0p SLEW=0.2n
.temp 27

.alter case_013
.param SIZE=4 LOAD=0.1p SLEW=0.2n
.temp 27

.alter case_014
.param SIZE=4 LOAD=0.2p SLEW=0.2n
.temp 27

.alter case_015
.param SIZE=4 LOAD=0.3p SLEW=0.2n
.temp 27

.end
