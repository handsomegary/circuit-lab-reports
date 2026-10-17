DIC Lab 1 question 2: equal-geometry N/P comparison
* Rewritten from DIC Lab.pdf, Lab 1; original files are references only.
* supplied-model teaching adaptation: 1.0 V operating range, not a model rating claim.
* HSPICE syntax; run this file directly in batch.
.include '../../models/process.lib'
.option post=2 nomod measdgt=8 numdgt=8
.temp 25
* Identical W/L and matched absolute terminal voltages.
* Current ratio does not by itself identify a mobility ratio in a short-channel model.
MN dn gn 0 0 nmos W=0.6u L=0.25u
MP dp gp 0 0 pmos W=0.6u L=0.25u
VG gn 0 0
EGP gp 0 gn 0 -1
VDN dn 0 0.8
VDP dp 0 -0.8
.dc VG 0 1 0.001
.print dc V(gn) I(VDN) I(VDP)
.probe dc V(gn) I(VDN) I(VDP)
.measure dc n_at_08 FIND I(VDN) AT=0.8
.measure dc p_at_08 FIND I(VDP) AT=0.8
.measure dc magnitude_ratio PARAM='abs(p_at_08/n_at_08)'
.end
