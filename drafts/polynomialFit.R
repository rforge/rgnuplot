library(Rgnuplot)
#polynomial curve fitting
#Using Gnuplot to sketch graphs
#Aaron Titus, 2012
#http://linus.highpoint.edu/~atitus/gnuplot/

plotPolyFit <- function(x, y, order){
  old <- setwd(tempdir())
                                        #write the data to a text file
  write(t(cbind(xpoints,ypoints)),'data.txt',ncolumns =2)
                                        #initial values of the parameters
  initvalues <- rep(1, order+1)
  coefs <- letters[seq_len(order+1)]
  write(t(cbind(coefs,'=',initvalues)),'guess.txt',
        ncolumns = 3, sep='')
        
  h1<-gp.init()
  gp.setwd(h1, getwd())

  xs <- c('x', paste('x', 2:order, sep='**'))
  equation <- paste(coefs[1],
                    paste(coefs[-1], xs, sep='*', collapse='+'),
                    sep='+')
  equation <- paste('y(x)', equation, sep='=')
  cmd <- paste(equation,
               'fit y(x) "data.txt" via "guess.txt"',
               'set xlabel "x"',
               'set ylabel "y"',
               'unset key',
               'plot y(x), "data.txt"',
               sep='\n')

  gp.cmd(h1, cmd)
  setwd(old)
  }
              
npoints <- 20 # number of points to plot
xpoints <- ( 0:npoints ) * 0.1 # x values
wpoints <- c(1,10^ -( 0:polnorder )) # "a" to "h" values
xPower <- outer(xpoints, 0:7, '^')
ypoints <- colSums(wpoints[1:8] * t(xPower))

plotPolyFit(xpoints, ypoints, 7)
