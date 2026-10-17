DIC Lab 1 step 3: channel-length dependence, both polarities
* Rewritten from DIC Lab.pdf, Lab 1; original files are references only.
* supplied-model teaching adaptation: 1.0 V operating range, not a model rating claim.
* HSPICE syntax; run this file directly in batch.
.include '../../models/process.lib'
.option post=2 nomod measdgt=8 numdgt=8
.temp 25
* Retain handout lengths 0.25, 0.5, 0.75, 1.0 um and widths 0.6/1.8 um.
* Gate magnitude is 0.6 V; drain magnitude is 0..1 V.
.param LCH=0.25u
MN dn gn 0 0 nmos W=0.6u L='LCH'
MP dp gp 0 0 pmos W=1.8u L='LCH'
VDN dn 0 0
VG gn 0 0.6
EDP dp 0 dn 0 -1
EGP gp 0 gn 0 -1
.dc VDN 0 1 0.001 LCH 0.25u 1.0u 0.25u
.print dc V(dn) I(VDN) I(EDP)
.probe dc V(dn) V(dp) I(VDN) I(EDP)
.measure dc in_08 FIND I(VDN) AT=0.8
.measure dc in_10 FIND I(VDN) AT=1.0
.measure dc ip_08 FIND I(EDP) AT=0.8
.measure dc ip_10 FIND I(EDP) AT=1.0
.measure dc gds_n_secant PARAM='-(in_10-in_08)/0.2'
.measure dc gds_p_secant PARAM='(ip_10-ip_08)/0.2'
.end
