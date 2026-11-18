* DIC Lab 20: Static DFF setup both data directions
* Handout PDF pages 82-84. 1 V teaching adaptation.
* MODEL_SETUP_REQUIRED
.option post=2 runlvl=5 accurate ingold=2 numdgt=8 measdgt=8
.temp 27
* Static master/slave transmission-gate DFF from Fig 20.2(b).
* Complementary clock is ideal to isolate intrinsic timing; 20 ps edge.
* Clock 50 percent is 1.01 ns. Setup offset is before clock; hold is after clock.
* Pass requires both 1.8 ns capture and 3 ns hold within 0.1/0.9 V rails.
* No metastability MTBF or library characterization claim.
.param initial=0 final=1 offset=200p
.subckt inv a z vp vn k=1
MP z a vp vp pmos w='3.6u*k' l=.25u
MN z a vn vn nmos w='1.8u*k' l=.25u
.ends inv
.subckt tg a z en eb vp vn k=1
MP a eb z vp pmos w='3.6u*k' l=.25u
MN a en z vn nmos w='1.8u*k' l=.25u
.ends tg
.subckt nand2 a0 a1 z vp vn k=1
MP0 z a0 vp vp pmos w='3.6u*k' l=.25u
MN0 z a0 n1 vn nmos w='3.6u*k' l=.25u
MP1 z a1 vp vp pmos w='3.6u*k' l=.25u
MN1 n1 a1 vn vn nmos w='3.6u*k' l=.25u
.ends nand2
.subckt nor2 a0 a1 z vp vn k=1
MN0 z a0 vn vn nmos w='1.8u*k' l=.25u
MP0 z a0 p1 vp pmos w='7.2u*k' l=.25u
MN1 z a1 vn vn nmos w='1.8u*k' l=.25u
MP1 p1 a1 vp vp pmos w='7.2u*k' l=.25u
.ends nor2
.subckt nand3 a0 a1 a2 z vp vn k=1
MP0 z a0 vp vp pmos w='3.6u*k' l=.25u
MN0 z a0 n1 vn nmos w='5.4u*k' l=.25u
MP1 z a1 vp vp pmos w='3.6u*k' l=.25u
MN1 n1 a1 n2 vn nmos w='5.4u*k' l=.25u
MP2 z a2 vp vp pmos w='3.6u*k' l=.25u
MN2 n2 a2 vn vn nmos w='5.4u*k' l=.25u
.ends nand3
.subckt nor3 a0 a1 a2 z vp vn k=1
MN0 z a0 vn vn nmos w='1.8u*k' l=.25u
MP0 z a0 p1 vp pmos w='10.8u*k' l=.25u
MN1 z a1 vn vn nmos w='1.8u*k' l=.25u
MP1 p1 a1 p2 vp pmos w='10.8u*k' l=.25u
MN2 z a2 vn vn nmos w='1.8u*k' l=.25u
MP2 p2 a2 vp vp pmos w='10.8u*k' l=.25u
.ends nor3
.subckt nand4 a0 a1 a2 a3 z vp vn k=1
MP0 z a0 vp vp pmos w='3.6u*k' l=.25u
MN0 z a0 n1 vn nmos w='7.2u*k' l=.25u
MP1 z a1 vp vp pmos w='3.6u*k' l=.25u
MN1 n1 a1 n2 vn nmos w='7.2u*k' l=.25u
MP2 z a2 vp vp pmos w='3.6u*k' l=.25u
MN2 n2 a2 n3 vn nmos w='7.2u*k' l=.25u
MP3 z a3 vp vp pmos w='3.6u*k' l=.25u
MN3 n3 a3 vn vn nmos w='7.2u*k' l=.25u
.ends nand4
.subckt nor4 a0 a1 a2 a3 z vp vn k=1
MN0 z a0 vn vn nmos w='1.8u*k' l=.25u
MP0 z a0 p1 vp pmos w='14.4u*k' l=.25u
MN1 z a1 vn vn nmos w='1.8u*k' l=.25u
MP1 p1 a1 p2 vp pmos w='14.4u*k' l=.25u
MN2 z a2 vn vn nmos w='1.8u*k' l=.25u
MP2 p2 a2 p3 vp pmos w='14.4u*k' l=.25u
MN3 z a3 vn vn nmos w='1.8u*k' l=.25u
MP3 p3 a3 vp vp pmos w='14.4u*k' l=.25u
.ends nor4
.subckt dff d clk cb q vp vn
X1 d m cb clk vp vn tg
X2 m mx vp vn inv
X3 mx mf vp vn inv
X4 mf m clk cb vp vn tg
X5 mx s clk cb vp vn tg
X6 s q vp vn inv
X7 q sf vp vn inv
X8 sf s cb clk vp vn tg
CQ q vn 10f
.ends dff
VDD vp 0 1
VCK clk 0 pulse(0 1 1n 20p 20p 1n 4n)
ECB cb 0 vol='1-v(clk)'
VD d 0 pwl(0 'initial' '1.01n-offset-10p' 'initial' '1.01n-offset+10p' 'final')
XFF d clk cb q vp 0 dff
.ic v(q)='initial' v(XFF.s)='1-initial' v(XFF.sf)='1-initial'

