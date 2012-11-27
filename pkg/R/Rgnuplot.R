#	*	*	*			Package "Rgnuplot"		*	*	*

X11.present <- NA

"%s%" <- function(x,y) paste(x,y,sep='', collapse='') # string concatenation operator

gp.plotFunction <- function(x, xlab='x', ylab='y', main='', type='l',...){

if (!is.character(x)) stop('Argument <<x>> should be a string')
if (!is.character(xlab)) stop('Argument <<xlab>> should be a string')
if (!is.character(ylab)) stop('Argument <<ylab>> should be a string')
if (!is.character(main)) stop('Argument <<main>> should be a string')
if (!is.character(type)) stop('Argument <<type>> should be a string')

  h1<-gp.init()

  gp.set.xlabel(h1, xlab)
  gp.set.ylabel(h1, ylab)

  style <- switch(type,
                  l = 'lines',
                  p = 'points'
                  )
  gp.setstyle(h1, style)

  gp.plot.equation(h1, as.character(x), main)
  
  gp.pause()
  h1<-gp.close(h1)
}

gp.splot <- function(x, type = c('hidden3d', 'pm3d', 'map', 'contour')){
  
if (!is.numeric(x)) stop('Argument <<x>> should be numeric')
if (!is.numeric(x)) stop('Argument <<x>> should be numeric')

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

gp.plotPolyFit <- function(x, y, order){

if (!is.numeric(x)) stop('Argument <<x>> should be numeric')
if (!is.numeric(y)) stop('Argument <<y>> should be numeric')
if (!is.numeric(order)) stop('Argument <<order>> should be numeric')

  old <- setwd(tempdir())
                                        #write the data to a text file
  write(t(cbind(x,y)),'data.txt',ncolumns =2)
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








gp.mandel <- function(x,y,z,n,maxiterations)
{#recursive implementation of the Mandelbrot set function

if (!is.numeric(x)) stop('Argument <<x>> should be numeric')
if (!is.numeric(y)) stop('Argument <<y>> should be numeric')
if (!is.numeric(z)) stop('Argument <<z>> should be numeric')
if (!is.numeric(n)) stop('Argument <<n>> should be numeric')
if (!is.numeric(maxiterations)) stop('Argument <<maxiterations>> should be numeric')

retmandel <- 0
ret <- .C("Rgnuplot_mandel",as.numeric(x),as.numeric(y),as.numeric(z),as.integer(n),as.integer(maxiterations),retmandel=as.integer(retmandel),DUP = TRUE,PACKAGE="Rgnuplot" )
ret$retmandel
}

gp.cols2rows <- function(filename,newfile,filecolseparator=' ',fileheader = FALSE,newfilerowseparator='\n\n')
{#convert a file with columns yyyy,m1,m2,m3,...,m12 to rows yyyy,m1 yyyy,m3 ... yyyy,m12 readable by gnuplot

if (!is.character(filename)) stop('Argument <<filename>> should be a string')
if (!is.character(newfile)) stop('Argument <<newfile>> should be a string')
if (!is.character(filecolseparator)) stop('Argument <<filecolseparator>> should be a string')
if (!is.logical(fileheader)) stop('Argument <<fileheader>> should be a boolean')
if (!is.character(newfilerowseparator)) stop('Argument <<newfilerowseparator>> should be a string')

# read table data, TAB separated
RTable<-read.table(filename, header = fileheader, sep = filecolseparator)
# store the number of rows and columns
iNrows<-dim(RTable)[1]
iNcols<-dim(RTable)[2]
# sort the repeated year values
yearvalues<-sort(rep(RTable[,1],iNcols-1))
# month values are needed for each year
month12<-rep(1:12,iNrows)
# convert to vector, by columns
Mdata<-c(t(as.matrix(RTable[-1])))
#create a matrix with the new data
newdata<-cbind(month12,yearvalues,Mdata)
newdata2<-newdata[order(month12),]
# save the new data
for (m in unique(newdata[,1]))
{
write.table(newdata2[which(newdata2[,1]==m),], file = newfile, sep = filecolseparator,row.names =FALSE, col.names =FALSE, quote =FALSE,append=TRUE)
z <- file(newfile, "at")
writeLines(newfilerowseparator,z, sep='')
close(z)
}
}

gp.R2plot <- function(Rfunction,filename,gnuxrange,gnuyrange,gnusamples)
{#saves the output from a 2D R function to a file readable by gnuplot
if (!is.function(Rfunction)) stop('Argument <<Rfunction>> should be a function')
if (!is.character(filename)) stop('Argument <<filename>> should be a string')
if (!is.numeric(gnuxrange)) stop('Argument <<gnuxrange>> should be numeric')
if (!is.numeric(gnuyrange)) stop('Argument <<gnuyrange>> should be numeric')
if (!is.numeric(gnusamples)) stop('Argument <<gnusamples>> should be numeric')
col1 <- seq(from = gnuxrange[1], to = gnuxrange[2], length.out = gnusamples[1])
col2 <- Rfunction(col1)
col3 <- rep('i',times =length(col1))
col3[which((col2<gnuyrange[1]) | (col2>gnuyrange[2])) ] <- 'o'
rmatrix<-cbind(col1,col2,col3)
write(t(rmatrix),filename,ncolumns = 3)
}

gp.R2splot <- function(Rfunction,filename,gnuxrange,gnuyrange,gnusamples,gnuisosamples,hidden3d=FALSE)
{#saves the output from a 3D R function to a file readable by gnuplot
if (!is.function(Rfunction)) stop('Argument <<Rfunction>> should be a function')
if (!is.character(filename)) stop('Argument <<filename>> should be a string')
if (!is.numeric(gnuxrange)) stop('Argument <<gnuxrange>> should be numeric')
if (!is.numeric(gnuyrange)) stop('Argument <<gnuyrange>> should be numeric')
if (!is.numeric(gnuisosamples)) stop('Argument <<gnuisosamples>> should be numeric')
if (!is.numeric(gnusamples)) stop('Argument <<gnusamples>> should be numeric')
if (length(gnuisosamples)==1) gnuisosamples <- c(gnuisosamples, gnuisosamples)
if (length(gnusamples)==1) gnusamples <- c(gnusamples, gnusamples)
if (hidden3d) filerows <- gnuisosamples[1] else filerows <- gnusamples[1]
col1 <- rep(seq(from = gnuxrange[1], to = gnuxrange[2], length.out = filerows),times=gnuisosamples[2])
col2 <- rep(seq(from = gnuyrange[1], to = gnuyrange[2], length.out = gnuisosamples[2]),each=filerows)
col3 <- vector(mode = "numeric", length =length(col1))
for (coloop in 1:length(col1)) col3[coloop] <- Rfunction(col1[coloop],col2[coloop])
col4 <- rep('i',times =length(col1))
col4[which((col2<gnuyrange[1]) | (col2>gnuyrange[2])) ] <- 'o'
rmatrix <- cbind(col1,col2,col3,col4)
n<-dim(rmatrix)[1]
for (eoloop in 1:(n / filerows-1)) rmatrix<-rbind(rmatrix[1:(eoloop*filerows+eoloop-1),],c('','',''),rmatrix[-1:-(eoloop*filerows+eoloop-1),])
write(t(rmatrix),filename,ncolumns = 4)
}

gp.h <- function(handle, gnustring)
{#shows the output from gnuplot's help command
gp.CheckHandle(handle)
if (!is.character(gnustring)) stop('Argument <<gnustring>> should be a string')
logfile <-tempfile()
gp.cmd(handle, 'set print "' %s% logfile %s% '";?set samples;set print')
gp.file2string(logfile)
}

gp.PNG2RGB<-function(PNGfile, RGBfile,forceRGB=FALSE)
{# converts a PNG file to an RGB or RGBA file
#if forceRGB is TRUE then the alpha channel is ignored
library('png', character.only=TRUE) #
if (!is.character(PNGfile)) stop('Argument <<PNGfile>> should be a string')
if (!is.character(RGBfile)) stop('Argument <<RGBfile>> should be a string')
if (!is.logical(forceRGB)) stop('Argument <<forceRGB>> should be logical')
if (!file.exists(PNGfile)) stop('Error! File ' %s% PNGfile %s% ' does not exist' )
p<-readPNG(PNGfile)
p<-p*255
numrows<-dim(p)[1]
numcols<-dim(p)[2]
cat(dim(p)[3])
to.write = file(RGBfile, "wb")
if (forceRGB) rgbsize <- 3 else rgbsize <- 4
for (m in 1:numrows)
for (n in 1:numcols)
{
temp <- as.vector(as.integer(p[m,n,1:rgbsize]), mode = 'raw')
  writeBin(temp, to.write)
}
close( to.write )
}

gp.RGB2PNG<-function(RGBfile, PNGfile,width,height)
{#converts an RGB file to a PNG file
library('png', character.only=TRUE)
if (!is.character(RGBfile)) stop('Argument <<RGBfile>> should be a string')
if (!is.character(PNGfile)) stop('Argument <<PNGfile>> should be a string')
if (!is.numeric(width)) stop('Argument <<width>> should be integer')
if (!is.numeric(height)) stop('Argument <<height>> should be integer')
if (!file.exists(RGBfile)) stop('Error! File ' %s% RGBfile %s% ' does not exist' )
RGBsize <- file.info(RGBfile)$size
to.read = file(RGBfile, "rb")
RGBbin <- readBin(to.read, raw(), n = RGBsize, size = 1)
close(to.read)
matRGB <- array(0,c(width,height,3))
matRGB[,,1] <- matrix(as.integer(RGBbin[(1:(RGBsize/3))*3-2]),width,height,byrow=TRUE)
matRGB[,,2] <- matrix(as.integer(RGBbin[(1:(RGBsize/3))*3-1]),width,height,byrow=TRUE)
matRGB[,,3] <- matrix(as.integer(RGBbin[(1:(RGBsize/3))*3]),width,height,byrow=TRUE)
writePNG(matRGB/255.0, target = PNGfile)
}

gp.matrixr2gnu <- function(rmatrix, gnufile)
{#saves an R matrix in a format that can be read by gnuplot
if (!is.matrix(rmatrix)) stop('Argument <<rmatrix>> should be a matrix')
if (!is.character(gnufile)) stop('Argument <<gnufile>> should be a string')
Ncol <- dim(rmatrix)[2]
write(t(rmatrix),gnufile,ncolumns = Ncol)
}

gp.fit.progress <- function( fitprogressfile, fitparameter)
{#returns the value of a parameter from a logged stderr fit file
if (!is.character(fitprogressfile)) stop('Argument <<fitprogressfile>> should be a string')
if (!is.character(fitparameter)) stop('Argument <<fitparameter>> should be a string')
if (!file.exists(fitprogressfile)) stop('File ' %s% fitprogressfile %s% ' does not exist')
fitprogress <- gp.file2string(fitprogressfile)
r <- regexpr('initial set of free parameter values[^\\/]+', fitprogress, perl=TRUE, useBytes = FALSE)
params <- substr(fitprogress,r[1],r[1]+attr(r,"match.length"))
params <- gsub('\\s*=.*?\n','\n', params)
params <- unlist(strsplit(params, '\n'))
params <- params[-c(1,2,length(params))]
if (!(fitparameter %in% c('WSSR','deltaWSSR','lambda',params))) stop('Parameter ' %s% fitparameter %s% ' does not exist')
if (fitparameter %in% params) grx <- gregexpr('\\s' %s% fitparameter %s% '\\s*\\=\\s*([0-9\\.\\-\\+e]+)',fitprogress, perl=TRUE) else {
if ( fitparameter == 'WSSR' ) grx <- gregexpr('\\sWSSR\\s*\\:\\s*([0-9\\.\\-\\+e]+)',fitprogress, perl=TRUE)
if ( fitparameter == 'deltaWSSR' ) grx <- gregexpr('delta\\(WSSR\\)\\s*\\:\\s*([0-9\\.\\-\\+e]+)',fitprogress, perl=TRUE)
if ( fitparameter == 'lambda' ) grx <- gregexpr('lambda\\s*\\:\\s*([0-9\\.\\-\\+e]+)',fitprogress, perl=TRUE)
}
x<-''
for (a in 1:length(grx[[1]])) x<-x %s%
substr(fitprogress,attr(grx[[1]],"capture.start")[a],attr(grx[[1]],"capture.start")[a]+attr(grx[[1]],"capture.length")[a])
x<-gsub('\\s+','\n',x)
z<-unlist(strsplit(x,'\n'))
z<-as.numeric(z)
r <- regexpr('After (\\d+) iterations the fit converged', fitprogress, perl=TRUE, useBytes = FALSE)
niterations <- substr(fitprogress,attr(r,"capture.start"),attr(r,"capture.start")+attr(r,"capture.length"))
niterations <- as.numeric(niterations)+1
z[1:niterations]
}

gp.fit.allprogress <- function( fitprogressfile, boolScreenOut = TRUE)
{#returns the value of all parameters from a logged stderr fit file
if (!is.character(fitprogressfile)) stop('Argument <<fitprogressfile>> should be a string')
if (!is.logical(boolScreenOut)) stop('Argument <<boolScreenOut>> should be logical')
if (!file.exists(fitprogressfile)) stop('File ' %s% fitprogressfile %s% ' does not exist')
fitprogress <- gp.file2string(fitprogressfile)
r <- regexpr('initial set of free parameter values[^\\/]+', fitprogress, perl=TRUE, useBytes = FALSE)
params <- substr(fitprogress,r[1],r[1]+attr(r,"match.length"))
params <- gsub('\\s*=.*?\n','\n', params)
params <- unlist(strsplit(params, '\n'))
params <- params[-c(1,2,length(params))]
r <- regexpr('After (\\d+) iterations the fit converged', fitprogress, perl=TRUE, useBytes = FALSE)
niterations <- substr(fitprogress,attr(r,"capture.start"),attr(r,"capture.start")+attr(r,"capture.length"))
niterations <- as.numeric(niterations)+1
matrixresult <- matrix( 0, nrow = niterations, ncol = 3 + length( params ) )
paramloop <- 1
for (fitparameter in c('WSSR','deltaWSSR','lambda',params))
{
if (fitparameter %in% params) grx <- gregexpr('\\s' %s% fitparameter %s% '\\s*\\=\\s*([0-9\\.\\-\\+e]+)',fitprogress, perl=TRUE) else {
if ( fitparameter == 'WSSR' ) grx <- gregexpr('\\sWSSR\\s*\\:\\s*([0-9\\.\\-\\+e]+)',fitprogress, perl=TRUE)
if ( fitparameter == 'deltaWSSR' ) grx <- gregexpr('delta\\(WSSR\\)\\s*\\:\\s*([0-9\\.\\-\\+e]+)',fitprogress, perl=TRUE)
if ( fitparameter == 'lambda' ) grx <- gregexpr('lambda\\s*\\:\\s*([0-9\\.\\-\\+e]+)',fitprogress, perl=TRUE)
}
x<-''
for (a in 1:length(grx[[1]])) x<-x %s%
substr(fitprogress,attr(grx[[1]],"capture.start")[a],attr(grx[[1]],"capture.start")[a]+attr(grx[[1]],"capture.length")[a])
x<-gsub('\\s+','\n',x)
z<-unlist(strsplit(x,'\n'))
z<-as.numeric(z)
z <- z[1:niterations]
matrixresult[,paramloop] <- z
paramloop <- paramloop + 1
}
if (boolScreenOut == TRUE)
{
titletext <- c('WSSR','deltaWSSR','lambda',params)
rettext <- paste(c('Iter. ',format(titletext, width=13,justify='right'),'\n'), sep = '', collapse = '') %s% 
paste(t(cbind(format(as.character(0:(niterations-1)),justify='left', width=max(6,nchar(niterations-1)+1)),format(matrixresult,scientific=TRUE, width=13), '\n')), sep = '', collapse = '')
cat(rettext)
} else return ( matrixresult )
}

gp.init.save.stderr <- function(logfile)
{#initialize gnuplot, save stderr to a log file
if (!is.character(logfile)) stop('Argument <<logfile>> should be a string')
gp.init('gnuplot 2>' %s% logfile)
}

gp.init <- function(optcmd='gnuplot')
{#initialize gnuplot
handle<-as.integer(0)
ret <- .C("Rgnuplot_init",rtrnvalue=handle,as.character(optcmd),DUP = TRUE,PACKAGE="Rgnuplot" )
ret$rtrnvalue
}

gp.getfontpath<-function(handle)
{#get gnuplot's additional directories, for fonts
gp.CheckHandle(handle)
options(warn=-1)
tmpfile<-tempfile()
gp.cmd(handle, 'save set "' %s% tmpfile %s% '"' )
Sys.sleep(1)
s<-gp.file2string(tmpfile)
rx<-regexpr('\nset fontpath.*?\n',s)
s<-substr(s,rx[1],rx[1]+ attr(rx, "match.length")[1]-1)
s<-gsub("\\n", "", s, perl=TRUE)
s<-gsub("set fontpath", "", s, perl=TRUE)
s
}

gp.setfontpath<-function(handle,fontpath=system.file(package='Rgnuplot') %s% '/extdata')
{#set gnuplot's additional directories, for fonts, default path = extdata directory from Rgnuplot
gp.CheckHandle(handle)
options(warn=-1)
gp.cmd(handle, 'set fontpath "' %s% fontpath %s% '"')
}

gp.setvariable<-function(handle,variablename,variabledata)
{#set a system or environment variable "variablename", with value "variabledata"
gp.CheckHandle(handle)
options(warn=-1)
if (is.numeric(variabledata)) gp.cmd(handle, 'set ' %s% variablename %s% ' ' %s% variabledata ) else  gp.cmd(handle, 'set ' %s% variablename %s% ' "' %s% variabledata %s% '"')
}

gp.getvariable<-function(handle,variablename)
{# returns the value of a system or environment variable "variablename"
gp.CheckHandle(handle)
options(warn=-1)
#redirect output to a temporary file and save the variable's value
tmpfile<-tempfile()
gp.cmd(handle, 'set print "' %s% tmpfile %s% '";print ' %s% variablename %s% ';set print' )
Sys.sleep(1)
s<-gp.file2string(tmpfile)
s # return the variable's value
}

gp.getloadpath<-function(handle)
{#get gnuplot's additional directories, for data and scripts
gp.CheckHandle(handle)
options(warn=-1)
tmpfile<-tempfile()
gp.cmd(handle, 'save set "' %s% tmpfile %s% '"' )
Sys.sleep(1)
s<-gp.file2string(tmpfile)
rx<-regexpr('\nset loadpath.*?\n',s)
s<-substr(s,rx[1],rx[1]+ attr(rx, "match.length")[1]-1)
s<-gsub("\\n", "", s, perl=TRUE)
s<-gsub("set loadpath", "", s, perl=TRUE)
s
}

gp.setloadpath<-function(handle,loadpath=system.file(package='Rgnuplot') %s% '/extdata')
{#set gnuplot's additional directories, for data and scripts, default path = extdata directory from Rgnuplot
gp.CheckHandle(handle)
options(warn=-1)
gp.cmd(handle, 'set loadpath "' %s% loadpath %s% '"')
}

gp.version<-function(handle)
{# returns the gnuplot version
gp.CheckHandle(handle)
options(warn=-1)
#redirect output to a temporary file and save the working directory's path
tmpfile<-tempfile()
gp.cmd(handle, 'set print "' %s% tmpfile %s% '";print GPVAL_VERSION;set print' )
Sys.sleep(1)
s<-gp.file2string(tmpfile)
s # return the gnuplot version
}

gp.errmsg<-function(handle)
{#get gnuplot's error messages
gp.CheckHandle(handle)
options(warn=-1)
#redirect output to a temporary file and save the working directory's path
tmpfile<-tempfile()
gp.cmd(handle, 'set print "' %s% tmpfile %s% '";print GPVAL_ERRMSG;set print' )
Sys.sleep(1)
s<-gp.file2string(tmpfile)
s # return the error message
}

gp.getwd<-function(handle)
{#get gnuplot working directory
gp.CheckHandle(handle)
options(warn=-1)
#redirect output to a temporary file and save the working directory's path
tmpfile<-tempfile()
gp.cmd(handle, 'set print "' %s% tmpfile %s% '";print GPVAL_PWD;set print' )
Sys.sleep(1)
s<-gp.file2string(tmpfile)
s # return the working directory
}

gp.setwd<-function(handle,wd=getwd())
{#set gnuplot working directory, default path = R's working directory
gp.CheckHandle(handle)
options(warn=-1)
print(wd)
gp.cmd(handle, 'cd \"' %s% wd %s% '\"')
}

gp.PNG4DEM<-function(filePNG, fileDEMtab, file3Ddat)
{# converts a PNG file and a DEM tab separated to a text format readable by gnuplot 
p<-gp.PNG2color(filePNG)
z<-read.delim(fileDEMtab,sep=' ')
numrows<-nrow(z)
numcols<-ncol(z)
z2<-matrix(unlist(z),nrow=numrows)
file.remove(file3Ddat)
for (m in 1:numrows)
{
for (n in 1:numcols) cat(file=file3Ddat, m, '\t', n, '\t', z[m,n], '\t', p[m,n], '\n',append=TRUE)
cat(file=file3Ddat,'\n',append=TRUE)
}
}

gp.PNG2color<-function(fileName)
{# converts a PNG file to a text format readable by gnuplot 
library('png', character.only=TRUE) #
if (!file.exists(fileName)) stop('Error! File does not exist' )
p<-readPNG(fileName)
p<-p*255
numrows<-dim(p)[1]
numcols<-dim(p)[2]
p1<-matrix(0,nrow=numrows, ncol=numcols)
for (m in 1:numrows)
for (n in 1:numcols)
#p1[m,n]<-p[numrows-m+1,numcols-n+1,1]*65536+p[numrows-m+1,numcols-n+1,2]*256+p[numrows-m+1,numcols-n+1,3]
p1[m,n]<-p[m,n,1]*65536+p[m,n,2]*256+p[m,n,3]
p1
}

gp.matrix2XYdata<-function(fileName1,fileName2,optMatrix=NA,surfacegrid=FALSE,overwrite=TRUE)
{# converts a file with data in matrix format to an X, Y format readable by gnuplot
if (!file.exists(fileName1)) stop('Error! File does not exist' )
if (overwrite==FALSE & file.exists(fileName2)) stop('Error! File already exists' )
if (overwrite==TRUE & file.exists(fileName2)) file.remove(fileName2)
z<-read.delim(fileName1,sep=' ')
numrows<-nrow(z)
numcols<-ncol(z)
z<-matrix(unlist(z),nrow=numrows)
if(class(optMatrix)=='matrix') if(dim(optMatrix)[1]!=numrows*numcols) stop('Error! The optional matrix has incorrect dimensions' )
#optMatrix<-matrix(unlist(optMatrix),nrow=numrows)
c=1
for (m in 1:numrows)
{
if(class(optMatrix)!='matrix') for (n in 1:numcols) cat(file=fileName2,m,'\t',n,'\t',z[m,n],'\n',append=TRUE)
else for (n in 1:numcols) 
{
cat(file=fileName2,m,'\t',n,'\t',z[m,n],'\t', optMatrix[c,1],'\n',append=TRUE)
c=c+1
}
if(surfacegrid) cat(file=fileName2,'\n\n',append=TRUE) else cat(file=fileName2,'\n',append=TRUE)
}
}

gp.pauseX<-function(delaySecs=2)
{# pauses the system for a number of seconds and then waits for the user to press a key, X11 only
print('Pause - close window to continue')
repeat
{
Sys.sleep(delaySecs)
if(!gp.isWindowOpen(0)) break
}
}

gp.pause<-function(delaySecs=2)
{# pauses the system for a number of seconds and then waits for the user to press a key, detecs X11 beforehand
#print(X11.present)
if (gp.X11.present()) gp.pauseX(delaySecs)
else {
Sys.sleep(delaySecs)
readline(prompt = "Pause. Press <Enter> to continue...")
}
}

gp.isWindowOpen<-function(windowid)
{# returns true if an X11 window is opened
#based on Joel VanderWerf http://www.ruby-forum.com/topic/144886
options(warn=-1)
rtxt<-system('xprop -name "Gnuplot (window id : "' %s% windowid %s% '")" WM_STATE 1', intern =TRUE)
if (length(rtxt)==0) return (FALSE)
return(grepl('Normal',rtxt[2]) | grepl('Iconic',rtxt[2]))#return true if the window is open
}

gp.X11.present<-function()
{# returns true if X11 is present in the system
if (is.na(X11.present))
{
options(warn=-1)
rtxt<-system('echo $DISPLAY')
if (length(rtxt)==0) X11.present <- FALSE else X11.present <- TRUE
}
X11.present
}

gp.pidX11<-function(windowid=0)
{# returns the pid from an X11 window (gnuplot)
#based on Joel VanderWerf http://www.ruby-forum.com/topic/144886
options(warn=-1)
rtxt<-system('xprop -name "Gnuplot (window id : "' %s% windowid %s% '")" _NET_WM_PID', intern =TRUE)
if (length(rtxt)==0) return (NaN)
as.numeric(sub('\\D+','',rtxt))
}

gp.killpidX11<-function(windowid=0)
{# kills X11 windows (gnuplot)
#useful for testing purposes only- experimental, use at your own risk!
while (gp.isWindowOpen(windowid))
{
pid <- gp.pidX11(windowid)
if (is.numeric(pid)) system('kill ' %s% pid, intern =TRUE)
Sys.sleep(1)
}
}

gp.load.demo<-function(handle, mfile)
{# load a .dem gnuplot file and execute it, allowing pause statements
gp.CheckHandle(handle)
m<-read.delim(mfile,sep='\n',stringsAsFactors=FALSE,header=FALSE,colClasses='character')
m<-unlist(m)
tmpfile<-tempfile()
gp.cmd(handle, 'set print "' %s% tmpfile %s% '"' )
for(lcode in m)
{
if (grepl('pause',lcode)) 
{
gp.pause(2)
}
else {
gp.cmd(handle, lcode)
s<-gp.file2string(tmpfile)
if (s !='') print(s)
}
}
}

gp.WindowStatus<-function(windowid)
{# returns the status of an X11 window
#based on Joel VanderWerf http://www.ruby-forum.com/topic/144886
options(warn=-1)
rtxt<-system('xprop -name "Gnuplot (window id : "' %s% windowid %s% '")" WM_STATE 1', intern =TRUE)
if (length(rtxt)==0) return ('')
if (grepl('Withdrawn',rtxt[2])) return('Withdrawn')
if (grepl('Iconic',rtxt[2])) return('Iconic')
if (grepl('Normal',rtxt[2])) return('Normal')
}

gp.file2string<-function(mfile)
{# read a text file to a string
if (!file.exists(mfile)) return('')
if (file.info(mfile)$size==0) return('')
#m<-read.delim(mfile,sep='\n',stringsAsFactors=FALSE,header=FALSE,colClasses='character')
m<-readLines(mfile)
m<-paste(m,sep='\n', collapse='\n')
#m<-unlist(m)
m
}

gp.URL2string<-function(mURL)
{# read a text file from the web to a string
con <- url(mURL) # open a connection
mytxt <- readLines(con) # read the file
close(con) # close the connection
mytxt<-unlist(mytxt)
mytxt<-paste(mytxt,sep='\n', collapse='\n')
mytxt
}

gp.CheckHandle <- function(handle)
{
if (class(handle) != 'integer') stop('Argument <<handle>> is not a valid pointer')
if (handle==0) stop('Argument <<handle>> is not a valid pointer')
}

#	*	*	*	Function "gp.close" Package "Rgnuplot"		*	*	*
gp.close <- function(handle)
{
gp.CheckHandle(handle)
ret <- .C("Rgnuplot_close",handle,DUP = TRUE,PACKAGE="Rgnuplot" )
as.integer(0)
}

#	*	*	*	Function "gp.cmd" Package "Rgnuplot"		*	*	*
gp.cmd <- function(handle,cmd, ...)
{
gp.CheckHandle(handle)
if (!is.character(cmd)) stop('Argument <<cmd>> should be a string')
c<-list(...)
if(length(c)) ret <- .C("Rgnuplot_cmd",handle,as.character(cmd),...,DUP = TRUE,PACKAGE="Rgnuplot" ) else 
ret <- .C("Rgnuplot_send",handle,as.character(cmd),DUP = TRUE,PACKAGE="Rgnuplot" )
}

#	*	*	*	Function "gp.setstyle" Package "Rgnuplot"		*	*	*
gp.setstyle <- function(handle,plot.style)
{
gp.CheckHandle(handle)
if (!is.character(plot.style)) stop('Argument <<plot.style>> should be a string')
ret <- .C("Rgnuplot_setstyle",handle,as.character(plot.style),DUP = TRUE,PACKAGE="Rgnuplot" )
}

#	*	*	*	Function "gp.set.xlabel" Package "Rgnuplot"		*	*	*
gp.set.xlabel <- function(handle,label)
{
gp.CheckHandle(handle)
if (!is.character(label)) stop('Argument <<label>> should be a string')
ret <- .C("Rgnuplot_set_xlabel",handle,as.character(label),DUP = TRUE,PACKAGE="Rgnuplot" )
}

#	*	*	*	Function "gp.set.ylabel" Package "Rgnuplot"		*	*	*
gp.set.ylabel <- function(handle,label)
{
gp.CheckHandle(handle)
if (!is.character(label)) stop('Argument <<label>> should be a string')
ret <- .C("Rgnuplot_set_ylabel",handle,as.character(label),DUP = TRUE,PACKAGE="Rgnuplot" )
}

#	*	*	*	Function "gp.resetplot" Package "Rgnuplot"		*	*	*
gp.resetplot <- function(handle)
{
gp.CheckHandle(handle)
ret <- .C("Rgnuplot_resetplot",handle,DUP = TRUE,PACKAGE="Rgnuplot" )
}

#	*	*	*	Function "gp.plot.x" Package "Rgnuplot"		*	*	*
gp.plot.x <- function(handle,d,n,title)
{
gp.CheckHandle(handle)
if (!is.numeric(d)) stop('Argument <<d>> should be a number')
if (!is.numeric(n)) stop('Argument <<n>> should be a number')
if (!is.character(title)) stop('Argument <<title>> should be a string')
ret <- .C("Rgnuplot_plot_x",handle,as.numeric(d),as.integer(n),as.character(title),DUP = TRUE,PACKAGE="Rgnuplot" )
}

#	*	*	*	Function "gp.plot.xy" Package "Rgnuplot"		*	*	*
gp.plot.xy <- function(handle,x,y,n,title)
{
gp.CheckHandle(handle)
if (!is.numeric(x)) stop('Argument <<x>> should be a number')
if (!is.numeric(y)) stop('Argument <<y>> should be a number')
if (!is.numeric(n)) stop('Argument <<n>> should be a number')
if (!is.character(title)) stop('Argument <<title>> should be a string')
ret <- .C("Rgnuplot_plot_xy",handle,as.numeric(x),as.numeric(y),as.integer(n),as.character(title),DUP = TRUE,PACKAGE="Rgnuplot" )
}

#	*	*	*	Function "gp.plot.once" Package "Rgnuplot"		*	*	*
gp.plot.once <- function(title,style,label.x,label.y,x,y,n)
{
if (!is.character(title)) stop('Argument <<title>> should be a string')
if (!is.character(style)) stop('Argument <<style>> should be a string')
if (!is.character(label.x)) stop('Argument <<label.x>> should be a string')
if (!is.character(label.y)) stop('Argument <<label.y>> should be a string')
if (!is.numeric(x)) stop('Argument <<x>> should be a number')
if (!is.numeric(y)) stop('Argument <<y>> should be a number')
if (!is.numeric(n)) stop('Argument <<n>> should be a number')
ret <- .C("Rgnuplot_plot_once",as.character(title),as.character(style),as.character(label.x),as.character(label.y),as.numeric(x),as.numeric(y),as.integer(n),DUP = TRUE,PACKAGE="Rgnuplot" )
}

#	*	*	*	Function "gp.plot.slope" Package "Rgnuplot"		*	*	*
gp.plot.slope <- function(handle,a,b,title)
{
gp.CheckHandle(handle)
if (!is.numeric(a)) stop('Argument <<a>> should be a number')
if (!is.numeric(b)) stop('Argument <<b>> should be a number')
if (!is.character(title)) stop('Argument <<title>> should be a string')
ret <- .C("Rgnuplot_plot_slope",handle,as.numeric(a),as.numeric(b),as.character(title),DUP = TRUE,PACKAGE="Rgnuplot" )
}

#	*	*	*	Function "gp.plot.equation" Package "Rgnuplot"		*	*	*
gp.plot.equation <- function(handle,equation,title)
{
gp.CheckHandle(handle)
if (!is.character(equation)) stop('Argument <<equation>> should be a string')
if (!is.character(title)) stop('Argument <<title>> should be a string')
ret <- .C("Rgnuplot_plot_equation",handle,as.character(equation),as.character(title),DUP = TRUE,PACKAGE="Rgnuplot" )
}

#	*	*	*	Function "gp.write.x.csv" Package "Rgnuplot"		*	*	*
gp.write.x.csv <- function(fileName,x,n,title)
{
if (!is.character(fileName)) stop('Argument <<fileName>> should be a string')
if (!is.numeric(x)) stop('Argument <<x>> should be a number')
if (!is.numeric(n)) stop('Argument <<n>> should be a number')
if (!is.character(title)) stop('Argument <<title>> should be a string')
rtrnvalue<-0
ret <- .C("Rgnuplot_write_x_csv",as.character(fileName),as.numeric(x),as.integer(n),as.character(title),rtrnvalue=as.integer(rtrnvalue),DUP = TRUE,PACKAGE="Rgnuplot" )
ret$rtrnvalue
}

#	*	*	*	Function "gp.write.xy.csv" Package "Rgnuplot"		*	*	*
gp.write.xy.csv <- function(fileName,x,y,n,title)
{
if (!is.character(fileName)) stop('Argument <<fileName>> should be a string')
if (!is.numeric(x)) stop('Argument <<x>> should be a number')
if (!is.numeric(y)) stop('Argument <<y>> should be a number')
if (!is.numeric(n)) stop('Argument <<n>> should be a number')
if (!is.character(title)) stop('Argument <<title>> should be a string')
rtrnvalue<-0
ret <- .C("Rgnuplot_write_xy_csv",as.character(fileName),as.numeric(x),as.numeric(y),as.integer(n),as.character(title),rtrnvalue=as.integer(rtrnvalue),DUP = TRUE,PACKAGE="Rgnuplot" )
ret$rtrnvalue
}

#	*	*	*	Function "gp.write.multi.csv" Package "Rgnuplot"		*	*	*
gp.write.multi.csv <- function(fileName,xListPtr,n,numColumns,title)
{
if (!is.character(fileName)) stop('Argument <<fileName>> should be a string')
if (!is.numeric(xListPtr)) stop('Argument <<xListPtr>> should be a number')
if (!is.numeric(n)) stop('Argument <<n>> should be a number')
if (!is.numeric(numColumns)) stop('Argument <<numColumns>> should be a number')
if (!is.character(title)) stop('Argument <<title>> should be a string')
rtrnvalue<-0
ret <- .C("Rgnuplot_write_multi_csv",as.character(fileName),as.numeric(xListPtr),as.integer(n),as.integer(numColumns),as.character(title),rtrnvalue=as.integer(rtrnvalue),DUP = TRUE,PACKAGE="Rgnuplot" )
ret$rtrnvalue
}

