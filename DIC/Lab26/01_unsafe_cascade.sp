DIC Lab 26: 01_unsafe_cascade
* Handout physical PDF pages 107-110; transistor-level reconstruction.
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
.param PER=10n SLEW=20p
VCLK clk 0 pulse(0 1 'PER/4' SLEW SLEW 'PER/2-SLEW' PER)
VDD vdd 0 1
VIN a 0 pwl(0 0 1n 0 1.02n 1 8n 1 8.02n 0 11n 0 11.02n 1)
X1 a vdd x clk vdd 0 dyn_n
X2 x vdd y clk vdd 0 dyn_n
CX x 0 5f
CY y 0 5f
.tran 2p 20n
.print tran v(clk) v(a) v(x) v(y)
.measure tran output_min min v(y) from=3n to=7n
.measure tran output_final find v(y) at=7n

.end
