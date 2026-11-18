DIC Lab 15: 02_inverter_ff
* Handout PDF pages 62-64; user-selected CIC 0.18 um 1.8 V devices.
* Nominal 1.8 V; +/-10 percent are explicit corner experiments.
* Geometry retains handout Wn/Wp/L = 0.6/1.8/0.25 um.
* MODEL_SETUP_REQUIRED FF
.option post=2 runlvl=6 accurate warnlimit=100 measdgt=8 numdgt=8 ingold=2
.param VDDVAL=1.98
.temp 0
VDD vdd 0 'VDDVAL'
VIN in 0 pulse(0 'VDDVAL' 1n .2n .2n 1.8n 4n)
MP out in vdd vdd p_18 w=1.8u l=.25u
MN out in 0 0 n_18 w=.6u l=.25u
CL out 0 10f
.tran 2p 12n
.print tran v(in) v(out) i(VDD)
.measure tran tphl trig v(in) val='VDDVAL/2' rise=2 targ v(out) val='VDDVAL/2' fall=2
.measure tran tplh trig v(in) val='VDDVAL/2' fall=2 targ v(out) val='VDDVAL/2' rise=2
.measure tran pavg avg par('-v(vdd)*i(VDD)') from=4n to=12n

.alter process_only_at_nominal
.param VDDVAL=1.8
.temp 25

.end
