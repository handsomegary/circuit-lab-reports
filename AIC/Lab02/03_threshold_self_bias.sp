* AIC Lab 2: Threshold reference and zero-current equilibrium
* Handout PDF pages 25.
* Supply: 1 V teaching adaptation; not a verified device rating.
* Model library is supplied separately by the user.
* MODEL_SETUP_REQUIRED
.option post=2 runlvl=5 accurate ingold=2 numdgt=8 measdgt=8
.temp 27
* Nodeset is only a solver hint; it is not a hardware startup circuit.
* M2 NMOS body is at ground; body effect is retained.
* Output branch M5 omitted by the reference code is restored.
.param rset=5k
VDD vdd 0 1 ac 1
M4 bp bp vdd vdd pmos w=155u l=.3u
M3 nx bp vdd vdd pmos w=160u l=.3u
M2 bp nx vr 0 nmos w=18u l=.3u
M1 nx vr 0 0 nmos w=17u l=.3u
M5 out bp vdd vdd pmos w=155u l=.3u
VOUT out 0 .5
RSET vr 0 'rset'
.nodeset v(nx)=.8 v(bp)=.5 v(vr)=.4
.op
.dc VDD .2 1 .005
.print dc v(vr) v(nx) v(bp) i(VOUT) i(VDD)
.measure dc ref1 find v(vr) at=1
.measure dc output_i find i(VOUT) at=1
.ac dec 40 1 100meg
.print ac vm(vr) vp(vr)

.alter rset_double
.temp 27
.param rset=5k
.param rset=10k

.end
