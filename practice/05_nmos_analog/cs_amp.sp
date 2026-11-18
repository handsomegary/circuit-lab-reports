
* NMOS Common Source Amplifier Test

* MODEL_SETUP_REQUIRED
vdd vdd 0 2.5

* Gate bias and sine input
vgs gate 0 SIN(1.0 0.01 10k)

* NMOS
mn1 out gate 0 0 nmos L=0.25u W=10u

* Drain resistor
rd vdd out 10k

* Transient analysis
.tran 0.1u 1m

.probe tran v(gate) v(out)

.op
.option post=2
.end
