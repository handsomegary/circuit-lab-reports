
* NMOS RC Phase Shift Oscillator

* MODEL_SETUP_REQUIRED
* Power supply
vdd vdd 0 2.5

* NMOS amplifier
mn1 out gate 0 0 nmos L=0.25u W=10u

* Drain resistor
rd vdd out 10k

* Gate DC bias
rbg1 vdd vb 100k
rbg2 vb 0 100k
rbias vb gate 1meg

* Three-stage RC network
c1 out n1 10n
r1 n1 0 1k

c2 n1 n2 10n
r2 n2 0 1k

c3 n2 gate 10n
r3 gate 0 1meg

* Initial condition
.ic v(n1)=0.01

* Transient analysis
.tran 0.1u 3m

.probe tran v(out) v(gate) v(n1) v(n2)

.op
.option post=2
.end
