
# Initialize the gnuplot handle
h1 <- Gpinit()

# set gnuplot's additional search directories, to the extdata directory from Rgnuplot (default)
GpSetloadpath(h1)

# change gnuplot's working directory to be the same as R's working directory (default)
GpSetwd(h1)
# filename for a temporary path+file
tmpfile <- tempfile()

GpGetloadpath(h1)
GpGetwd(h1)
getwd()
z <- matrix(sample(1:6, 6^2, replace = TRUE), 6, 6, byrow = FALSE)
z
GpMatrixr2gnu(z, "6x6.dat")

GpCmd(h1, "reset\nmin = 0\ncol = 5\ngridflag = 0\ndatfile = \"6x6.dat\"\ntmpfile = \"" %s% tmpfile %s% "\"\nload \"fenceplot.gnu\"")  #

# pause R and gnuplot
GpPause()

tmpfile <- tempfile()
GpCmd(h1, "reset\nmin = 0\ncol = 5\ngridflag = 1\ndatfile = \"6x6.dat\"\ntmpfile = \"" %s% tmpfile %s% "\"\nload \"fenceplot.gnu\"")

# pause R and gnuplot
GpPause()

# close gnuplot handle
h1 <- Gpclose(h1) 
