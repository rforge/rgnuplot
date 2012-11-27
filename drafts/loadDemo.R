## Version with paste
plotDemo <- function(file, ...){
  code <- readLines(file)
  h1<-gp.init()
  gp.cmd(h1, paste(code, collapse='\n'))
  }

plotDemo('http://gnuplot.sourceforge.net/demo/transparent_solids.2.gnu')

## Version with lapply
plotDemo <- function(file, ...){
  code <- readLines(file)
  h1<-gp.init()
  lapply(code, FUN=function(x)gp.cmd(h1, x))
  }

plotDemo('http://gnuplot.sourceforge.net/demo/transparent_solids.2.gnu')
