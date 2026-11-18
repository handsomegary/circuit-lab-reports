DIC Lab 14: 02_noise_immunity
* Specification-based teaching adaptation; 1 V is a simulation condition, not a model rating.
* MODEL_SETUP_REQUIRED
.option post=2 nomod runlvl=6 measdgt=10 numdgt=10 ingold=2
.temp 25
.param VS=1
VDD vdd 0 'VS'
.subckt INV a y vp vn wn=0.6u wp=1.8u ll=0.25u
MN y a vn vn nmos W=wn L=ll
MP y a vp vp pmos W=wp L=ll
.ends INV
.subckt SCH a y vp vn f=1
MP1 p a vp vp pmos W=3.6u L=0.25u
MP2 y a p vp pmos W=3.6u L=0.25u
MN1 n a vn vn nmos W=1.2u L=0.25u
MN2 y a n vn nmos W=1.2u L=0.25u
MP3 vn y p vp pmos W='1.8u*f' L=0.25u
MN3 vp y n vn nmos W='0.6u*f' L=0.25u
.ends SCH
* Alternative: a strong input inverter drives a weak cross-coupled inverter pair.
.subckt ALT a y vp vn
XIN a y vp vn INV wn=1.2u wp=3.6u
XFB q y vp vn INV wn=0.6u wp=1.8u
XSENSE y q vp vn INV wn=0.6u wp=1.8u
.ends ALT
XINV in yi vdd 0 INV
XS1 in ys1 vdd 0 SCH f=1
XS2 in ys2 vdd 0 SCH f=2
XS3 in ys3 vdd 0 SCH f=3
XALT in ya vdd 0 ALT
VIN in 0 PWL(0n 0 1n 0 1.1n 0.2 2n 0.2 2.1n 0 3n 0 3.1n 0.4 4n 0.4 4.1n 0 5n 0 5.1n 0.48 6n 0.48 6.1n 0 7n 0 7.1n 0.6 8n 0.6 8.1n 0 9n 0 9.1n 1 10n 1 10.1n 0.8 11n 0.8 11.1n 1 12n 1 12.1n 0.6 13n 0.6 13.1n 1 14n 1 14.1n 0.52 15n 0.52 15.1n 1 16n 1 16.1n 0.4 17n 0.4 17.1n 1 18n 1)
.tran 2p 18n
.print tran V(in) V(yi) V(ys1) V(ys2) V(ys3) V(ya)
.measure tran yi_noise0 AVG V(yi) FROM=1.2n TO=1.9n
.measure tran yi_noise1 AVG V(yi) FROM=3.2n TO=3.9n
.measure tran yi_noise2 AVG V(yi) FROM=5.2n TO=5.9n
.measure tran yi_noise3 AVG V(yi) FROM=7.2n TO=7.9n
.measure tran yi_noise4 AVG V(yi) FROM=10.2n TO=10.9n
.measure tran yi_noise5 AVG V(yi) FROM=12.2n TO=12.9n
.measure tran yi_noise6 AVG V(yi) FROM=14.2n TO=14.9n
.measure tran yi_noise7 AVG V(yi) FROM=16.2n TO=16.9n
.measure tran ys1_noise0 AVG V(ys1) FROM=1.2n TO=1.9n
.measure tran ys1_noise1 AVG V(ys1) FROM=3.2n TO=3.9n
.measure tran ys1_noise2 AVG V(ys1) FROM=5.2n TO=5.9n
.measure tran ys1_noise3 AVG V(ys1) FROM=7.2n TO=7.9n
.measure tran ys1_noise4 AVG V(ys1) FROM=10.2n TO=10.9n
.measure tran ys1_noise5 AVG V(ys1) FROM=12.2n TO=12.9n
.measure tran ys1_noise6 AVG V(ys1) FROM=14.2n TO=14.9n
.measure tran ys1_noise7 AVG V(ys1) FROM=16.2n TO=16.9n
.measure tran ys2_noise0 AVG V(ys2) FROM=1.2n TO=1.9n
.measure tran ys2_noise1 AVG V(ys2) FROM=3.2n TO=3.9n
.measure tran ys2_noise2 AVG V(ys2) FROM=5.2n TO=5.9n
.measure tran ys2_noise3 AVG V(ys2) FROM=7.2n TO=7.9n
.measure tran ys2_noise4 AVG V(ys2) FROM=10.2n TO=10.9n
.measure tran ys2_noise5 AVG V(ys2) FROM=12.2n TO=12.9n
.measure tran ys2_noise6 AVG V(ys2) FROM=14.2n TO=14.9n
.measure tran ys2_noise7 AVG V(ys2) FROM=16.2n TO=16.9n
.measure tran ys3_noise0 AVG V(ys3) FROM=1.2n TO=1.9n
.measure tran ys3_noise1 AVG V(ys3) FROM=3.2n TO=3.9n
.measure tran ys3_noise2 AVG V(ys3) FROM=5.2n TO=5.9n
.measure tran ys3_noise3 AVG V(ys3) FROM=7.2n TO=7.9n
.measure tran ys3_noise4 AVG V(ys3) FROM=10.2n TO=10.9n
.measure tran ys3_noise5 AVG V(ys3) FROM=12.2n TO=12.9n
.measure tran ys3_noise6 AVG V(ys3) FROM=14.2n TO=14.9n
.measure tran ys3_noise7 AVG V(ys3) FROM=16.2n TO=16.9n
.measure tran ya_noise0 AVG V(ya) FROM=1.2n TO=1.9n
.measure tran ya_noise1 AVG V(ya) FROM=3.2n TO=3.9n
.measure tran ya_noise2 AVG V(ya) FROM=5.2n TO=5.9n
.measure tran ya_noise3 AVG V(ya) FROM=7.2n TO=7.9n
.measure tran ya_noise4 AVG V(ya) FROM=10.2n TO=10.9n
.measure tran ya_noise5 AVG V(ya) FROM=12.2n TO=12.9n
.measure tran ya_noise6 AVG V(ya) FROM=14.2n TO=14.9n
.measure tran ya_noise7 AVG V(ya) FROM=16.2n TO=16.9n

.end
