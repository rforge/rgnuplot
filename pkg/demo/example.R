
# example of plotting slopes, equations, styles, lists of points and multiple output windows gnuplot_i, by Nicolas Devillard Initialize variables
NPOINTS <- 50
SLEEP_LGTH <- 2
x <- vector("numeric", NPOINTS)
y <- vector("numeric", NPOINTS)
# Initialize the gnuplot handle
print("*** example of gnuplot control through C ***\n")
h1 <- Gpinit()
h2 <- Gpinit()

# Slopes

GpSetstyle(h1, "lines")

print("*** plotting slopes\n")
print("y = x\n")
GpPlotSlope(h1, 1, 0, "unity slope")
Sys.sleep(SLEEP_LGTH)

print("y = 2*x\n")
GpPlotSlope(h1, 2, 0, "y=2x")
Sys.sleep(SLEEP_LGTH)

print("y = -x\n")
GpPlotSlope(h1, -1, 0, "y=-x")
Sys.sleep(SLEEP_LGTH)

# Equations

GpResetplot(h1)
print("\n\n*** various equations\n")
print("y = sin(x)\n")
GpPlotEquation(h1, "sin(x)", "sine")
Sys.sleep(SLEEP_LGTH)

print("y = log(x)\n")
GpPlotEquation(h1, "log(x)", "logarithm")
Sys.sleep(SLEEP_LGTH)

print("y = sin(x)*cos(2*x)\n")
GpPlotEquation(h1, "sin(x)*cos(2*x)", "sine product")
Sys.sleep(SLEEP_LGTH)

# Styles

GpResetplot(h1)
print("\n\n")
print("*** showing styles\n")

print("sine in points\n")
GpSetstyle(h1, "points")
GpPlotEquation(h1, "sin(x)", "sine")
Sys.sleep(SLEEP_LGTH)

print("sine in impulses\n")
GpSetstyle(h1, "impulses")
GpPlotEquation(h1, "sin(x)", "sine")
Sys.sleep(SLEEP_LGTH)

print("sine in steps\n")
GpSetstyle(h1, "steps")
GpPlotEquation(h1, "sin(x)", "sine")
Sys.sleep(SLEEP_LGTH)

# User defined 1d and 2d point sets

GpResetplot(h1)
GpSetstyle(h1, "impulses")
print("\n\n")
print("*** user-defined lists of doubles\n")
for (i in 1:NPOINTS) {
    x[i] = i * i
}
GpPlotX(h1, x, NPOINTS, "user-defined doubles")
Sys.sleep(SLEEP_LGTH)

print("*** user-defined lists of points\n")
for (i in 1:NPOINTS) {
    x[i] = i
    y[i] = i * i
}
GpResetplot(h1)
GpSetstyle(h1, "points")
GpPlotXY(h1, x, y, NPOINTS, "user-defined points")
Sys.sleep(SLEEP_LGTH)


# Multiple output screens

print("\n\n")
print("*** multiple output windows\n")
GpResetplot(h1)
GpSetstyle(h1, "lines")
h2 = Gpinit()
GpSetstyle(h2, "lines")
h3 = Gpinit()
GpSetstyle(h3, "lines")
h4 = Gpinit()
GpSetstyle(h4, "lines")

print("window 1: sin(x)\n")
GpPlotEquation(h1, "sin(x)", "sin(x)")
Sys.sleep(SLEEP_LGTH)
print("window 2: x*sin(x)\n")
GpPlotEquation(h2, "x*sin(x)", "x*sin(x)")
Sys.sleep(SLEEP_LGTH)
print("window 3: log(x)/x\n")
GpPlotEquation(h3, "log(x)/x", "log(x)/x")
Sys.sleep(SLEEP_LGTH)
print("window 4: sin(x)/x\n")
GpPlotEquation(h4, "sin(x)/x", "sin(x)/x")
Sys.sleep(SLEEP_LGTH * 5)

# close gnuplot handles
h1 <- Gpclose(h1)
h2 <- Gpclose(h2)
h3 <- Gpclose(h3)
h4 <- Gpclose(h4)

 
