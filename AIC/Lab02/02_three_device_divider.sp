* AIC Lab 2: Three MOS and isolated middle well
* Handout PDF pages 24.
* Supply: 1 V teaching adaptation; not a verified device rating.
* Model library is supplied separately by the user.
* MODEL_SETUP_REQUIRED
.option post=2 runlvl=5 accurate ingold=2 numdgt=8 measdgt=8
.temp 27
* The old 0.8/2.1 V pair is not attainable on a 1 V supply.
* M2 body-source connection requires an isolated PMOS well in physical layout.
.param wp=20u wn=17.5u
VDD vdd 0 1 ac 1
M3 high high vdd vdd pmos w='wp' l=.3u
M2 low low high high pmos w='wp' l=.3u
M1 low low 0 0 nmos w='wn' l=.3u
CH high 0 1p
CL low 0 1p
.op
.dc VDD .1 1 .005
.print dc v(low) v(high) i(VDD)
.measure dc low1 find v(low) at=1
.measure dc high1 find v(high) at=1
.ac dec 40 1 1g
.print ac vm(low) vm(high) vp(low) vp(high)

.alter wider_p
.temp 27
.param wp=20u wn=17.5u
.param wp=40u

.alter wider_n
.temp 27
.param wp=20u wn=17.5u
.param wn=35u

.end
