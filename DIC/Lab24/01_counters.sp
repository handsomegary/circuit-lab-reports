DIC Lab 24: 01_counters
* Handout physical PDF pages 94-98; transistor-level reconstruction.
* 1 V is a declared teaching condition, not a certified model rating.
* MODEL_SETUP_REQUIRED
.option post=2 runlvl=6 accurate warnlimit=100 measdgt=8 numdgt=8 ingold=2
.temp 25
.param VDDVAL=1

.subckt inv a y vp vn
MP y a vp vp pmos w=1.8u l=.25u
MN y a vn vn nmos w=.6u l=.25u
.ends
.subckt weak a y vp vn
MP y a vp vp pmos w=.3u l=1u
MN y a vn vn nmos w=.3u l=3u
.ends
.subckt tg a b en eb vp vn
MN b en a vn nmos w=.6u l=.25u
MP b eb a vp pmos w=.6u l=.25u
.ends
.subckt dff d ck cb q x y z vp vn
XT1 d x cb ck vp vn tg
XI1 x y vp vn inv
XT3 y z ck cb vp vn tg
XI3 z q vp vn inv
.ends
.subckt sdff d ck cb q x y z vp vn
XT1 d x cb ck vp vn tg
XI1 x y vp vn inv
XI2 y fb1 vp vn inv
XT2 fb1 x ck cb vp vn tg
XT3 y z ck cb vp vn tg
XI3 z q vp vn inv
XI4 q fb2 vp vn inv
XT4 fb2 z cb ck vp vn tg
.ends
.subckt kdff d ck cb q x y z vp vn
XT1 d x cb ck vp vn tg
XI1 x y vp vn inv
XK1 y x vp vn weak
XT3 y z ck cb vp vn tg
XI3 z q vp vn inv
XK2 q z vp vn weak
.ends
.subckt rdff d ck cb rst q x y z vp vn
XT1 d x cb ck vp vn tg
XI1 x y vp vn inv
XI2 y fb1 vp vn inv
XT2 fb1 x ck cb vp vn tg
XT3 y z ck cb vp vn tg
MP1 pr rst vp vp pmos w=3.6u l=.25u
MP2 q z pr vp pmos w=3.6u l=.25u
MN1 q z vn vn nmos w=.6u l=.25u
MN2 q rst vn vn nmos w=.6u l=.25u
XI4 q fb2 vp vn inv
XT4 fb2 z cb ck vp vn tg
.ends
.subckt c2 a y cp cn vp vn
MP1 p a vp vp pmos w=1.8u l=.25u
MP2 y cp p vp pmos w=1.8u l=.25u
MN1 y cn n vn nmos w=.6u l=.25u
MN2 n a vn vn nmos w=.6u l=.25u
.ends
.subckt ndyn a y ck vp vn
MP y ck vp vp pmos w=1.8u l=.25u
MN1 y a x vn nmos w=.6u l=.25u
MN2 x vp f vn nmos w=.6u l=.25u
MN3 f ck vn vn nmos w=.6u l=.25u
.ends
.subckt pdyn a y cb vp vn
MP1 p cb vp vp pmos w=1.8u l=.25u
MP2 y a p vp pmos w=1.8u l=.25u
MN y cb vn vn nmos w=.6u l=.25u
.ends
.subckt nclock a y ck vp vn
MP y a vp vp pmos w=1.8u l=.25u
MN1 y ck n vn nmos w=.6u l=.25u
MN2 n a vn vn nmos w=.6u l=.25u
.ends
.subckt pclock a y ck vp vn
MP1 p a vp vp pmos w=1.8u l=.25u
MP2 y ck p vp pmos w=1.8u l=.25u
MN y a vn vn nmos w=.6u l=.25u
.ends
.subckt nlatch a y ck x vp vn
MP x ck vp vp pmos w=1.8u l=.25u
MN1 x a n vn nmos w=.6u l=.25u
MN2 n ck vn vn nmos w=.6u l=.25u
XO x y ck vp vn nclock
.ends
.subckt platch a y ck x vp vn
MP1 p ck vp vp pmos w=1.8u l=.25u
MP2 x a p vp pmos w=1.8u l=.25u
MN x ck vn vn nmos w=.6u l=.25u
XO x y ck vp vn pclock
.ends
.subckt tfull a q ck m x z vp vn
XM a m ck x vp vn platch
XS m q ck z vp vn nlatch
.ends
.subckt tshort a q ck m z vp vn
XM a m ck vp vn pclock
XS m q ck z vp vn nlatch
.ends

