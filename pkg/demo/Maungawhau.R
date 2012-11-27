library(Rgnuplot)

#Initialize the gnuplot handle
h1<-gp.init()

#set gnuplot's additional search directories, to the extdata directory from Rgnuplot (default)
gp.setloadpath(h1)

#if it doesn't exist, create a file with the volcano data
if (!file.exists('volcano.txt')) write.table(volcano, file = 'volcano.txt', quote = FALSE, row.names = FALSE, col.names =FALSE)

#change gnuplot's working directory to be the same as R's working directory (default)
gp.setwd(h1)

#3D wireframe
gp.cmd(h1,'#set terminal postscript eps color;set output "Maungawhau1.eps"
reset
set hidden3d
splot "volcano.txt" matrix w l' )
gp.pause()

#3D color surface
gp.cmd(h1,'#set terminal postscript eps color;set output "Maungawhau2.eps"
reset
set pm3d
splot "volcano.txt" matrix w pm3d' )
gp.pause()

#2D heatmap
gp.cmd(h1,'#set terminal postscript eps color;set output "Maungawhau3.eps"
reset
set pm3d map
splot "volcano.txt" matrix w pm3d' )
gp.pause()

#2D countour plot
gp.cmd(h1,'#set terminal png;set output "Maungawhau4.png"
reset
#unset clabel;
unset surface
set view map
set contour base
splot "volcano.txt" u 2:1:3 matrix w l notitle' )
gp.pause()

#3D wireframe + 2D heatmap
gp.cmd(h1,'#set terminal postscript eps color;set output "Maungawhau5.eps"
reset
set pm3d at b
splot "volcano.txt" matrix w l' )
gp.pause()

#3D color surface + 2D contour
gp.cmd(h1,'#set terminal postscript eps color;set output "Maungawhau6.eps"
reset
set contour base
set hidden3d
splot "volcano.txt" matrix w pm3d nocontour, "" matrix  w lines nosurface' )
gp.pause()

#3D surface + contour
gp.cmd(h1,'#set terminal postscript eps color;set output "Maungawhau7.eps"
reset
set contour surface
set hidden3d
splot "volcano.txt" matrix w pm3d notitle' )

#3D surface + black contour
tmpfile1<-tempfile()
tmpfile2<-tempfile()
gp.cmd(h1,'#set terminal postscript eps color;set output "Maungawhau8.eps"
reset
set contour base; set cntrparam level 5
unset surface
unset clabel
set table "' %s% tmpfile1 %s% '"
splot "volcano.txt" matrix w l lt -1
unset table
reset
!awk "NF<2{printf\"\\n\"}{print}" <' %s% tmpfile1 %s% ' >' %s% tmpfile2 %s% '
splot  "volcano.txt" matrix w pm3d nocontour,"' %s% tmpfile2 %s% '" w l lc rgb "black" nosurface' )
gp.pause()

#satellite image of Maunga Whau
library(RgoogleMaps)
#save the Google Maps tile
m<-GetMap(center=c(-36.875673,174.765036), zoom =16, destfile = "MaungawhauTile-16.png",maptype = "satellite")
#use GIMP to crop and rescale
gp.cmd(h1,'#set terminal postscript eps color;set output "Maungawhau9.eps"
reset
set size ratio -1
plot "Maungawhau2.png" binary filetype=png w rgbima notitle')
gp.pause()

# create a gnuplot data file with color and DEM
filePNG <- system.file('extdata/Maungawhau2.png',package='Rgnuplot')
fileDEMtab <-'volcano.txt'
file3Ddat <- 'Maungawhau2.dat' # color and DEM data file
gp.PNG4DEM(filePNG, fileDEMtab, file3Ddat)# create the data file

#3D DEM
gp.cmd(h1,'#set terminal png;set output "Maungawhau10.png"
reset
set view equal_axes xy
splot "Maungawhau2.dat" u 1:2:3:($4) w p pt 5 ps 1 lc rgb var notitle' )
gp.pause()

#3D DEM with palette
gp.cmd(h1,'#set terminal png;set output "Maungawhau11.png"
reset
set palette defined (0 "black",1 "dark-green", 2 "dark-olivegreen",3 "grey50", 4 "white")
set view equal_axes xy
unset colorbox
set hidden3d
splot "Maungawhau2.dat" u 1:2:3:($4) w pm3d notitle' )

gp.pause()

#close gnuplot handle
h1<-gp.close(h1)  
