* AIC Lab 2: Startup injection with power-up ramps
* Handout PDF pages 26-28.
* Supply: 1 V teaching adaptation; not a verified device rating.
* Model library is supplied separately by the user.
* MODEL_SETUP_REQUIRED
.option post=2 runlvl=5 accurate ingold=2 numdgt=8 measdgt=8
.temp 27
* UIC begins with uncharged capacitors. The disconnected variant preserves the core.
* Parasitic/leakage startup in one nominal run is not a robustness guarantee.
.param rbias=1k rstart=1m tr=1u
VDD vdd 0 pwl(0 0 'tr' 1 50u 1)
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

.op
.tran 20n 50u 0 20n uic
.print tran v(vdd) v(nx) v(bp) v(st) i(MS3) i(M3)
.measure tran nx_final find v(nx) at=49u
.measure tran inject_peak max par('abs(i(MS3))') from=0 to=40u
.measure tran inject_final find par('abs(i(MS3))') at=49u
.measure tran core_final find par('abs(i(M3))') at=49u

.alter slow_ramp
.temp 27
.param rbias=1k rstart=1m tr=1u
.param tr=30u

.alter startup_disconnected
.temp 27
.param rbias=1k rstart=1m tr=1u
.param rstart=1e15

.alter slow_without_startup
.temp 27
.param rbias=1k rstart=1m tr=1u
.param tr=30u rstart=1e15

.end
