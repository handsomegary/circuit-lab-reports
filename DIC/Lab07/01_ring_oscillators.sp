DIC Lab 7: 01_ring_oscillators
* MODEL_SETUP_REQUIRED
* Handout-based simulation at 1 V; this condition is not a model voltage rating.
.option post=2 nomod runlvl=6 measdgt=10 numdgt=10 ingold=2
.temp 27
.param VS=1
VDD vdd 0 'VS'
.subckt INV_BODY a y vp vn bp bn
MN y a vn bn nmos W=0.6u L=0.25u
MP y a vp bp pmos W=1.8u L=0.25u
.ends INV_BODY
.param PB=0 NB=0
VBP bp 0 'VS+PB'
VBN bn 0 '-NB'
Xr3_0 r3_2 r3_0 vdd 0 bp bn INV_BODY
Xr3_1 r3_0 r3_1 vdd 0 bp bn INV_BODY
Xr3_2 r3_1 r3_2 vdd 0 bp bn INV_BODY
.ic V(r3_0)=0.05
.measure tran period3 TRIG V(r3_0) VAL='VS/2' RISE=1 TD=10n TARG V(r3_0) VAL='VS/2' RISE=6 TD=10n
.measure tran freq3 PARAM='5/period3'
.measure tran min3 MIN V(r3_0) FROM=10n TO=20n
.measure tran max3 MAX V(r3_0) FROM=10n TO=20n
Xr5_0 r5_4 r5_0 vdd 0 bp bn INV_BODY
Xr5_1 r5_0 r5_1 vdd 0 bp bn INV_BODY
Xr5_2 r5_1 r5_2 vdd 0 bp bn INV_BODY
Xr5_3 r5_2 r5_3 vdd 0 bp bn INV_BODY
Xr5_4 r5_3 r5_4 vdd 0 bp bn INV_BODY
.ic V(r5_0)=0.05
.measure tran period5 TRIG V(r5_0) VAL='VS/2' RISE=1 TD=10n TARG V(r5_0) VAL='VS/2' RISE=6 TD=10n
.measure tran freq5 PARAM='5/period5'
.measure tran min5 MIN V(r5_0) FROM=10n TO=20n
.measure tran max5 MAX V(r5_0) FROM=10n TO=20n
Xr7_0 r7_6 r7_0 vdd 0 bp bn INV_BODY
Xr7_1 r7_0 r7_1 vdd 0 bp bn INV_BODY
Xr7_2 r7_1 r7_2 vdd 0 bp bn INV_BODY
Xr7_3 r7_2 r7_3 vdd 0 bp bn INV_BODY
Xr7_4 r7_3 r7_4 vdd 0 bp bn INV_BODY
Xr7_5 r7_4 r7_5 vdd 0 bp bn INV_BODY
Xr7_6 r7_5 r7_6 vdd 0 bp bn INV_BODY
.ic V(r7_0)=0.05
.measure tran period7 TRIG V(r7_0) VAL='VS/2' RISE=1 TD=10n TARG V(r7_0) VAL='VS/2' RISE=6 TD=10n
.measure tran freq7 PARAM='5/period7'
.measure tran min7 MIN V(r7_0) FROM=10n TO=20n
.measure tran max7 MAX V(r7_0) FROM=10n TO=20n
.tran 1p 20n UIC
.print tran V(r3_0) V(r5_0) V(r7_0)
.param PB=0 NB=0
.temp 27

.alter case_001
.param PB=0.2 NB=0
.temp 27

.alter case_002
.param PB=0 NB=0.2
.temp 27

.alter case_003
.param PB=0.2 NB=0.2
.temp 27

.end
