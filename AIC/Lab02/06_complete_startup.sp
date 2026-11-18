* AIC Lab 2: Complete reference startup and settling
* Handout PDF pages 26-30.
* Supply: 1 V teaching adaptation; not a verified device rating.
* Model library is supplied separately by the user.
* MODEL_SETUP_REQUIRED
.option post=2 runlvl=5 accurate ingold=2 numdgt=8 measdgt=8
.temp 27

.param rbias=1k rstart=1m rupper=5k tr=1u
VDD vdd 0 pwl(0 0 'tr' 1 100u 1)
M1 nx bp rs vdd pmos w=115u l=.3u
M2 bp bp vdd vdd pmos w=22u l=.3u
M3 nx nx 0 0 nmos w=4.85u l=.3u
M4 bp nx 0 0 nmos w=4.85u l=.3u
RB vdd rs 'rbias'
CNX nx 0 20f
CBP bp 0 20f
MS1 st bp vdd vdd pmos w=2u l=.3u
MS2 st bp 0 0 nmos w=.2u l=.3u
MS3 inj st vdd vdd pmos w=10u l=.3u
RSTART inj nx 'rstart'
CST st 0 20f
M5 top bp vdd vdd pmos w=22u l=.3u
MP vref vref top vdd pmos w=22u l=.3u
MN vref div 0 0 nmos w=4.85u l=.3u
R3 top div 'rupper'
R4 div 0 1k
CL vref 0 1p

.op
.tran 20n 100u 0 20n uic
.print tran v(vdd) v(vref) v(nx) v(bp) v(st) i(MS3)
.measure tran ref_final find v(vref) at=99u
.measure tran ref_last_avg avg v(vref) from=90u to=100u
.measure tran supply_avg avg par('-v(vdd)*i(VDD)') from=90u to=100u

.alter slow_ramp
.temp 27
.param rbias=1k rstart=1m rupper=5k tr=1u
.param tr=30u

.alter cold
.temp 27
.param rbias=1k rstart=1m rupper=5k tr=1u
.temp -20

.alter hot
.temp 27
.param rbias=1k rstart=1m rupper=5k tr=1u
.temp 85

.alter startup_disconnected
.temp 27
.param rbias=1k rstart=1m rupper=5k tr=1u
.param rstart=1e15

.end
