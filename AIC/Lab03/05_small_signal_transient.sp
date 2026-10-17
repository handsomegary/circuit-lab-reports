* AIC Lab 3: CS and follower transient verification
* Handout PDF pages 35-40.
* Supply: 1 V teaching adaptation; not a verified device rating.
* Model library is supplied separately by the user.
* MODEL_SETUP_REQUIRED
.option post=2 runlvl=5 accurate ingold=2 numdgt=8 measdgt=8
.temp 27

.param vb=0.3912598248 amp=.1m
VDD vdd 0 1
VIN in 0 sin('vb' 'amp' 1k)
VIF inf 0 sin(.9 10m 1k)
IREF bp 0 10u
MREF bp bp vdd vdd pmos w=30u l=1u
MP out bp vdd vdd pmos w=30u l=1u
MN out in 0 0 nmos w=10u l=1u
IRF vdd bn 10u
MNR bn bn 0 0 nmos w=30u l=1u
MNS of bn 0 0 nmos w=30u l=1u
MNF vdd inf of 0 nmos w=30u l=1u
CL out 0 10p
CLF of 0 10p
.op
.tran 1u 5m 0 1u
.print tran v(in) v(out) v(inf) v(of)
.measure tran cs_pp pp v(out) from=4m to=5m
.measure tran follower_pp pp v(of) from=4m to=5m

.alter amplitude_1m
.temp 27
.param vb=0.3912598248 amp=.1m
.param amp=1m

.alter amplitude_3m
.temp 27
.param vb=0.3912598248 amp=.1m
.param amp=3m

.end
