* AIC Lab 3: NMOS and PMOS source followers
* Handout PDF pages 38-39.
* Supply: 1 V teaching adaptation; not a verified device rating.
* Model library is supplied separately by the user.
* MODEL_SETUP_REQUIRED
.option post=2 runlvl=5 accurate ingold=2 numdgt=8 measdgt=8
.temp 27
* NMOS input sweeps; PMOS input stays at 0.1 V in this DC analysis.
* AC inputs each have unity amplitude and feed separate circuits.
.param iref=100u
VDD vdd 0 1
VIN in 0 .9 ac 1
VIP ip 0 .1 ac 1
IRN vdd bn 'iref'
IRP bp 0 'iref'
MNR bn bn 0 0 nmos w=30u l=1u
MNS on bn 0 0 nmos w=30u l=1u
MNF vdd in on 0 nmos w=30u l=1u
MPR bp bp vdd vdd pmos w=30u l=1u
MPS op bp vdd vdd pmos w=30u l=1u
MPF 0 ip op vdd pmos w=30u l=1u
CLN on 0 10p
CLP op 0 10p
.op
.dc VIN 0 1 .005
.print dc v(on) v(op) v(bn) v(bp) i(VDD)
.ac dec 60 1 10g
.print ac vm(on) vp(on) vm(op) vp(op)
.measure ac gain_n find vm(on) at=1
.measure ac gain_p find vm(op) at=1
.tf v(on) VIN

.alter low_current
.temp 27
.param iref=100u
.param iref=10u

.alter current166
.temp 27
.param iref=100u
.param iref=166u

.alter current333
.temp 27
.param iref=100u
.param iref=333u

.end
