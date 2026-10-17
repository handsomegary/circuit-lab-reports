DIC Lab 1 step 1: diode-connected PMOS
* Rewritten from DIC Lab.pdf, Lab 1; original files are references only.
* supplied-model teaching adaptation: 1.0 V operating range, not a model rating claim.
* HSPICE syntax; run this file directly in batch.
.include '../../models/process.lib'
.option post=2 nomod measdgt=8 numdgt=8
.temp 25
.param WCH=1.8u LCH=0.25u
M1 d d 0 0 pmos W='WCH' L='LCH'
VSW d 0 0
.dc VSW 0 -1.0 -0.001
.print dc V(d) I(VSW)
.probe dc V(d) I(VSW)
.measure dc source_current_at_limit FIND I(VSW) AT=-1.0
* Drain current is -I(VSW), also for PMOS. Plot abs(I(VSW)) for magnitude.
.alter width_times_2
.param WCH=3.6u
.alter width_times_4
.param WCH=7.2u
.end
