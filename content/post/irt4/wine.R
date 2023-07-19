# remotes::install_github("liao961120/stom")
library(stom)

set.seed(1023)
Nj = 10
Nw = 20
Oj = rep( 1:2, each=Nj/2 )
Ow = rep( 1:2, each=Nw/2 )
J = rnorm(Nj)
W = ifelse( Ow == 1, rnorm(Nw/2, 3), rnorm(Nw/2, -3) )
J = standardize( J )
W = standardize( W )
I = matrix(c(1.5, 0,
             0, 0), nrow=2, byrow=T )
cutpoints = c( -1.7, 0, 1.7 )

d = expand.grid( Jid=1:Nj, Wid=1:Nw, KEEP.OUT.ATTRS=F )
d$J = J[d$Jid]
d$W = W[d$Wid]
d$Oj = Oj[d$Jid]
d$Ow = Ow[d$Wid]
d$L = sapply( 1:nrow(d), function(i) d$J[i] + d$W[i] + I[d$Oj[i], d$Ow[i]] )
d$I11 = ifelse( d$Oj == 1 & d$Ow == 1, 1, 0 )
d$I12 = ifelse( d$Oj == 1 & d$Ow == 2, 1, 0 )
d$I21 = ifelse( d$Oj == 2 & d$Ow == 1, 1, 0 )
d$I22 = ifelse( d$Oj == 2 & d$Ow == 2, 1, 0 )
# d$L = d$J + d$W + I[1,1]*d$I11 + I[1,2]*d$I12 + I[2,1]*d$I21 + I[2,2]*d$I22
d$S = rordlogit( d$L, cutpoints )
d$B = rbern( logistic(d$L) )

for (v in c("Oj", "Ow", "Jid", "Wid"))
  d[[v]] = factor( d[[v]] )
d$S = ordered( d$S )


#########################
##### Test #############
########################
data("VerbAgg")
m = glmer( r2 ~ -1 + mode:Gender + (0 + Gender | item) + (0 + mode | id),
           data=VerbAgg, family = binomial )

#########################
#### Model 0: Normal ####
#########################
library(lme4)
d2 = d
d2$L = standardize( d2$L )
contrasts(d2$Jid) = contr.sum(Nj)
contrasts(d2$Wid) = contr.sum(Nw)
m0 = lm( L ~ -1 + Jid + Wid + Oj:Ow, data=d2 )
# m0 = lmer( L ~ -1 + (1|Jid) + (1|Wid) + Oj:Ow, data=d2 )

#########################
#### Model 1: Binary ####
#########################
m1 = glmer( B ~ -1 + Oj:Ow + (1|Jid) + (1|Wid),
            data=d, family = binomial() )
summary(m1)

########################
#### Model 1: GLMM #####
########################
library(ordinal)
m2.2 = clmm( S ~ (1|Jid) + (1|Wid) + Oj:Ow, data = d )
summary(m2.2)

plot(ranef( m2.2 )$Wid[[1]], W); abline(0,1)
plot(ranef( m2.2 )$Jid[[1]], J); abline(0,1)


## ToDo: Bayes to check interaction
