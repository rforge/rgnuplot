
# saving a plot to a PNG file (from gnuplot_i examples) Initialize the gnuplot handle
h1 <- Gpinit()
# change gnuplot's working directory to be the same as R's working directory (default)
GpSetwd(h1)
GpCmd(h1, "set terminal png")
GpCmd(h1, "set output \"sine.png\"")
GpPlotEquation(h1, "sin(x)", "Sine wave")
# close gnuplot handles
g <- Gpclose(h1)
 
