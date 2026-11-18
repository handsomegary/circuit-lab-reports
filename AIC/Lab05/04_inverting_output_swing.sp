* AIC Lab 5: Inverting gain -10 and output swing
* Handout PDF pages 55.
* Supply: 1 V teaching adaptation; not a verified device rating.
* Model library is supplied separately by the user.
* MODEL_SETUP_REQUIRED
.option post=2 runlvl=5 accurate ingold=2 numdgt=8 measdgt=8
.temp 27
* Rin=10 kohm and Rf=100 kohm set the specified -10 ratio about Vref=0.65 V.
* Ideal transfer is 11*0.65 - 10*Vin. Rail clipping is retained in DC data.
.param ccomp=10p rcomp=330 cload=10p rload=1e12
VDD vdd 0 1
VSS vss 0 0
VREF ip 0 .65
VIN input 0 .65 ac 1
RIN input im 10k
RF out im 100k
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
RL out 0 'rload'
.op
.dc VIN .55 .75 .0002
.print dc v(out) v(im) ideal=par('7.15-10*v(input)')
+ error=par('v(out)-(7.15-10*v(input))') i(VDD)
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
