# remotes::install_github("liao961120/stom")
library(stom)

set.seed(1023)
Nj = 40
Nw = 40
N = Nj * Nw
Oj = rep( 1:2, each=Nj/2 )
Ow = rep( 1:2, each=Nw/2 )
J = rnorm(Nj)
W = ifelse( Ow == 1, rnorm(Nw, 4), rnorm(Nw, -4) )
J = standardize( J )
W = standardize( W )
I = matrix(c(1.3, 0,
             0,  1.3 ), nrow=2, byrow=T )
# I = matrix( rep(0, 4), nrow=2 )
cutpoints = c( -1.7, 0, 1.7 )

d = expand.grid( Jid=1:Nj, Wid=1:Nw, KEEP.OUT.ATTRS=F )
d$J = J[d$Jid]
d$W = W[d$Wid]
d$Oj = Oj[d$Jid]
d$Ow = Ow[d$Wid]
d$L = sapply( 1:nrow(d), function(i) d$J[i] + d$W[i] + I[d$Oj[i], d$Ow[i]] )
d$R = stom::rordlogit( d$L, cutpoints )
d$B = rbern( logistic(d$L) )


library(rethinking)
dat = list(
  N = Nj*Nw,
  Nw = Nw,
  Nj = Nj,
  R = d$R,
  B = d$B,
  L = d$L,
  Wid = d$Wid,
  Jid = d$Jid,
  Ow = d$Ow,
  Oj = d$Oj
)

#############################################
#### Model 0: binary without interaction ####
#############################################
#      R
#     ^ ^
#    /   \
#   J     W <-- Ow
m0 = rethinking::stan( file="wine_network_binary0.stan", data=dat,
                  chains = 4, cores=4, threads=2, iter=1200 )
precis( m0, 3, pars = c("W", "J", "b") )


############################################
#### Model 0.1: binary with interaction ####
############################################
m0.1 = rethinking::stan( file="wine_network_binary1.stan", data=dat,
                       chains = 4, cores=4, threads=2, iter=1200 )
precis( m0.1, 3, pars = c("W", "J", "b", "bOjR", "bOwR", "Int") )






## Ulam
m0 = ulam(alist(
  B ~ bernoulli(p),
  p <- inv_logit( J[Jid] + W[Wid] + I[Oj, Ow] ),
  matrix[2,2]:I ~ dnorm(0, 1),
  J ~ dnorm( 0, 1 ),

  vector[Nw]:W ~ dnorm(mu, 1),
  mu[Ow] <- a[Ow],
  vector[2]:a ~ dnorm( 0, 1 )
), data = dat, chains = 4, cores = 4, threads = 2, sample=T )


