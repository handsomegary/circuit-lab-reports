* AIC Lab 5: Two-stage gain, poles, unity crossing and phase margin
* Handout PDF pages 48-54.
* Supply: 1 V teaching adaptation; not a verified device rating.
* Model library is supplied separately by the user.
* MODEL_SETUP_REQUIRED
.option post=2 runlvl=5 accurate ingold=2 numdgt=8 measdgt=8
.temp 27
* The negligible 1e-21 F baseline approximates no compensation.
* 10 pF load is the lecture baseline; 1 pF is a separately labeled comparison.
* A small differential DC offset centers the open-loop output, calibrated by DC sweep.
* PM = 180 + unwrapped phase at the first descending unity-gain crossing.
* -3 dB means 1/sqrt(2) amplitude, correcting the handout half-amplitude statement.
.param ccomp=1e-21 rcomp=1m cload=10p vos=-9.12174979365e-08
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
.dc VD -.03 .03 .00001
.print dc v(out) v(stage1) v(tail) i(VDD)
.ac dec 80 1 10g
.print ac vdb(out) vp(out) vm(out)
.measure ac gain1 find vm(out) at=1
.measure ac gain_db find vdb(out) at=1

.alter miller_2p
.temp 27
.param ccomp=1e-21 rcomp=1m cload=10p vos=-9.12174979365e-08
.param ad=0 ag=0 acm=0 aid=1
.param ccomp=2p

.alter series_rc_2p
.temp 27
.param ccomp=1e-21 rcomp=1m cload=10p vos=-9.12174979365e-08
.param ad=0 ag=0 acm=0 aid=1
.param ccomp=2p rcomp=330

.alter adapted_rc_10p
.temp 27
.param ccomp=1e-21 rcomp=1m cload=10p vos=-9.12174979365e-08
.param ad=0 ag=0 acm=0 aid=1
.param ccomp=10p rcomp=330

.alter small_load_rc
.temp 27
.param ccomp=1e-21 rcomp=1m cload=10p vos=-9.12174979365e-08
.param ad=0 ag=0 acm=0 aid=1
.param ccomp=10p rcomp=330 cload=1p

.end
