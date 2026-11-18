* AIC Lab 2: Complete reference, line response and temperature
* Handout PDF pages 27-30.
* Supply: 1 V teaching adaptation; not a verified device rating.
* Model library is supplied separately by the user.
* MODEL_SETUP_REQUIRED
.option post=2 runlvl=5 accurate ingold=2 numdgt=8 measdgt=8
.temp 27
* Temperature tests use the same available model, not independent process corners.
* The PDF p29 text says 1.62 mV while its plot shows approximately 1.62 V.
.param rbias=1k rstart=1m rupper=5k
VDD vdd 0 1 ac 1
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
.nodeset v(nx)=.4 v(bp)=.6 v(st)=0
.op
.dc VDD .4 1 .005
.print dc v(vref) v(nx) v(bp) v(top) v(div) i(VDD)
.measure dc ref1 find v(vref) at=1
.measure dc supply_i find par('-i(VDD)') at=1
.ac dec 40 1 100meg
.print ac vm(vref) vp(vref)
.measure ac supply_to_output find vm(vref) at=1

.alter cold
.temp 27
.param rbias=1k rstart=1m rupper=5k
.temp -20

.alter hot
.temp 27
.param rbias=1k rstart=1m rupper=5k
.temp 85

.alter reference_ratio
.temp 27
.param rbias=1k rstart=1m rupper=5k
.param rupper=3k

.alter bias_resistor
.temp 27
.param rbias=1k rstart=1m rupper=5k
.param rbias=2k

.end
