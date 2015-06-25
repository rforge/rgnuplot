library(Rgnuplot)
h1 <- GpInit()
# set gnuplot's additional search directories, to the extdata directory from Rgnuplot (default)
GpSetloadpath(h1)
# change gnuplot's working directory to be the same as R's working directory (default)
GpSetwd(h1)
# plot an RGB binary file GpCmd(h1, 'set terminal png truecolor;set output 'plotRGB1.png'')
GpCmd(h1, "set size ratio -1; plot \"blutux.rgb\" binary array=128x128 flipy format=\"%uchar\" with rgbimage notit")
# GpCmd(h1, 'set terminal X11;set output') plot a 2D RGB binary file in a 3D box GpCmd(h1, 'set terminal png truecolor;set output 'plotRGB2.png'')
GpCmd(h1, "splot \"blutux.rgb\" binary array=(128,128) flipy format=\"%uchar%uchar%uchar\" with rgbimage notit")
# GpCmd(h1, 'set terminal X11;set output') convert an RGB file to PNG
rgbfile <- system.file("extdata/blutux.rgb", package = "Rgnuplot")
GpRGB2image(rgbfile, "blutux.png", 128, 128)
# plot the recently converted PNG file
GpCmd(h1, "set size ratio -1;plot \"blutux.png\" binary filetype=png with rgbimage notitle")
# plot a 2D RGB binary file in a 3D box
GpCmd(h1, "splot \"blutux.png\" binary filetype=png with rgbimage notitle")
# convert a PNG file with alpha channel to an RGBA binary file
pngfile <- system.file("extdata/220px-Tux.png", package = "Rgnuplot")
GpPNG2RGB(pngfile, "220px-Tux.rgb")
# plot the recently converted RGBA binary file
GpCmd(h1, "set size ratio -1;plot \"220px-Tux.rgb\" binary array=220x261 flipy format=\"%uchar\" with rgbalpha notit")
# plot a 2D RGBA binary file in a 3D box
GpCmd(h1, "splot \"220px-Tux.rgb\" binary array=(220,261) flipy format=\"%uchar\" with rgbalpha notit")
GpPause()
# close gnuplot handle
h1 <- Gpclose(h1) 
