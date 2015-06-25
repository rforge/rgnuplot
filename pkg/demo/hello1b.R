require(Rgnuplot)
#'Hello World!' - text on caption
# Initialize the gnuplot handle
h1 <- GpInit()
# naming the axis
GpSetXlabel(h1, "x")
GpSetYlabel(h1, "y")
# set plot style to 'lines'
GpSetstyle(h1, "lines")
# add a caption
GpCmd(h1, "set title \"Hello World!\"")
# plot sin(x)
GpPlotEquation(h1, "sin(x)", "")
# pause R and gnuplot
GpPause()
# close gnuplot handle
h1 <- Gpclose(h1) 
