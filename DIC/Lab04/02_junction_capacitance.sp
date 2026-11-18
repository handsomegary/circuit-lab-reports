DIC Lab 4: 02_junction_capacitance
* MODEL_SETUP_REQUIRED
* Handout-based simulation at 1 V; this condition is not a model voltage rating.
.option post=2 nomod runlvl=6 measdgt=10 numdgt=10 ingold=2
.temp 27
.param VS=1
VDD vdd 0 'VS'
* Small-signal drain capacitance difference with and without explicit junction geometry.
* All terminals except tested drain have zero AC excitation; MOS channel is off.
.param BV=0
Vn0 dn0 0 BV AC 1
Mn0 dn0 0 0 0 nmos W=1.8u L=0.25u AD=0 AS=0 PD=0 PS=0 NRD=0 NRS=0
.measure ac in0 FIND II(Vn0) AT=1meg
Vn1 dn1 0 BV AC 1
Mn1 dn1 0 0 0 nmos W=1.8u L=0.25u AD=0.972p AS=0.972p PD=4.68u PS=4.68u NRD=0.15 NRS=0.15
.measure ac in1 FIND II(Vn1) AT=1meg
Vn2 dn2 0 BV AC 1
Mn2 dn2 0 0 0 nmos W=1.8u L=0.25u AD=0.972p AS=0.972p PD=2.88u PS=2.88u NRD=0.15 NRS=0.15
.measure ac in2 FIND II(Vn2) AT=1meg
Vn3 dn3 0 BV AC 1
Mn3 dn3 0 0 0 nmos W=1.8u L=0.25u AD=0.486p AS=0.972p PD=0.54u PS=2.88u NRD=0.15 NRS=0.15
.measure ac in3 FIND II(Vn3) AT=1meg
.measure ac cn1 PARAM='-(in1-in0)/6283185.307179586'
.measure ac cn2 PARAM='-(in2-in0)/6283185.307179586'
.measure ac cn3 PARAM='-(in3-in0)/6283185.307179586'
Vp0 dp0 0 'VS-BV' AC 1
Mp0 dp0 vdd vdd vdd pmos W=1.8u L=0.25u AD=0 AS=0 PD=0 PS=0 NRD=0 NRS=0
.measure ac ip0 FIND II(Vp0) AT=1meg
Vp1 dp1 0 'VS-BV' AC 1
Mp1 dp1 vdd vdd vdd pmos W=1.8u L=0.25u AD=0.972p AS=0.972p PD=4.68u PS=4.68u NRD=0.15 NRS=0.15
.measure ac ip1 FIND II(Vp1) AT=1meg
Vp2 dp2 0 'VS-BV' AC 1
Mp2 dp2 vdd vdd vdd pmos W=1.8u L=0.25u AD=0.972p AS=0.972p PD=2.88u PS=2.88u NRD=0.15 NRS=0.15
.measure ac ip2 FIND II(Vp2) AT=1meg
Vp3 dp3 0 'VS-BV' AC 1
Mp3 dp3 vdd vdd vdd pmos W=1.8u L=0.25u AD=0.486p AS=0.972p PD=0.54u PS=2.88u NRD=0.15 NRS=0.15
.measure ac ip3 FIND II(Vp3) AT=1meg
.measure ac cp1 PARAM='-(ip1-ip0)/6283185.307179586'
.measure ac cp2 PARAM='-(ip2-ip0)/6283185.307179586'
.measure ac cp3 PARAM='-(ip3-ip0)/6283185.307179586'
Vns0 dns0 0 BV AC 1
Mns0 0 0 dns0 0 nmos W=1.8u L=0.25u AS=0 AD=0 PS=0 PD=0 NRD=0 NRS=0
.measure ac ins0 FIND II(Vns0) AT=1meg
Vns1 dns1 0 BV AC 1
Mns1 0 0 dns1 0 nmos W=1.8u L=0.25u AS=0.972p AD=0.972p PS=4.68u PD=4.68u NRD=0.15 NRS=0.15
.measure ac ins1 FIND II(Vns1) AT=1meg
Vns2 dns2 0 BV AC 1
Mns2 0 0 dns2 0 nmos W=1.8u L=0.25u AS=0.972p AD=0.972p PS=2.88u PD=2.88u NRD=0.15 NRS=0.15
.measure ac ins2 FIND II(Vns2) AT=1meg
Vns3 dns3 0 BV AC 1
Mns3 0 0 dns3 0 nmos W=1.8u L=0.25u AS=0.486p AD=0.972p PS=0.54u PD=2.88u NRD=0.15 NRS=0.15
.measure ac ins3 FIND II(Vns3) AT=1meg
.measure ac cns1 PARAM='-(ins1-ins0)/6283185.307179586'
.measure ac cns2 PARAM='-(ins2-ins0)/6283185.307179586'
.measure ac cns3 PARAM='-(ins3-ins0)/6283185.307179586'
Vps0 dps0 0 'VS-BV' AC 1
Mps0 vdd vdd dps0 vdd pmos W=1.8u L=0.25u AS=0 AD=0 PS=0 PD=0 NRD=0 NRS=0
.measure ac ips0 FIND II(Vps0) AT=1meg
Vps1 dps1 0 'VS-BV' AC 1
Mps1 vdd vdd dps1 vdd pmos W=1.8u L=0.25u AS=0.972p AD=0.972p PS=4.68u PD=4.68u NRD=0.15 NRS=0.15
.measure ac ips1 FIND II(Vps1) AT=1meg
Vps2 dps2 0 'VS-BV' AC 1
Mps2 vdd vdd dps2 vdd pmos W=1.8u L=0.25u AS=0.972p AD=0.972p PS=2.88u PD=2.88u NRD=0.15 NRS=0.15
.measure ac ips2 FIND II(Vps2) AT=1meg
Vps3 dps3 0 'VS-BV' AC 1
Mps3 vdd vdd dps3 vdd pmos W=1.8u L=0.25u AS=0.486p AD=0.972p PS=0.54u PD=2.88u NRD=0.15 NRS=0.15
.measure ac ips3 FIND II(Vps3) AT=1meg
.measure ac cps1 PARAM='-(ips1-ips0)/6283185.307179586'
.measure ac cps2 PARAM='-(ips2-ips0)/6283185.307179586'
.measure ac cps3 PARAM='-(ips3-ips0)/6283185.307179586'
.ac lin 1 1meg 1meg
.param BV=0
.temp 27

.alter case_001
.param BV=0.25
.temp 27

.alter case_002
.param BV=0.5
.temp 27

.alter case_003
.param BV=0.75
.temp 27

.alter case_004
.param BV=1
.temp 27

.end
