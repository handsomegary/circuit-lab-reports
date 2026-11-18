DIC Lab 4: 01_geometry
* MODEL_SETUP_REQUIRED
* Handout-based simulation at 1 V; this condition is not a model voltage rating.
.option post=2 nomod runlvl=6 measdgt=10 numdgt=10 ingold=2
.temp 27
.param VS=1
VDD vdd 0 'VS'
* PDF 17-20. HDIF=0.27 um is a teaching geometry, not a foundry design rule.
* Explicit AD/AS/PD/PS realize the handout equations without editing encrypted models.
VIN in 0 PULSE(0 1 2n 100p 100p 8n 20n)
VB b 0 1
VC c 0 1
.subckt DEFAULT a b c y vp vn
MPa y a vp vp pmos W=1.8u L=0.25u
MPb y b vp vp pmos W=1.8u L=0.25u
MPc y c vp vp pmos W=1.8u L=0.25u
MNa y a n1 vn nmos W=1.8u L=0.25u
MNb n1 b n2 vn nmos W=1.8u L=0.25u
MNc n2 c vn vn nmos W=1.8u L=0.25u
.ends DEFAULT
XDEFAULT in b c y0 vdd 0 DEFAULT
CL0 y0 0 10f
.measure tran g0_tphl TRIG V(in) VAL='VS/2' RISE=1 TARG V(y0) VAL='VS/2' FALL=1
.measure tran g0_tplh TRIG V(in) VAL='VS/2' FALL=1 TARG V(y0) VAL='VS/2' RISE=1
.measure tran g0_tr TRIG V(y0) VAL='VS*0.1' RISE=1 TARG V(y0) VAL='VS*0.9' RISE=1
.measure tran g0_tf TRIG V(y0) VAL='VS*0.9' FALL=1 TARG V(y0) VAL='VS*0.1' FALL=1
.subckt UNSHARED a b c y vp vn
MPa y a vp vp pmos W=1.8u L=0.25u AD=0.972p AS=0.972p PD=4.68u PS=4.68u NRD=0.15 NRS=0.15
MPb y b vp vp pmos W=1.8u L=0.25u AD=0.972p AS=0.972p PD=4.68u PS=4.68u NRD=0.15 NRS=0.15
MPc y c vp vp pmos W=1.8u L=0.25u AD=0.972p AS=0.972p PD=4.68u PS=4.68u NRD=0.15 NRS=0.15
MNa y a n1 vn nmos W=1.8u L=0.25u AD=0.972p AS=0.972p PD=4.68u PS=4.68u NRD=0.15 NRS=0.15
MNb n1 b n2 vn nmos W=1.8u L=0.25u AD=0.972p AS=0.972p PD=4.68u PS=4.68u NRD=0.15 NRS=0.15
MNc n2 c vn vn nmos W=1.8u L=0.25u AD=0.972p AS=0.972p PD=4.68u PS=4.68u NRD=0.15 NRS=0.15
.ends UNSHARED
XUNSHARED in b c y2 vdd 0 UNSHARED
CL2 y2 0 10f
.measure tran g2_tphl TRIG V(in) VAL='VS/2' RISE=1 TARG V(y2) VAL='VS/2' FALL=1
.measure tran g2_tplh TRIG V(in) VAL='VS/2' FALL=1 TARG V(y2) VAL='VS/2' RISE=1
.measure tran g2_tr TRIG V(y2) VAL='VS*0.1' RISE=1 TARG V(y2) VAL='VS*0.9' RISE=1
.measure tran g2_tf TRIG V(y2) VAL='VS*0.9' FALL=1 TARG V(y2) VAL='VS*0.1' FALL=1
.subckt SHARED a b c y vp vn
MPa y a vp vp pmos W=1.8u L=0.25u AD=0.972p AS=0.486p PD=2.88u PS=0.54u NRD=0.15 NRS=0.15
MPb y b vp vp pmos W=1.8u L=0.25u AD=0.486p AS=0.486p PD=0.54u PS=0.54u NRD=0.15 NRS=0.15
MPc y c vp vp pmos W=1.8u L=0.25u AD=0.486p AS=0.972p PD=0.54u PS=2.88u NRD=0.15 NRS=0.15
MNa y a n1 vn nmos W=1.8u L=0.25u AD=0.972p AS=0.486p PD=2.88u PS=0.54u NRD=0.15 NRS=0.15
MNb n1 b n2 vn nmos W=1.8u L=0.25u AD=0.486p AS=0.486p PD=0.54u PS=0.54u NRD=0.15 NRS=0.15
MNc n2 c vn vn nmos W=1.8u L=0.25u AD=0.486p AS=0.972p PD=0.54u PS=2.88u NRD=0.15 NRS=0.15
.ends SHARED
XSHARED in b c y3 vdd 0 SHARED
CL3 y3 0 10f
.measure tran g3_tphl TRIG V(in) VAL='VS/2' RISE=1 TARG V(y3) VAL='VS/2' FALL=1
.measure tran g3_tplh TRIG V(in) VAL='VS/2' FALL=1 TARG V(y3) VAL='VS/2' RISE=1
.measure tran g3_tr TRIG V(y3) VAL='VS*0.1' RISE=1 TARG V(y3) VAL='VS*0.9' RISE=1
.measure tran g3_tf TRIG V(y3) VAL='VS*0.9' FALL=1 TARG V(y3) VAL='VS*0.1' FALL=1
.tran 2p 40n
.print tran V(in) V(y0) V(y2) V(y3)

.end
