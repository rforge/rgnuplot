\name{GpCheckHandle}
\alias{GpCheckHandle}
\title{Check if the gnuplot session handle is valid}
\description{\code{GpCheckHandle} checks a gnuplot session handle and returns an error message if it is invalid}
\usage{GpCheckHandle(handle)}
\arguments{	\item{handle}{ handle to the connection}}
\value{	none}
\seealso{	\code{\link{Gpinit}}}
\author{Jose' Gama}
\examples{
#Initialize the gnuplot handle
h1<-Gpinit()
#returns TRUE for valid handle
\dontrun{GpCheckHandle(h1)}
#close gnuplot handle
h1<-Gpclose(h1)
#this generates an error
#GpCheckHandle(h1)
}
\keyword{programming}
