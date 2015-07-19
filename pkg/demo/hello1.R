
#'Hello World!' - text on legend
# Initialize the gnuplot handle
h1 <- Gpinit()
# set output to a postscript file GpCmd(h1,'set terminal postscript eps color;set output 'helloworld1.eps'') label the x and y axis
GpSetXlabel(h1, "x")
GpSetYlabel(h1, "y")
# set plot style to 'lines'
GpSetstyle(h1, "lines")
# plot sin(x) and add a legend
GpPlotEquation(h1, "sin(x)", "Hello World!")
# pause R and gnuplot
GpPause()
# close gnuplot handle
h1 <- Gpclose(h1) 
