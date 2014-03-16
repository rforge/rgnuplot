# loxodrome tests
gp.run('set dummy u,v
set angles degrees
set parametric
set urange [ -90.0000*15 : 90.0000*15 ] noreverse nowriteback
set vrange [ 0.00000 : 360.000 ] noreverse nowriteback
set view equal xyz
set nokey
myAngle=120.0
cosc(x)=cos(atan(x/myAngle))
sinc(x)=sin(atan(x/myAngle))
splot cos(u)*cos(v),cos(u)*sin(v),sin(u) notitle w l lt 5, cos(u)*cosc(u),sin(u)*cosc(u),-sinc(u) w l lc rgb "red" notit

',TRUE)

