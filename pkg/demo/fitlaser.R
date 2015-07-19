
# create gnuplot handle
h1 <- Gpinit()
# set gnuplot's additional search directories, to the extdata directory from Rgnuplot (default)
GpSetloadpath(h1)
# change gnuplot's working directory to be the same as R's working directory (default)
GpSetwd(h1)
# load the gnuplot script GpCmd(h1, 'set terminal png;set output 'errorbar3.png';load 'fitlaser.gnu'')
GpCmd(h1, "load \"fitlaser.gnu\"")
# pause R and gnuplot
GpPause()
# close gnuplot handle
h1 <- Gpclose(h1) 
