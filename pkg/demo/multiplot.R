
# Plot implicit, explicit and parametric equations Initialize the gnuplot handle
h1 <- Gpinit()
# set gnuplot's additional search directories, to the extdata directory from Rgnuplot (default)
GpSetloadpath(h1)
# change gnuplot's working directory to be the same as R's working directory (default)
GpSetwd(h1)
# filename for a temporary path+file
tmpfile <- tempfile()
tmpfile2 <- tempfile()
tmpfile3 <- tempfile()
# define the circle's radius
radius <- 5
# load the multiplot script, key_flag zero => legend
GpCmd(h1, "radius=" %s% radius %s% ";key_flag=0; tmpfile=\"" %s% tmpfile %s% "\"; load \"multiplot.gnu\"")
GpPause()  #pause R and gnuplot
# load the multiplot script, key_flag one => labels
GpCmd(h1, "radius=" %s% radius %s% ";key_flag=1; tmpfile=\"" %s% tmpfile2 %s% "\"; load \"multiplot.gnu\"")
GpPause()  #pause R and gnuplot
# load the multiplot script, key_flag !={1, 3} => no labels and no legend
GpCmd(h1, "radius=" %s% radius %s% ";key_flag=2; tmpfile=\"" %s% tmpfile3 %s% "\"; load \"multiplot.gnu\"")
GpPause()  #pause R and gnuplot
# close gnuplot handle
h1 <- Gpclose(h1) 
