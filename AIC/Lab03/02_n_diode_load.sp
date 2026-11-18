* AIC Lab 3: CS amplifier with NMOS diode load
* Handout PDF pages 33-34.
* Supply: 1 V teaching adaptation; not a verified device rating.
* Model library is supplied separately by the user.
* MODEL_SETUP_REQUIRED
.option post=2 runlvl=5 accurate ingold=2 numdgt=8 measdgt=8
.temp 27
* Input bias is calibrated from the DC transfer to Vout=0.5 V.
* Calibration is numerical bias selection, not an added feedback circuit.
* NMOS bodies remain at ground; the handout p33 body-to-VDD statement is not used.
.param wn=150u vb=0.1969673505
VDD vdd 0 1
VIN in 0 dc 'vb' ac 1
M1 out in 0 0 nmos w='wn' l=1u
ML vdd vdd out 0 nmos w=2u l=1u
CL out 0 10p
.op
.dc VIN 0 1 .001
.print dc v(out) i(VDD)
.ac dec 60 1 10g
.print ac vdb(out) vp(out) vm(out)
.measure ac gain1 find vm(out) at=1
.measure ac gain_db find vdb(out) at=1
.tf v(out) VIN

.alter width_200u
.temp 27
.param wn=150u vb=0.1969673505
.param wn=200u vb=0.1853160153

.alter width_300u
.temp 27
.param wn=150u vb=0.1969673505
.param wn=300u vb=0.1690870835

.end
