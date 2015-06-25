require(Rgnuplot)
# Rgnuplot's 'Hello World!' - inline gnuplot Initialize the gnuplot handle
h1 <- GpInit()
# send gnuplot commands
GpCmd(h1, "set xlabel \"x\"\nset ylabel \"y\"\nset style \"line\"\nset title \"Hello World!\"\nplot sin(x)")
# pause R and gnuplot
GpPause()
# close gnuplot handle
h1 <- Gpclose(h1) 
