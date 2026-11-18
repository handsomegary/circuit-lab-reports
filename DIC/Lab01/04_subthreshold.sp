DIC Lab 1 step 4: subthreshold transfer, both polarities
* Rewritten from DIC Lab.pdf, Lab 1; original files are references only.
* supplied-model teaching adaptation: 1.0 V operating range, not a model rating claim.
* HSPICE syntax; run this file directly in batch.
* MODEL_SETUP_REQUIRED
.option post=2 nomod measdgt=8 numdgt=8
.temp 25
* Export full 0..0.5 V magnitude; select weak-inversion interval from data.
* Do not assume that the full gate sweep lies below threshold.
.param DMAG=1.0
MN dn gn 0 0 nmos W=0.6u L=0.25u
MP dp gp 0 0 pmos W=1.8u L=0.25u
VG gn 0 0
EGP gp 0 gn 0 -1
VDN dn 0 'DMAG'
VDP dp 0 '-DMAG'
.dc VG 0 0.5 0.001
.print dc V(gn) I(VDN) I(VDP)
.probe dc V(gn) I(VDN) I(VDP)
.measure dc n_at_015 FIND I(VDN) AT=0.15
.measure dc n_at_025 FIND I(VDN) AT=0.25
.measure dc p_at_015 FIND I(VDP) AT=0.15
.measure dc p_at_025 FIND I(VDP) AT=0.25
.alter drain_060
.param DMAG=0.6
.alter drain_030
.param DMAG=0.3
.end
