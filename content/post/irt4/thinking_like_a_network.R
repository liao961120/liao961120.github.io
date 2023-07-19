## R code 15.2
library(rethinking)
data(WaffleDivorce)
d <- WaffleDivorce
# R code 15.5
dlist2 <- list(
  D_obs = standardize( d$Divorce ),
  D_sd = d$Divorce.SE / sd( d$Divorce ),
  M_obs = standardize( d$Marriage ),
  M_sd = d$Marriage.SE / sd( d$Marriage ),
  A = standardize( d$MedianAgeMarriage ),
  N = nrow(d)
)

m15.2 <- ulam(
  alist(
    # D* model (observed)
    D_obs ~ dnorm( D_true , D_sd ),
    
    # D model (unobserved)
    vector[N]:D_true ~ dnorm( mu , sigma ),
    mu <- a + bA*A + bM*M_true[i],
    a ~ dnorm(0,0.2),
    bA ~ dnorm(0,0.5),
    bM ~ dnorm(0,0.5),
    sigma ~ dexp( 1 ),
    
    # M* model (observed)
    M_obs ~ dnorm( M_true , M_sd ),
    
    # M model (unobserved)
    vector[N]:M_true ~ dnorm( nu , tau ),
    nu <- aM + bAM*A,
    aM ~ dnorm(0,0.2),
    bAM ~ dnorm(0,0.5),
    tau ~ dexp( 1 )
    
  ) , data=dlist2 , chains=4 , cores=4, sample=F )