DIC Lab 8: 02_noise_cascade
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
VIN in 0 PWL(0n 0 1n 0 1.1n 0.2 2n 0.2 2.1n 0 3n 0 3.1n 0.4 4n 0.4 4.1n 0 5n 0 5.1n 0.48 6n 0.48 6.1n 0 7n 0 7.1n 0.6 8n 0.6 8.1n 0 9n 0 9.1n 1 10n 1 10.1n 0.8 11n 0.8 11.1n 1 12n 1 12.1n 0.6 13n 0.6 13.1n 1 14n 1 14.1n 0.52 15n 0.52 15.1n 1 16n 1 16.1n 0.4 17n 0.4 17.1n 1 18n 1)
X0 in y0 vdd 0 INV wp=0.45u
XBUF0 y0 z0 vdd 0 INV wp=0.45u
X1 in y1 vdd 0 INV wp=1.8u
XBUF1 y1 z1 vdd 0 INV wp=1.8u
X2 in y2 vdd 0 INV wp=7.2u
XBUF2 y2 z2 vdd 0 INV wp=7.2u
.tran 2p 18n
.print tran V(in) V(y0) V(y1) V(y2)
.print tran V(z0) V(z1) V(z2)
.measure tran y0_noise0 AVG V(y0) FROM=1.2n TO=1.9n
.measure tran z0_noise0 AVG V(z0) FROM=1.2n TO=1.9n
.measure tran y0_noise1 AVG V(y0) FROM=3.2n TO=3.9n
.measure tran z0_noise1 AVG V(z0) FROM=3.2n TO=3.9n
.measure tran y0_noise2 AVG V(y0) FROM=5.2n TO=5.9n
.measure tran z0_noise2 AVG V(z0) FROM=5.2n TO=5.9n
.measure tran y0_noise3 AVG V(y0) FROM=7.2n TO=7.9n
.measure tran z0_noise3 AVG V(z0) FROM=7.2n TO=7.9n
.measure tran y0_noise4 AVG V(y0) FROM=10.2n TO=10.9n
.measure tran z0_noise4 AVG V(z0) FROM=10.2n TO=10.9n
.measure tran y0_noise5 AVG V(y0) FROM=12.2n TO=12.9n
.measure tran z0_noise5 AVG V(z0) FROM=12.2n TO=12.9n
.measure tran y0_noise6 AVG V(y0) FROM=14.2n TO=14.9n
.measure tran z0_noise6 AVG V(z0) FROM=14.2n TO=14.9n
.measure tran y0_noise7 AVG V(y0) FROM=16.2n TO=16.9n
.measure tran z0_noise7 AVG V(z0) FROM=16.2n TO=16.9n
.measure tran y1_noise0 AVG V(y1) FROM=1.2n TO=1.9n
.measure tran z1_noise0 AVG V(z1) FROM=1.2n TO=1.9n
.measure tran y1_noise1 AVG V(y1) FROM=3.2n TO=3.9n
.measure tran z1_noise1 AVG V(z1) FROM=3.2n TO=3.9n
.measure tran y1_noise2 AVG V(y1) FROM=5.2n TO=5.9n
.measure tran z1_noise2 AVG V(z1) FROM=5.2n TO=5.9n
.measure tran y1_noise3 AVG V(y1) FROM=7.2n TO=7.9n
.measure tran z1_noise3 AVG V(z1) FROM=7.2n TO=7.9n
.measure tran y1_noise4 AVG V(y1) FROM=10.2n TO=10.9n
.measure tran z1_noise4 AVG V(z1) FROM=10.2n TO=10.9n
.measure tran y1_noise5 AVG V(y1) FROM=12.2n TO=12.9n
.measure tran z1_noise5 AVG V(z1) FROM=12.2n TO=12.9n
.measure tran y1_noise6 AVG V(y1) FROM=14.2n TO=14.9n
.measure tran z1_noise6 AVG V(z1) FROM=14.2n TO=14.9n
.measure tran y1_noise7 AVG V(y1) FROM=16.2n TO=16.9n
.measure tran z1_noise7 AVG V(z1) FROM=16.2n TO=16.9n
.measure tran y2_noise0 AVG V(y2) FROM=1.2n TO=1.9n
.measure tran z2_noise0 AVG V(z2) FROM=1.2n TO=1.9n
.measure tran y2_noise1 AVG V(y2) FROM=3.2n TO=3.9n
.measure tran z2_noise1 AVG V(z2) FROM=3.2n TO=3.9n
.measure tran y2_noise2 AVG V(y2) FROM=5.2n TO=5.9n
.measure tran z2_noise2 AVG V(z2) FROM=5.2n TO=5.9n
.measure tran y2_noise3 AVG V(y2) FROM=7.2n TO=7.9n
.measure tran z2_noise3 AVG V(z2) FROM=7.2n TO=7.9n
.measure tran y2_noise4 AVG V(y2) FROM=10.2n TO=10.9n
.measure tran z2_noise4 AVG V(z2) FROM=10.2n TO=10.9n
.measure tran y2_noise5 AVG V(y2) FROM=12.2n TO=12.9n
.measure tran z2_noise5 AVG V(z2) FROM=12.2n TO=12.9n
.measure tran y2_noise6 AVG V(y2) FROM=14.2n TO=14.9n
.measure tran z2_noise6 AVG V(z2) FROM=14.2n TO=14.9n
.measure tran y2_noise7 AVG V(y2) FROM=16.2n TO=16.9n
.measure tran z2_noise7 AVG V(z2) FROM=16.2n TO=16.9n

.end
