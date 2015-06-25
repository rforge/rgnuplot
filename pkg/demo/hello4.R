require(Rgnuplot)
#'Hello World!' - loading a script directly from gnuplot
# Initialize the gnuplot handle
h1 <- GpInit()
# set gnuplot's additional search directories, to the extdata directory from Rgnuplot (default)
GpSetloadpath(h1)
# load the script
GpCmd(h1, "load \"helloworld.gnu\"")
# pause R and gnuplot
GpPause()
# close gnuplot handle
h1 <- Gpclose(h1) 
