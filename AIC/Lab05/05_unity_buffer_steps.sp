* AIC Lab 5: Uncompensated and compensated step, slew and settling
* Handout PDF pages 50-53,58.
* Supply: 1 V teaching adaptation; not a verified device rating.
* Model library is supplied separately by the user.
* MODEL_SETUP_REQUIRED
.option post=2 runlvl=5 accurate ingold=2 numdgt=8 measdgt=8
.temp 27
* Delayed finite-edge bidirectional input stays within the 1 V rails.
* Slew is extracted over the 20-80 percent output transition.
* Settling requires remaining within 1 percent of the measured final step for the rest of the observation window.
* A failure to settle is reported as not observed, not a fabricated time.
.param ccomp=1e-21 rcomp=1m cload=10p
VDD vdd 0 1
VSS vss 0 0
VIN ip 0 pulse(.6 .75 1u 1n 1n 2u 5u)
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

.op
.tran .2n 5u 0 .2n
.print tran v(ip) v(out) v(stage1) v(tail) error=par('v(out)-v(ip)')
.measure tran low_before avg v(out) from=.8u to=.99u
.measure tran high_final avg v(out) from=2.8u to=2.99u
.measure tran low_final avg v(out) from=4.8u to=5u
.measure tran out_max max v(out) from=1u to=3u
.measure tran out_min min v(out) from=3.002u to=5u

.alter miller_2p
.temp 27
.param ccomp=1e-21 rcomp=1m cload=10p
.param ccomp=2p

.alter series_rc_2p
.temp 27
.param ccomp=1e-21 rcomp=1m cload=10p
.param ccomp=2p rcomp=330

.alter adapted_rc_10p
.temp 27
.param ccomp=1e-21 rcomp=1m cload=10p
.param ccomp=10p rcomp=330

.end
