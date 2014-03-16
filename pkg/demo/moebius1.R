# world map on a moebius strip
gp.run('bind "p" "n=strftime(\'moebiusA%d.%b.%Y-%H.%M.%.3S.png\',time(0.0));set terminal png;set output n;replot;set terminal wxt"
set angles degrees
set parametric
set hidden
f(u,v) = cos(u) + v*cos(u/2.0) * cos(u)
g(u,v) = sin(u)+v*cos(u/2.0)*sin(u)
h(u,v) = .5*v*sin(u/2.0)
unset key;unset tics;unset border;unset colorbox
#set view equal xyz
set hidden3d
k=200.0
splot "NOAACoastline.dat" u (f(-$1,$2/k)):(g(-$1,$2/k)):(h(-$1,$2/k))  w l lc rgb "black" notit
',TRUE)
