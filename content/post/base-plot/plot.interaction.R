library(stom)
library(dplyr)

#### Data ####
d = iris |> 
    group_by(Species) |> 
    summarise(
        S.L = mean(Sepal.Length),
        S.W = mean(Sepal.Width),
        P.L = mean(Petal.Length),
        P.W = mean(Petal.Width)
    ) 
d

#### Annotations ####
(LABELS = colnames(d)[-1])

#### Plot ####
#       c( b,   l,   t,   r )       
par( mar=c(5.1, 4.1, 4.1, 8.1), xpd=F )  # Larger right margin for legend
plot( 1, type="n", xlim=c(.5, 4.5), ylim=c(0,7),
      xlab="", ylab="Mean",
      xaxt="n", yaxt="n")  # disable x/y-axis
# Shaded region (coordinates are specified (counter-)clockwise)
polygon( c(0,4.9,4.9,0),c(2,2,5,5), col=col.alpha("grey",.15), lty=2, border="grey" )
# Auxiliary lines
for ( h in 0:7 )
    abline( h=h, col=col.alpha("grey") )
# Lines & Points
for ( i in 1:nrow(d) ) {
    lines ( 1:4, d[i,-1], col=i, lwd=4 )
    points( 1:4, d[i,-1], col=i, lwd=4, pch=2+i )
}
# Labels
for ( i in 1:nrow(d) ) {
    if ( i != 2 ) next
    text( 1:4-.03, d[i,-1]-.45, labels = d[i,-1], cex=.9, col=i )
}
# Axis
axis( 1, at=1:4, tck=-.02, labels=LABELS )
axis( 2, at=0:7, labels=sprintf("%.1f", 0:7), las=1 )  # rotated y-axis labels
# Legend (outside of plotting region)
legend("right", legend=d$Species, inset=c(-.17,0), xpd=TRUE, 
       col=1:nrow(d), pch=1:nrow(d) + 2, lwd=4, cex=.9, 
       y.intersp=1.8, box.col="transparent", bg="transparent" )