.tran 1p 3.5n 0 1p
.print tran v(d) v(clk) v(cb) v(q) v(XFF.mx) v(XFF.s)
.measure tran q_capture find v(q) at=1.8n
.measure tran q_held find v(q) at=3n
.measure tran data_offset param='offset'
.measure tran initial_level param='initial'
.measure tran final_level param='final'


.alter data_0_to_1_offset_m100
.temp 27
.param initial=0 final=1 offset=200p
.param initial=0 final=1 offset=-100p

.alter data_0_to_1_offset_m090
.temp 27
.param initial=0 final=1 offset=200p
.param initial=0 final=1 offset=-90p

.alter data_0_to_1_offset_m080
.temp 27
.param initial=0 final=1 offset=200p
.param initial=0 final=1 offset=-80p

.alter data_0_to_1_offset_m070
.temp 27
.param initial=0 final=1 offset=200p
.param initial=0 final=1 offset=-70p

.alter data_0_to_1_offset_m060
.temp 27
.param initial=0 final=1 offset=200p
.param initial=0 final=1 offset=-60p

.alter data_0_to_1_offset_m050
.temp 27
.param initial=0 final=1 offset=200p
.param initial=0 final=1 offset=-50p

.alter data_0_to_1_offset_m040
.temp 27
.param initial=0 final=1 offset=200p
.param initial=0 final=1 offset=-40p

.alter data_0_to_1_offset_m030
.temp 27
.param initial=0 final=1 offset=200p
.param initial=0 final=1 offset=-30p

.alter data_0_to_1_offset_m020
.temp 27
.param initial=0 final=1 offset=200p
.param initial=0 final=1 offset=-20p

.alter data_0_to_1_offset_m010
.temp 27
.param initial=0 final=1 offset=200p
.param initial=0 final=1 offset=-10p

.alter data_0_to_1_offset_p000
.temp 27
.param initial=0 final=1 offset=200p
.param initial=0 final=1 offset=0p

.alter data_0_to_1_offset_p010
.temp 27
.param initial=0 final=1 offset=200p
.param initial=0 final=1 offset=10p

.alter data_0_to_1_offset_p020
.temp 27
.param initial=0 final=1 offset=200p
.param initial=0 final=1 offset=20p

.alter data_0_to_1_offset_p030
.temp 27
.param initial=0 final=1 offset=200p
.param initial=0 final=1 offset=30p

.alter data_0_to_1_offset_p040
.temp 27
.param initial=0 final=1 offset=200p
.param initial=0 final=1 offset=40p

.alter data_0_to_1_offset_p050
.temp 27
.param initial=0 final=1 offset=200p
.param initial=0 final=1 offset=50p

.alter data_0_to_1_offset_p060
.temp 27
.param initial=0 final=1 offset=200p
.param initial=0 final=1 offset=60p

.alter data_0_to_1_offset_p070
.temp 27
.param initial=0 final=1 offset=200p
.param initial=0 final=1 offset=70p

.alter data_0_to_1_offset_p080
.temp 27
.param initial=0 final=1 offset=200p
.param initial=0 final=1 offset=80p

.alter data_0_to_1_offset_p090
.temp 27
.param initial=0 final=1 offset=200p
.param initial=0 final=1 offset=90p

.alter data_0_to_1_offset_p100
.temp 27
.param initial=0 final=1 offset=200p
.param initial=0 final=1 offset=100p

.alter data_0_to_1_offset_p110
.temp 27
.param initial=0 final=1 offset=200p
.param initial=0 final=1 offset=110p

.alter data_0_to_1_offset_p120
.temp 27
.param initial=0 final=1 offset=200p
.param initial=0 final=1 offset=120p

.alter data_0_to_1_offset_p130
.temp 27
.param initial=0 final=1 offset=200p
.param initial=0 final=1 offset=130p

.alter data_0_to_1_offset_p140
.temp 27
.param initial=0 final=1 offset=200p
.param initial=0 final=1 offset=140p

.alter data_0_to_1_offset_p150
.temp 27
.param initial=0 final=1 offset=200p
.param initial=0 final=1 offset=150p

.alter data_0_to_1_offset_p160
.temp 27
.param initial=0 final=1 offset=200p
.param initial=0 final=1 offset=160p

.alter data_0_to_1_offset_p170
.temp 27
.param initial=0 final=1 offset=200p
.param initial=0 final=1 offset=170p

