splot <- function(x, type = c('hidden3d', 'pm3d', 'map', 'contour')){
  
  h1<-gp.init()

  old <- setwd(tempdir())

  gp.setwd(h1)
  write.table(x, file='data.txt', quote = FALSE, row.names = FALSE, col.names = FALSE)

  type <- match.arg(type)

  setCMD <- switch(type,
                   hidden3d = 'set hidden3d',
                   pm3d = 'set pm3d',
                   map = 'set pm3d map',
                   contour = paste('unset surface',
                     'set view map',
                     'set contour base', sep='\n')
                   )
  
  plotCMD <- switch(type,
                    hidden3d = 'splot "data.txt" matrix w l',
                    pm3d = 'splot "data.txt" matrix w pm3d',
                    map = 'splot "data.txt" matrix w pm3d',
                    contour = 'splot "data.txt" u 2:1:3 matrix w l notitle')

  cmd <- paste('reset', setCMD, 'unset key', plotCMD, sep = '\n')
  gp.cmd(h1, cmd)

  setwd(old)
}
  
splot(volcano)
splot(volcano, 'pm3d')
splot(volcano, 'map')
splot(volcano, 'contour')
