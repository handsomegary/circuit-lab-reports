MOS DC example - sectioned model library
* Template only: TT must match a real .LIB/.ENDL section in your library.
* Replace both the path and section name using the library documentation.
.lib '../models/corners.lib' TT
* Absolute-path alternative:
* .lib 'D:/models/corners.lib' TT
.option post=2
.temp 25
VGS gate 0 0.6
VDS drain 0 0
M1 drain gate 0 0 nmos W=0.6u L=0.25u
.dc VDS 0 1 0.01
.print dc V(drain) I(VDS)
.end
