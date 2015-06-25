require(Rgnuplot)
# 'Hello World!' - using GpPlotEquation
h1 <- GpInit()  #Initialize the gnuplot handle
GpPlotEquation(h1, "sin( x )", "Hello World!")
GpPause()  # pause R and gnuplot
h1 <- Gpclose(h1)  # close gnuplot handles 
