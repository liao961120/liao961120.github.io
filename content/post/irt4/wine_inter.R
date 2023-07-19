# remotes::install_github("liao961120/stom")
library(stom)

set.seed(1023)
Nj = 20
Nw = 30
N = Nj * Nw
Oj = rep( 1:2, each=Nj/2 )
Ow = rep( 1:2, each=Nw/2 )
J = rnorm(Nj)
# W = rnorm(Nw) + ifelse( Ow == 1, 1, 0 )
W = rnorm(Nw)
J = standardize( J )
W = standardize( W )
I = matrix(c(1.3, 0,
             0,  1.3 ), nrow=2, byrow=T )
cutpoints = c( -1.7, 0, 1.7 )

d = expand.grid( Jid=1:Nj, Wid=1:Nw, KEEP.OUT.ATTRS=F )
d$J = J[d$Jid]
d$W = W[d$Wid]
d$Oj = Oj[d$Jid]
d$Ow = Ow[d$Wid]
d$I11 = ifelse( d$Oj == 1 & d$Ow == 1, 1, 0 )
d$I12 = ifelse( d$Oj == 1 & d$Ow == 2, 1, 0 )
d$I21 = ifelse( d$Oj == 2 & d$Ow == 1, 1, 0 )
d$I22 = ifelse( d$Oj == 2 & d$Ow == 2, 1, 0 )
d$L = sapply( 1:nrow(d), function(i) d$J[i] + d$W[i] + I[d$Oj[i], d$Ow[i]] )
d$R = stom::rordlogit( d$L, cutpoints )
d$B = rbern( logistic(d$L) )

#########################
#### Model 0: binary ####
#########################
library(lme4)
m0 = glmer( B ~ -1 + (1|Jid) + (1|Wid) + I11 + I22 + I12 + I21, data = d, 
            family = binomial )
summary(m0)


########################
#### Model 1: GLMM #####
########################
library(ordinal)
m2.2 = clmm( ordered(R) ~ (1|Jid) + (1|Wid) + I11 + I12 + I21 + I22, data = d )
summary(m2.2)



#########################
#### Model 2: Bayes #####
#########################
dat = list(
  N = N,
  Nj = Nj,
  Nw = Nw,
  Nc = length(cutpoints),
  Jid = d$Jid,
  Wid = d$Wid,
  R = d$R,
  Ow = d$Ow,
  Oj = d$Oj
)

library(rstan)
rstan_options(auto_write = TRUE)
m.b = stan( "partial-pooled.stan", data=dat, chains=4, cores=4 )


# library(rethinking)
rethinking::precis( m.b, depth=3 )

