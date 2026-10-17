* AIC Lab 2: Two diode-connected MOS reference
* Handout PDF pages 22-23.
* Supply: 1 V teaching adaptation; not a verified device rating.
* Model library is supplied separately by the user.
* MODEL_SETUP_REQUIRED
.option post=2 runlvl=5 accurate ingold=2 numdgt=8 measdgt=8
.temp 27
* PMOS bulk is tied to its source, correcting the reference-code bulk connection.
.param wn=21u wp=10u
VDD vdd 0 1 ac 1
MP vref vref vdd vdd pmos w='wp' l=.3u
MN vref vref 0 0 nmos w='wn' l=.3u
CL vref 0 1p
.op
.dc VDD .1 1 .005
.print dc v(vref) i(VDD)
.measure dc vref1 find v(vref) at=1
.measure dc power1 find par('-i(VDD)') at=1
.ac dec 40 1 1g
.print ac vm(vref) vp(vref)
.measure ac line_gain find vm(vref) at=1

.alter wider_p
.temp 27
.param wn=21u wp=10u
.param wp=20u

.alter wider_n
.temp 27
.param wn=21u wp=10u
.param wn=42u

.end
