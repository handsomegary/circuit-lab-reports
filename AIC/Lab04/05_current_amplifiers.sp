* AIC Lab 4: Simple, cascode and differential current amplifiers
* Handout PDF pages 45-47.
* Supply: 1 V teaching adaptation; not a verified device rating.
* Model library is supplied separately by the user.
* MODEL_SETUP_REQUIRED
.option post=2 runlvl=5 accurate ingold=2 numdgt=8 measdgt=8
.temp 27
* Base case keeps matched source/sink currents and the literal grounded 1 kohm load.
* Cases 1..3 add 0.5 mA nominal PMOS DC current to bias that load near 0.5 V.
* Output NMOS widths are 100/1000/10000 um; reference width is 50 um.
* Differential input current difference is 1 A, with +/-0.5 A small-signal inputs.
* Cases 4..6 turn input AC off and inject 1 A separately into each output.
* Huge series load inductors retain DC loading but remove the 1 kohm from AC Rout.
* These are test fixtures only. Report their output voltage as intrinsic Rout;
* the gain_* and rin_* measures in Rout cases are inactive and are not gain values.
.param ratio=2 offset=0 drive=1 testout=0 lload=1p bottom_in=50u bottom_out=100u pscale=1
VDD vdd 0 1
IRs sbp 0 10u
MsR sbp sbp vdd vdd pmos w=100u l=.3u
MsP1 sin sbp vdd vdd pmos w='100u*pscale' l=.3u
MsP2 sout sbp vdd vdd pmos w='100u*(ratio+offset)*pscale' l=.3u
Ms1 sin sin 0 0 nmos w=50u l=.3u
Ms2 sout sin 0 0 nmos w='50u*ratio' l=.3u
IIs 0 sin 0 ac 'drive'
ITs 0 sout 0 ac 'testout'
RLs sout srl 1k
LLs srl 0 'lload'
IRc cbp 0 10u
McR cbp cbp vdd vdd pmos w=100u l=.3u
McP1 cin cbp vdd vdd pmos w='100u*pscale' l=.3u
McP2 cout cbp vdd vdd pmos w='100u*(ratio+offset)*pscale' l=.3u
Mc1 cin cin cs1 0 nmos w=50u l=.3u
Mc2 cout cin cs2 0 nmos w='50u*ratio' l=.3u
Mc7 cs1 cs1 0 0 nmos w='bottom_in' l=.3u
Mc8 cs2 cs1 0 0 nmos w='bottom_out*ratio/2' l=.3u
IIc 0 cin 0 ac 'drive'
ITc 0 cout 0 ac 'testout'
RLc cout crl 1k
LLc crl 0 'lload'
IRd dbp 0 10u
MdR dbp dbp vdd vdd pmos w=100u l=.3u
MdP1 din dbp vdd vdd pmos w='100u*pscale' l=.3u
MdP2 din2 dbp vdd vdd pmos w='100u*(ratio+1)' l=.3u
MdP3 dout dbp vdd vdd pmos w='100u*(ratio+offset)' l=.3u
Md1 din din 0 0 nmos w=50u l=.3u
Md2 din2 din 0 0 nmos w='50u*ratio' l=.3u
Md7 din2 din2 0 0 nmos w=50u l=.3u
Md8 dout din2 0 0 nmos w='50u*ratio' l=.3u
IIPd 0 din 0 ac '.5*drive'
IIMd 0 din2 0 ac '.5*drive' 180
ITd 0 dout 0 ac 'testout'
RLd dout drl 1k
LLd drl 0 'lload'

.op
.ac dec 60 1 10g
.print ac imag_s=im(RLs) imag_c=im(RLc) imag_d=im(RLd)
+ vin_s=vm(sin) vin_c=vm(cin) vin_d=vm(din,din2)
+ vout_s=vm(sout) vout_c=vm(cout) vout_d=vm(dout)
.measure ac gain_s find im(RLs) at=1
.measure ac gain_c find im(RLc) at=1
.measure ac gain_d find im(RLd) at=1
.measure ac rin_s find vm(sin) at=1
.measure ac rin_c find vm(cin) at=1
.measure ac rin_d find vm(din,din2) at=1

.alter biased_load_ratio2
.temp 27
.param ratio=2 offset=0 drive=1 testout=0 lload=1p bottom_in=50u bottom_out=100u pscale=1
.param offset=50

.alter biased_load_ratio20
.temp 27
.param ratio=2 offset=0 drive=1 testout=0 lload=1p bottom_in=50u bottom_out=100u pscale=1
.param offset=50 ratio=20

.alter biased_load_ratio200
.temp 27
.param ratio=2 offset=0 drive=1 testout=0 lload=1p bottom_in=50u bottom_out=100u pscale=1
.param offset=50 ratio=200

.alter output_resistance_ratio2
.temp 27
.param ratio=2 offset=0 drive=1 testout=0 lload=1p bottom_in=50u bottom_out=100u pscale=1
.param offset=50 drive=0 testout=1 lload=1e12

.alter output_resistance_ratio20
.temp 27
.param ratio=2 offset=0 drive=1 testout=0 lload=1p bottom_in=50u bottom_out=100u pscale=1
.param offset=50 ratio=20 drive=0 testout=1 lload=1e12

.alter output_resistance_ratio200
.temp 27
.param ratio=2 offset=0 drive=1 testout=0 lload=1p bottom_in=50u bottom_out=100u pscale=1
.param offset=50 ratio=200 drive=0 testout=1 lload=1e12

.alter cascode_lower_width_100u
.temp 27
.param ratio=2 offset=0 drive=1 testout=0 lload=1p bottom_in=50u bottom_out=100u pscale=1
.param offset=50 bottom_in=100u bottom_out=100u

.alter cascode_lower_width_1000u
.temp 27
.param ratio=2 offset=0 drive=1 testout=0 lload=1p bottom_in=50u bottom_out=100u pscale=1
.param offset=50 bottom_in=1000u bottom_out=1000u

.alter cascode_lower_width_10000u
.temp 27
.param ratio=2 offset=0 drive=1 testout=0 lload=1p bottom_in=50u bottom_out=100u pscale=1
.param offset=50 bottom_in=10000u bottom_out=10000u

.alter cascode_lower_rout_100u
.temp 27
.param ratio=2 offset=0 drive=1 testout=0 lload=1p bottom_in=50u bottom_out=100u pscale=1
.param offset=50 bottom_in=100u bottom_out=100u drive=0 testout=1 lload=1e12

.alter cascode_lower_rout_1000u
.temp 27
.param ratio=2 offset=0 drive=1 testout=0 lload=1p bottom_in=50u bottom_out=100u pscale=1
.param offset=50 bottom_in=1000u bottom_out=1000u drive=0 testout=1 lload=1e12

.alter cascode_lower_rout_10000u
.temp 27
.param ratio=2 offset=0 drive=1 testout=0 lload=1p bottom_in=50u bottom_out=100u pscale=1
.param offset=50 bottom_in=10000u bottom_out=10000u drive=0 testout=1 lload=1e12

.alter pmos_current_source_widths
.temp 27
.param ratio=2 offset=0 drive=1 testout=0 lload=1p bottom_in=50u bottom_out=100u pscale=1
.param offset=50 pscale=2

.end
