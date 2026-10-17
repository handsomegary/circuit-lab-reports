* AIC Lab 3: CS current-source load width, current and length comparisons
* Handout PDF pages 35-37,39-40.
* Supply: 1 V teaching adaptation; not a verified device rating.
* Model library is supplied separately by the user.
* MODEL_SETUP_REQUIRED
.option post=2 runlvl=5 accurate ingold=2 numdgt=8 measdgt=8
.temp 27
* Cases 0..6 retain the handout 100/166/333 uA and geometry comparisons.
* Cases 7..9 explicitly adapt current to 10 uA for 1 V headroom.
* For equal-W/L scaling both W and L are multiplied, not W alone.
.param wn=10u wp=30u length=1u iref=100u vb=0.5524296483
VDD vdd 0 1
VIN in 0 dc 'vb' ac 1
IREF bp 0 'iref'
MREF bp bp vdd vdd pmos w='wp' l='length'
MP out bp vdd vdd pmos w='wp' l='length'
MN out in 0 0 nmos w='wn' l='length'
CL out 0 10p
.op
.dc VIN 0 1 .001
.print dc v(out) v(bp) i(VDD) i(MN)
.ac dec 60 1 10g
.print ac vdb(out) vp(out) vm(out)
.measure ac gain1 find vm(out) at=1
.measure ac gain_db find vdb(out) at=1
.tf v(out) VIN

.alter comparison_1
.temp 27
.param wn=10u wp=30u length=1u iref=100u vb=0.5524296483
.param wn=18u wp=30u length=1u iref=100u vb=0.4998122107

.alter comparison_2
.temp 27
.param wn=10u wp=30u length=1u iref=100u vb=0.5524296483
.param wn=26u wp=30u length=1u iref=100u vb=0.4722481617

.alter comparison_3
.temp 27
.param wn=10u wp=30u length=1u iref=100u vb=0.5524296483
.param wn=10u wp=30u length=1u iref=166u vb=0.6098318322

.alter comparison_4
.temp 27
.param wn=10u wp=30u length=1u iref=100u vb=0.5524296483
.param wn=10u wp=30u length=1u iref=333u vb=0.7151735494

.alter comparison_5
.temp 27
.param wn=10u wp=30u length=1u iref=100u vb=0.5524296483
.param wn=30u wp=90u length=3u iref=100u vb=0.5548111131

.alter comparison_6
.temp 27
.param wn=10u wp=30u length=1u iref=100u vb=0.5524296483
.param wn=50u wp=150u length=5u iref=100u vb=0.5553898087

.alter comparison_7
.temp 27
.param wn=10u wp=30u length=1u iref=100u vb=0.5524296483
.param wn=10u wp=30u length=1u iref=10u vb=0.3912598248

.alter comparison_8
.temp 27
.param wn=10u wp=30u length=1u iref=100u vb=0.5524296483
.param wn=18u wp=30u length=1u iref=10u vb=0.3609206466

.alter comparison_9
.temp 27
.param wn=10u wp=30u length=1u iref=100u vb=0.5524296483
.param wn=26u wp=30u length=1u iref=10u vb=0.3428293584

.end
