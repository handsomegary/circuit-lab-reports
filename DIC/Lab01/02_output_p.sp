DIC Lab 1 step 2: PMOS output characteristics
* Rewritten from DIC Lab.pdf, Lab 1; original files are references only.
* supplied-model teaching adaptation: 1.0 V operating range, not a model rating claim.
* HSPICE syntax; run this file directly in batch.
* MODEL_SETUP_REQUIRED
.option post=2 nomod measdgt=8 numdgt=8
.temp 25
.param WCH=1.8u LCH=0.25u
M1 d g 0 0 pmos W='WCH' L='LCH'
VDS d 0 0
VGS g 0 0
.dc VDS 0 -1.0 -0.001 VGS 0 -1.0 -0.2
.print dc V(d) V(g) I(VDS)
.probe dc V(d) V(g) I(VDS)
.measure dc source_current_at_limit FIND I(VDS) AT=-1.0
.end
