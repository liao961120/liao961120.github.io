# remotes::install_github("liao961120/stom")
library(stom)

set.seed(1023)
Nj = 20
Nw = 30
J = standardize( rnorm(Nj) )
W = standardize( rnorm(Nw) )
cutpoints = c( -1.7, 0, 1.7 )

d = expand.grid( Jid=1:Nj, Wid=1:Nw, KEEP.OUT.ATTRS=F )
d$J = J[d$Jid]
d$W = W[d$Wid]
d$L = d$J + d$W
d$R = rordlogit( d$L, cutpoints )

d2 = d
for (v in c("Jid", "Wid" ))
  d2[[v]] = factor( d2[[v]] )

########################
#### Model 1: GLMM #####
########################
library(ordinal)
m2.2 = clmm( ordered(R) ~ (1|Jid) + (1|Wid), data = d2 )
summary(m2.2)
ranef(m2.2)
condVar(m2.2)

plot(ranef( m2.2 )$Wid[[1]], W); abline(0,1)
plot(ranef( m2.2 )$Jid[[1]], J); abline(0,1)




#########################
#### Model 2: Bayes #####
#########################
dat = list(
  N = Nj*Nw,
  Nj = Nj,
  Nw = Nw,
  Nc = length(cutpoints),
  Jid = d$Jid,
  Wid = d$Wid,
  R = d$R
)

library(rstan)
rstan_options(auto_write = TRUE)
m.b = stan( "wine.stan", data=dat, chains=4, cores=4 )

# library(rethinking)
rethinking::precis( m.b, depth=3 )