.alter data_0_to_1_offset_p180
.temp 27
.param initial=0 final=1 offset=200p
.param initial=0 final=1 offset=180p

.alter data_0_to_1_offset_p190
.temp 27
.param initial=0 final=1 offset=200p
.param initial=0 final=1 offset=190p

.alter data_1_to_0_offset_m100
.temp 27
.param initial=0 final=1 offset=200p
.param initial=1 final=0 offset=-100p

.alter data_1_to_0_offset_m090
.temp 27
.param initial=0 final=1 offset=200p
.param initial=1 final=0 offset=-90p

.alter data_1_to_0_offset_m080
.temp 27
.param initial=0 final=1 offset=200p
.param initial=1 final=0 offset=-80p

.alter data_1_to_0_offset_m070
.temp 27
.param initial=0 final=1 offset=200p
.param initial=1 final=0 offset=-70p

.alter data_1_to_0_offset_m060
.temp 27
.param initial=0 final=1 offset=200p
.param initial=1 final=0 offset=-60p

.alter data_1_to_0_offset_m050
.temp 27
.param initial=0 final=1 offset=200p
.param initial=1 final=0 offset=-50p

.alter data_1_to_0_offset_m040
.temp 27
.param initial=0 final=1 offset=200p
.param initial=1 final=0 offset=-40p

.alter data_1_to_0_offset_m030
.temp 27
.param initial=0 final=1 offset=200p
.param initial=1 final=0 offset=-30p

.alter data_1_to_0_offset_m020
.temp 27
.param initial=0 final=1 offset=200p
.param initial=1 final=0 offset=-20p

.alter data_1_to_0_offset_m010
.temp 27
.param initial=0 final=1 offset=200p
.param initial=1 final=0 offset=-10p

.alter data_1_to_0_offset_p000
.temp 27
.param initial=0 final=1 offset=200p
.param initial=1 final=0 offset=0p

.alter data_1_to_0_offset_p010
.temp 27
.param initial=0 final=1 offset=200p
.param initial=1 final=0 offset=10p

.alter data_1_to_0_offset_p020
.temp 27
.param initial=0 final=1 offset=200p
.param initial=1 final=0 offset=20p

.alter data_1_to_0_offset_p030
.temp 27
.param initial=0 final=1 offset=200p
.param initial=1 final=0 offset=30p

.alter data_1_to_0_offset_p040
.temp 27
.param initial=0 final=1 offset=200p
.param initial=1 final=0 offset=40p

.alter data_1_to_0_offset_p050
.temp 27
.param initial=0 final=1 offset=200p
.param initial=1 final=0 offset=50p

.alter data_1_to_0_offset_p060
.temp 27
.param initial=0 final=1 offset=200p
.param initial=1 final=0 offset=60p

.alter data_1_to_0_offset_p070
.temp 27
.param initial=0 final=1 offset=200p
.param initial=1 final=0 offset=70p

.alter data_1_to_0_offset_p080
.temp 27
.param initial=0 final=1 offset=200p
.param initial=1 final=0 offset=80p

.alter data_1_to_0_offset_p090
.temp 27
.param initial=0 final=1 offset=200p
.param initial=1 final=0 offset=90p

.alter data_1_to_0_offset_p100
.temp 27
.param initial=0 final=1 offset=200p
.param initial=1 final=0 offset=100p

.alter data_1_to_0_offset_p110
.temp 27
.param initial=0 final=1 offset=200p
.param initial=1 final=0 offset=110p

.alter data_1_to_0_offset_p120
.temp 27
.param initial=0 final=1 offset=200p
.param initial=1 final=0 offset=120p

.alter data_1_to_0_offset_p130
.temp 27
.param initial=0 final=1 offset=200p
.param initial=1 final=0 offset=130p

.alter data_1_to_0_offset_p140
.temp 27
.param initial=0 final=1 offset=200p
.param initial=1 final=0 offset=140p

.alter data_1_to_0_offset_p150
.temp 27
.param initial=0 final=1 offset=200p
.param initial=1 final=0 offset=150p

.alter data_1_to_0_offset_p160
.temp 27
.param initial=0 final=1 offset=200p
.param initial=1 final=0 offset=160p

.alter data_1_to_0_offset_p170
.temp 27
.param initial=0 final=1 offset=200p
.param initial=1 final=0 offset=170p

.alter data_1_to_0_offset_p180
.temp 27
.param initial=0 final=1 offset=200p
.param initial=1 final=0 offset=180p

.alter data_1_to_0_offset_p190
.temp 27
.param initial=0 final=1 offset=200p
.param initial=1 final=0 offset=190p

.alter data_1_to_0_offset_p200
.temp 27
.param initial=0 final=1 offset=200p
.param initial=1 final=0 offset=200p

.end
