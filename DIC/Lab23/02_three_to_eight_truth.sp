* DIC Lab 23: Three-to-eight exhaustive decoder
* Handout PDF pages 93. 1 V teaching adaptation.
* MODEL_SETUP_REQUIRED
.option post=2 runlvl=5 accurate ingold=2 numdgt=8 measdgt=8
.temp 27
* Three input complements, eight NAND3/inverter output gates: 70 MOS.
* Exhaustive eight-code DC truth table.

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
VDD vp 0 1
VA0 a0 0 'bit0'
VA1 a1 0 'bit1'
VA2 a2 0 'bit2'
.data truth bit0 bit1 bit2
0 0 0
1 0 0
0 1 0
1 1 0
0 0 1
1 0 1
0 1 1
1 1 1
.enddata
XI0 a0 b0 vp 0 inv
XI1 a1 b1 vp 0 inv
XI2 a2 b2 vp 0 inv
XA0n b0 b1 b2 A0b vp 0 nand3 k=1
XA0i A0b o0 vp 0 inv k=1
CL0 o0 0 10f
XA1n a0 b1 b2 A1b vp 0 nand3 k=1
XA1i A1b o1 vp 0 inv k=1
CL1 o1 0 10f
XA2n b0 a1 b2 A2b vp 0 nand3 k=1
XA2i A2b o2 vp 0 inv k=1
CL2 o2 0 10f
XA3n a0 a1 b2 A3b vp 0 nand3 k=1
XA3i A3b o3 vp 0 inv k=1
CL3 o3 0 10f
XA4n b0 b1 a2 A4b vp 0 nand3 k=1
XA4i A4b o4 vp 0 inv k=1
CL4 o4 0 10f
XA5n a0 b1 a2 A5b vp 0 nand3 k=1
XA5i A5b o5 vp 0 inv k=1
CL5 o5 0 10f
XA6n b0 a1 a2 A6b vp 0 nand3 k=1
XA6i A6b o6 vp 0 inv k=1
CL6 o6 0 10f
XA7n a0 a1 a2 A7b vp 0 nand3 k=1
XA7i A7b o7 vp 0 inv k=1
CL7 o7 0 10f

.dc data=truth
.print dc v(a0) v(a1) v(a2) v(o0) v(o1) v(o2) v(o3) v(o4)
+ v(o5) v(o6) v(o7)


.end
