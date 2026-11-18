DIC Lab 13: 03_dc_power
* MODEL_SETUP_REQUIRED
* Handout-based simulation at 1 V; this condition is not a model voltage rating.
.option post=2 nomod runlvl=6 measdgt=10 numdgt=10 ingold=2
.temp 27
.param VS=1
VDD vdd 0 'VS'
VIN in 0 0
VC cdd 0 1
VP pdd 0 1
MNC yc in 0 0 nmos W=.6u L=.25u
MPC yc in cdd cdd pmos W=.9u L=.25u
MNP yp in 0 0 nmos W=.6u L=.25u
MPP yp 0 pdd pdd pmos W=.9u L=.25u
.dc VIN 0 1 .002
.print dc V(in) V(yc) V(yp) I(VC) I(VP)
.measure dc c_vol FIND V(yc) AT=1
.measure dc p_vol FIND V(yp) AT=1
.measure dc p_istatic FIND I(VP) AT=1
.measure dc c_istatic FIND I(VC) AT=1

.end
