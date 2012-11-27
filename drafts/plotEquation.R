plotFunction <- function(expr, xlab='x', ylab='y', main='', type='l',...){

  h1<-gp.init()

  gp.set.xlabel(h1, xlab)
  gp.set.ylabel(h1, ylab)

  style <- switch(type,
                  l = 'lines',
                  p = 'points'
                  )
  gp.setstyle(h1, style)

  gp.plot.equation(h1, as.character(expr), main)
  
  gp.pause()
  h1<-gp.close(h1)
}
