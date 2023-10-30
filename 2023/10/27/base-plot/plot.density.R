library(stom)
library(dplyr)

#### Data ####
set.seed(2020)
d = data.frame(
    x = rnorm(2000)
)

#### Annotations ####
X  = d$x
AVG = mean(X)
SD  = sd(X)

#### Plot ####
plot( density(X), ylim=c(0,.46),
      main = "A Standard Normal", xlab = "X" )
# Mean line segment
segments( x0=AVG, y0=0, y1=.43, col=2, lwd=3 )
text( AVG, .46, labels = paste("AVG:",round(AVG,3)), col=2, cex=.8 )
# SD line segment
segments( x0=AVG+.06, x1=AVG+SD, y0=.02, lwd=2, col=4 )
segments( x0=AVG+.06, y0=.01, y1=.03,    lwd=2, col=4 )
segments( x0=AVG+SD,  y0=.01, y1=.03,    lwd=2, col=4 )
text( .5*(AVG+SD+.06), .035, 
      labels = paste("SD =",round(SD,3)), col=4, cex=.8 )
