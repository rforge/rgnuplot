# world map on a moebius strip
gp.run('bind "p" "n=strftime(\'moebiusB%d.%b.%Y-%H.%M.%.3S.png\',time(0.0));set terminal pngcairo;set output n;replot;set terminal wxt"
set angles degrees
set parametric
set isosamples 50
f(u,v) = cos(u) + v*cos(u/2.0) * cos(u)
g(u,v) = sin(u)+v*cos(u/2.0)*sin(u)
h(u,v) = .5*v*sin(u/2.0)
unset key;unset tics;unset border;unset colorbox
set palette model RGB file "earth_day.pal" u ($1/255):($2/255):($3/255)
set pm3d corners2color c1
#set view equal xyz
set hidden3d
k=200.0
splot "earth_day_moebiusXYcoords.dat" u (f(-$1,$2/k)):(g(-$1,$2/k)):(h(-$1,$2/k)):3  w pm3d notit
',TRUE)
