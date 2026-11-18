DIC Lab 7: 02_body_threshold
* MODEL_SETUP_REQUIRED
* Handout-based simulation at 1 V; this condition is not a model voltage rating.
.option post=2 nomod runlvl=6 measdgt=10 numdgt=10 ingold=2
.temp 27
.param VS=1
VDD vdd 0 'VS'
VSRC sx 0 0
MN vdd vdd sx 0 nmos W=0.6u L=0.25u
EPN sp 0 VOL='VS-V(sx)'
MP 0 0 sp vdd pmos W=1.8u L=0.25u
.dc VSRC 0 1 0.01
.print dc V(sx) VTH(MN) VTH(MP)
.measure dc vtn0 FIND VTH(MN) AT=0
.measure dc vtn1 FIND VTH(MN) AT=1
.measure dc vtp0 FIND VTH(MP) AT=0
.measure dc vtp1 FIND VTH(MP) AT=1

.end
