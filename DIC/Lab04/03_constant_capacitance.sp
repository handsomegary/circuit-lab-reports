DIC Lab 4: constant-capacitance approximation
* MODEL_SETUP_REQUIRED
* Mean junction capacitances are measured from the companion AC experiment.
* AD/AS/PD/PS are zero in the fixed-C branches; explicit caps avoid double counting.
.option post=2 nomod runlvl=6 measdgt=10 numdgt=10 ingold=2
.temp 27
.param VS=1
VDD vdd 0 1
VIN in 0 PULSE(0 1 2n 100p 100p 8n 20n)
VB b 0 1
VC c 0 1
.subckt UNSHARED a b c y vp vn
MPa y a vp vp pmos W=1.8u L=0.25u AD=0.972p AS=0.972p PD=4.68u PS=4.68u NRD=0.15 NRS=0.15
MPb y b vp vp pmos W=1.8u L=0.25u AD=0.972p AS=0.972p PD=4.68u PS=4.68u NRD=0.15 NRS=0.15
MPc y c vp vp pmos W=1.8u L=0.25u AD=0.972p AS=0.972p PD=4.68u PS=4.68u NRD=0.15 NRS=0.15
MNa y a n1 vn nmos W=1.8u L=0.25u AD=0.972p AS=0.972p PD=4.68u PS=4.68u NRD=0.15 NRS=0.15
MNb n1 b n2 vn nmos W=1.8u L=0.25u AD=0.972p AS=0.972p PD=4.68u PS=4.68u NRD=0.15 NRS=0.15
MNc n2 c vn vn nmos W=1.8u L=0.25u AD=0.972p AS=0.972p PD=4.68u PS=4.68u NRD=0.15 NRS=0.15
.ends UNSHARED
.subckt SHARED a b c y vp vn
MPa y a vp vp pmos W=1.8u L=0.25u AD=0.972p AS=0.486p PD=2.88u PS=0.54u NRD=0.15 NRS=0.15
MPb y b vp vp pmos W=1.8u L=0.25u AD=0.486p AS=0.486p PD=0.54u PS=0.54u NRD=0.15 NRS=0.15
MPc y c vp vp pmos W=1.8u L=0.25u AD=0.486p AS=0.972p PD=0.54u PS=2.88u NRD=0.15 NRS=0.15
MNa y a n1 vn nmos W=1.8u L=0.25u AD=0.972p AS=0.486p PD=2.88u PS=0.54u NRD=0.15 NRS=0.15
MNb n1 b n2 vn nmos W=1.8u L=0.25u AD=0.486p AS=0.486p PD=0.54u PS=0.54u NRD=0.15 NRS=0.15
MNc n2 c vn vn nmos W=1.8u L=0.25u AD=0.486p AS=0.972p PD=0.54u PS=2.88u NRD=0.15 NRS=0.15
.ends SHARED
.subckt FIXED2 a b c y vp vn
MPa y a vp vp pmos W=1.8u L=0.25u AD=0 AS=0 PD=0 PS=0 NRD=.15 NRS=.15
MPb y b vp vp pmos W=1.8u L=0.25u AD=0 AS=0 PD=0 PS=0 NRD=.15 NRS=.15
MPc y c vp vp pmos W=1.8u L=0.25u AD=0 AS=0 PD=0 PS=0 NRD=.15 NRS=.15
MNa y a n1 vn nmos W=1.8u L=0.25u AD=0 AS=0 PD=0 PS=0 NRD=.15 NRS=.15
MNb n1 b n2 vn nmos W=1.8u L=0.25u AD=0 AS=0 PD=0 PS=0 NRD=.15 NRS=.15
MNc n2 c vn vn nmos W=1.8u L=0.25u AD=0 AS=0 PD=0 PS=0 NRD=.15 NRS=.15
CJy y vn 8.63045288e-15
CJn1 n1 vn 4.135226449e-15
CJn2 n2 vn 4.135226449e-15
.ends FIXED2
.subckt FIXED3 a b c y vp vn
MPa y a vp vp pmos W=1.8u L=0.25u AD=0 AS=0 PD=0 PS=0 NRD=.15 NRS=.15
MPb y b vp vp pmos W=1.8u L=0.25u AD=0 AS=0 PD=0 PS=0 NRD=.15 NRS=.15
MPc y c vp vp pmos W=1.8u L=0.25u AD=0 AS=0 PD=0 PS=0 NRD=.15 NRS=.15
MNa y a n1 vn nmos W=1.8u L=0.25u AD=0 AS=0 PD=0 PS=0 NRD=.15 NRS=.15
MNb n1 b n2 vn nmos W=1.8u L=0.25u AD=0 AS=0 PD=0 PS=0 NRD=.15 NRS=.15
MNc n2 c vn vn nmos W=1.8u L=0.25u AD=0 AS=0 PD=0 PS=0 NRD=.15 NRS=.15
CJy y vn 3.3840705509e-15
CJn1 n1 vn 5.275863797e-16
CJn2 n2 vn 5.275863797e-16
.ends FIXED3
Xd2 in b c d2 vdd 0 UNSHARED
CLd2 d2 0 10f
.measure tran d2_tphl TRIG V(in) VAL=.5 RISE=1 TARG V(d2) VAL=.5 FALL=1
.measure tran d2_tplh TRIG V(in) VAL=.5 FALL=1 TARG V(d2) VAL=.5 RISE=1
Xd3 in b c d3 vdd 0 SHARED
CLd3 d3 0 10f
.measure tran d3_tphl TRIG V(in) VAL=.5 RISE=1 TARG V(d3) VAL=.5 FALL=1
.measure tran d3_tplh TRIG V(in) VAL=.5 FALL=1 TARG V(d3) VAL=.5 RISE=1
Xf2 in b c f2 vdd 0 FIXED2
CLf2 f2 0 10f
.measure tran f2_tphl TRIG V(in) VAL=.5 RISE=1 TARG V(f2) VAL=.5 FALL=1
.measure tran f2_tplh TRIG V(in) VAL=.5 FALL=1 TARG V(f2) VAL=.5 RISE=1
Xf3 in b c f3 vdd 0 FIXED3
CLf3 f3 0 10f
.measure tran f3_tphl TRIG V(in) VAL=.5 RISE=1 TARG V(f3) VAL=.5 FALL=1
.measure tran f3_tplh TRIG V(in) VAL=.5 FALL=1 TARG V(f3) VAL=.5 RISE=1
.tran 2p 40n
.print tran V(in) V(d2) V(d3) V(f2) V(f3)
.end
