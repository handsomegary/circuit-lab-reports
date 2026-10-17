* AIC Lab 5: Closed-loop common-mode range and loading
* Handout PDF pages 54-55.
* Supply: 1 V teaching adaptation; not a verified device rating.
* Model library is supplied separately by the user.
* MODEL_SETUP_REQUIRED
.option post=2 runlvl=5 accurate ingold=2 numdgt=8 measdgt=8
.temp 27
* The tracking window uses an explicit 10 mV error criterion.
* A closed-loop tracking window combines input common-mode and output-swing limits.
.param ccomp=10p rcomp=330 cload=10p rload=1e12
VDD vdd 0 1
VSS vss 0 0
VIN ip 0 .65 ac 1
IREF vdd bn 10u
M5 bn bn vss vss nmos w=2.2u l=.3u
M6 tail bn vss vss nmos w=30u l=.3u
M1 left out tail vss nmos w=35u l=.3u
M2 stage1 ip tail vss nmos w=35u l=.3u
M3 left left vdd vdd pmos w=54u l=.3u
M4 stage1 left vdd vdd pmos w=54u l=.3u
M8 out bn vss vss nmos w=73u l=.3u
M7 out stage1 vdd vdd pmos w=269u l=.3u
RC stage1 cn 'rcomp'
CC cn out 'ccomp'
CL out 0 'cload'
RL out 0 'rload'
.op
.dc VIN 0 1 .001
.print dc v(out) v(stage1) v(tail) error=par('v(out)-v(ip)') i(VDD)
.ac dec 80 1 1g
.print ac vm(out) vp(out)
.measure ac closed_gain find vm(out) at=1

.alter loaded_100k
.temp 27
.param ccomp=10p rcomp=330 cload=10p rload=1e12
.param rload=100k

.alter loaded_10k
.temp 27
.param ccomp=10p rcomp=330 cload=10p rload=1e12
.param rload=10k

.end