.subckt nand2 a b y vp vn
MP1 y a vp vp pmos w=1.8u l=.25u
MP2 y b vp vp pmos w=1.8u l=.25u
MN1 y a x vn nmos w=1.2u l=.25u
MN2 x b vn vn nmos w=1.2u l=.25u
.ends
.subckt and2 a b y vp vn
X1 a b z vp vn nand2
X2 z y vp vn inv
.ends
.subckt xor2 a b y vp vn
X1 a b n1 vp vn nand2
X2 a n1 n2 vp vn nand2
X3 b n1 n3 vp vn nand2
X4 n2 n3 y vp vn nand2
.ends
.subckt counterff d ck cb rst q x y z vp vn
XT1 d x cb ck vp vn tg
XR rst rb vp vn inv
XI1 x rb y vp vn nand2
XI2 y fb1 vp vn inv
XT2 fb1 x ck cb vp vn tg
XT3 y z ck cb vp vn tg
MP1 pr rst vp vp pmos w=3.6u l=.25u
MP2 q z pr vp pmos w=3.6u l=.25u
MN1 q z vn vn nmos w=.6u l=.25u
MN2 q rst vn vn nmos w=.6u l=.25u
XI4 q fb2 vp vn inv
XT4 fb2 z cb ck vp vn tg
.ends
.subckt syncgate ck en y vp vn
X1 ck n2 n1 vp vn nand2
X2 n1 en n2 vp vn nand2
X3 n2 n4 n3 vp vn nand2
X4 n3 ck n4 vp vn nand2
X5 n4 y vp vn inv
.ends
.subckt dyn_n a b y ck vp vn
MP y ck vp vp pmos w=1.8u l=.25u
MN1 y a n1 vn nmos w=.6u l=.25u
MN2 n1 b n2 vn nmos w=.6u l=.25u
MN3 n2 ck vn vn nmos w=.6u l=.25u
.ends
.subckt dyn_p a b y cb vp vn
MP1 n1 cb vp vp pmos w=1.8u l=.25u
MP2 n2 a n1 vp pmos w=1.8u l=.25u
MP3 y b n2 vp pmos w=1.8u l=.25u
MN y cb vn vn nmos w=.6u l=.25u
.ends
.param PER=20n SLEW=20p
VCLK clk 0 pulse(0 1 'PER/4' SLEW SLEW 'PER/2-SLEW' PER)
VS vs 0 1
VA va 0 1
VRST rst 0 pwl(0 1 '1.5*PER' 1 '1.5*PER+SLEW' 0)
XCS clk cb vs 0 inv
XJC j2 j2b vs 0 inv
XJ1 j2b clk cb rst j1 J1x J1y J1z vs 0 counterff
XJ2 j1 clk cb rst j2 J2x J2y J2z vs 0 counterff
XJ3 j2 clk cb rst b1 J3x J3y J3z vs 0 counterff
XJB b1 j2b b0 vs 0 xor2
XE1 b0 b1 en1 vs 0 and2
XE2 b2 b3 en23 vs 0 and2
XE3 en23 b4 en234 vs 0 and2
XE4 en1 en234 en2 vs 0 and2
XG1 clk en1 ck2 vs 0 syncgate
XG2 clk en2 ck5 vs 0 syncgate
XCB2 ck2 cb2 vs 0 inv
XCB5 ck5 cb5 vs 0 inv
XX2 b2 vs d2 vs 0 xor2
XS2 d2 ck2 cb2 rst b2 S2x S2y S2z vs 0 counterff
XC2 b2 vs carry2 vs 0 and2
XX3 b3 carry2 d3 vs 0 xor2
XS3 d3 ck2 cb2 rst b3 S3x S3y S3z vs 0 counterff
XC3 b3 carry2 carry3 vs 0 and2
XX4 b4 carry3 d4 vs 0 xor2
XS4 d4 ck2 cb2 rst b4 S4x S4y S4z vs 0 counterff
XC4 b4 carry3 carry4 vs 0 and2
XX5 b5 vs d5 vs 0 xor2
XS5 d5 ck5 cb5 rst b5 S5x S5y S5z vs 0 counterff
XC5 b5 vs carry5 vs 0 and2
XX6 b6 carry5 d6 vs 0 xor2
XS6 d6 ck5 cb5 rst b6 S6x S6y S6z vs 0 counterff
XC6 b6 carry5 carry6 vs 0 and2
XX7 b7 carry6 d7 vs 0 xor2
XS7 d7 ck5 cb5 rst b7 S7x S7y S7z vs 0 counterff
XC7 b7 carry6 carry7 vs 0 and2
XCA clk cba va 0 inv
XAR0 a0 ab0 va 0 inv
XA0 ab0 clk cba rst a0 A0x A0y A0z va 0 counterff
XAR1 a1 ab1 va 0 inv
XA1 ab1 ab0 a0 rst a1 A1x A1y A1z va 0 counterff
XAR2 a2 ab2 va 0 inv
XA2 ab2 ab1 a1 rst a2 A2x A2y A2z va 0 counterff
XAR3 a3 ab3 va 0 inv
XA3 ab3 ab2 a2 rst a3 A3x A3y A3z va 0 counterff
Cb0 b0 0 5f
Cb1 b1 0 5f
Cb2 b2 0 5f
Cb3 b3 0 5f
Cb4 b4 0 5f
Cb5 b5 0 5f
Cb6 b6 0 5f
Cb7 b7 0 5f
Ca0 a0 0 5f
Ca1 a1 0 5f
Ca2 a2 0 5f
Ca3 a3 0 5f
.measure tran sync_power avg par('-i(VS)') from='10*PER' to='270*PER'
.measure tran async_power avg par('-i(VA)') from='10*PER' to='270*PER'
.measure tran clock_charge integ par('-i(VCLK)') from='10.25*PER' to='10.25*PER+SLEW'
.tran 'PER/200' '275*PER'
.print tran v(clk) v(rst) v(b0) v(b1) v(b2) v(b3) v(b4) v(b5) v(b6) v(b7) v(a0) v(a1) v(a2) v(a3) v(ck2) v(ck5)

.alter period_10n
.param PER=10n SLEW=20p VDDVAL=1
.temp 25

.alter period_5n
.param PER=5n SLEW=20p VDDVAL=1
.temp 25

.alter period_3n
.param PER=3n SLEW=20p VDDVAL=1
.temp 25

.alter period_2n
.param PER=2n SLEW=20p VDDVAL=1
.temp 25

.alter period_1.5n
.param PER=1.5n SLEW=20p VDDVAL=1
.temp 25

.alter period_1n
.param PER=1n SLEW=20p VDDVAL=1
.temp 25

.end
