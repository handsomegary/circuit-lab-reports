* AIC Lab 5: Common-mode and positive/negative supply rejection
* Handout PDF pages 56-57.
* Supply: 1 V teaching adaptation; not a verified device rating.
* Model library is supplied separately by the user.
* MODEL_SETUP_REQUIRED
.option post=2 runlvl=5 accurate ingold=2 numdgt=8 measdgt=8
.temp 27
* Inputs stay referenced to global ground for supply injection.
* CMRR/PSRR are differential dB gain minus the corresponding disturbance dB gain.
* Ideal nominal matching is not measured silicon rejection or a mismatch analysis.
.param ccomp=10p rcomp=330 cload=10p vos=-9.12174979365e-08
.param ad=0 ag=0 acm=0 aid=1
VDD vdd 0 1 ac 'ad'
VSS vss 0 0 ac 'ag'
VCM cm 0 .6 ac 'acm'
VD diff 0 'vos' ac 'aid'
EP ip cm diff 0 .5
EM im cm diff 0 -.5
IREF vdd bn 10u
M5 bn bn vss vss nmos w=2.2u l=.3u
M6 tail bn vss vss nmos w=30u l=.3u
M1 left im tail vss nmos w=35u l=.3u
M2 stage1 ip tail vss nmos w=35u l=.3u
M3 left left vdd vdd pmos w=54u l=.3u
M4 stage1 left vdd vdd pmos w=54u l=.3u
M8 out bn vss vss nmos w=73u l=.3u
M7 out stage1 vdd vdd pmos w=269u l=.3u
RC stage1 cn 'rcomp'
CC cn out 'ccomp'
CL out 0 'cload'

.op
.ac dec 80 1 10g
.print ac vdb(out) vp(out) vm(out)
.measure ac gain1 find vm(out) at=1
.measure ac gain_db find vdb(out) at=1

.alter common_mode
.temp 27
.param ccomp=10p rcomp=330 cload=10p vos=-9.12174979365e-08
.param ad=0 ag=0 acm=0 aid=1
.param aid=0 acm=1

.alter positive_supply
.temp 27
.param ccomp=10p rcomp=330 cload=10p vos=-9.12174979365e-08
.param ad=0 ag=0 acm=0 aid=1
.param aid=0 ad=1

.alter negative_supply
.temp 27
.param ccomp=10p rcomp=330 cload=10p vos=-9.12174979365e-08
.param ad=0 ag=0 acm=0 aid=1
.param aid=0 ag=1

.end
