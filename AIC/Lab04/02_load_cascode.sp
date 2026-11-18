* AIC Lab 4: Differential voltage amplifier AC families
* Handout PDF pages 41-44.
* Supply: 1 V teaching adaptation; not a verified device rating.
* Model library is supplied separately by the user.
* MODEL_SETUP_REQUIRED
.option post=2 runlvl=5 accurate ingold=2 numdgt=8 measdgt=8
.temp 27
* Cases 0/1/2/3 excite differential/common-mode/positive/negative supply.
* Differential input is 1 V: +0.5 and -0.5, correcting the factor-of-two error.
* Supply rejection keeps ideal input voltages fixed relative to global ground.
* Cascode low-current cases are explicit 1 V adaptations, not old-process reproduction.
.param iref=0.5u scale=1 cm=.5 vbias=0.65
.param adiff=1 acom=0 ad=0 ag=0
VDD vdd 0 1 ac 'ad'
VSS vss 0 0 ac 'ag'
VCM cmnode 0 'cm' ac 'acom'
VD diff 0 0 ac 'adiff'
EP ip cmnode diff 0 .5
EM im cmnode diff 0 -.5
VBIAS bias 0 'vbias'
IRE vdd bn 'iref'
MREF bn bn vss vss nmos w=85u l=.3u
MTAIL tail bn vss vss nmos w=870u l=.3u
M1 left ip tail vss nmos w='425u*scale' l='.3u*scale'
M2 out im tail vss nmos w='425u*scale' l='.3u*scale'
M5 pb pb vdd vdd pmos w='1350u*scale' l='.3u*scale'
M6 pr pb vdd vdd pmos w='1350u*scale' l='.3u*scale'
M3 left left pb vdd pmos w='1350u*scale' l='.3u*scale'
M4 out left pr vdd pmos w='1350u*scale' l='.3u*scale'
CL out 0 10p

.op
.ac dec 60 1 10g
.print ac vdb(out) vp(out) vm(out)
.print ac vdiff=vm(ip,im) vcommon=vm(cmnode) supply_p=vm(vdd) supply_m=vm(vss)
.measure ac gain1 find vm(out) at=1
.measure ac gain_db find vdb(out) at=1

.alter common_mode
.temp 27
.param iref=0.5u scale=1 cm=.5 vbias=0.65
.param adiff=1 acom=0 ad=0 ag=0
.param adiff=0 acom=1

.alter supply_positive
.temp 27
.param iref=0.5u scale=1 cm=.5 vbias=0.65
.param adiff=1 acom=0 ad=0 ag=0
.param adiff=0 ad=1

.alter supply_negative
.temp 27
.param iref=0.5u scale=1 cm=.5 vbias=0.65
.param adiff=1 acom=0 ad=0 ag=0
.param adiff=0 ag=1

.alter original_current_headroom
.temp 27
.param iref=0.5u scale=1 cm=.5 vbias=0.65
.param adiff=1 acom=0 ad=0 ag=0
.param iref=50u

.end
