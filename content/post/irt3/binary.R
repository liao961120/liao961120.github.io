library(dplyr)
library(tidyr)
library(glue)
source("utils.R")
if (Sys.info()["login"] == "rd") 
  windowsFonts(sans = "SF Pro Display")


logistic = function(x) 1 / (1 + exp(-x))
rbern = function( p, n=length(p) ) rbinom( n=n, size=1, prob=p )
#######################
#### Simulate data ####
#######################
set.seed(13)
n_item = 20    # number of items
n_subj = 80    # number of subjects
n_resp = n_subj * n_item  # number of responses

A = rnorm( n=n_subj, mean=0, sd=1 )  # Subjects' ability
D = seq( -1.6, 1 , length=n_item )  # Items' difficulty

# The data
d = expand.grid( S=1:n_subj, I=1:n_item, KEEP.OUT.ATTRS = FALSE )
d$R = rbern( logistic(A[d$S] - D[d$I]) )
d$S = factor(d$S)
d$I = factor(d$I)
str(d)




###########################
#### Unidentifiability ####
###########################
library(fastDummies)
d_dummy = dummy_cols( d, c("I", "S"), remove_selected_columns=TRUE )
# str(d_dummy)

m1 = glm( R ~ -1 + ., data=d_dummy, family = binomial("logit") )
summary(m1)

# Shift A/D by a common factor
s = 5
A2 = A + s
D2 = D + s

p1 = logistic( A[d$S] - D[d$I] )    # Probabilities before shift
p2 = logistic( A2[d$S] - D2[d$I] )  # Probabilities after shift
sum( abs(p1 - p2) )  # Should be extremely close to zero

## -----------------------------------------------------------
# Effect coding imposing constraint: beta of subj sums to zero
d_dummy2 = d_dummy
toDrop = "S_1"
allCategories = startsWith( names(d_dummy2), "S_" )
idx_recode = which( d_dummy2[[toDrop]] == 1 )
d_dummy2[idx_recode, allCategories] = -1
d_dummy2[[toDrop]] = NULL

## -----------------------------------------------------------
m1.1 = glm( R ~ -1 + ., data=d_dummy2, family = binomial('logit') )
summary(m1.1)


eff = coef(m1.1)
item_eff = eff[ startsWith(names(eff), "I_") ]
subj_eff = eff[ startsWith(names(eff), "S_") ]
# Reconstruct S_1 from the remaining subject effects
subj_eff = c( -sum(subj_eff), subj_eff )

plot( subj_eff, A, pch=19, col=4 ); abline(0, 1, lty="dashed" )
plot( -item_eff, D, pch=19, col=2 ); abline(0, 1, lty="dashed" )


true_eff = c(D, A)
est_eff = c(-item_eff, subj_eff)
n_param = n_item + n_subj
cols = c( rep(2, n_item), rep(4, n_subj) )
plot( 1, type="n", ylim=c(-2.4, 2.4), xlim=c(1, n_param+1), ylab="Effect" )
abline( h=0, lty="dashed", col="grey" )
abline( v=n_item+0.5, col="grey")
points( true_eff, pch=19, col=cols )
points( est_eff, col=cols )
for (i in 1:n_param)
  lines( c(i, i), c(true_eff[i], est_eff[i]), col=cols[i] )
mtext( c("Items", "Subjects"), at=c(9, 61), padj = -.5, col=c(2, 4) )







dat = d
contrasts( dat$S ) = contr.sum( n_subj )  # Drop the last S and impose sum-to-zero constraint on S
m1.2 = glm( R ~ -1 + I + S, data=dat, family=binomial("logit") )
eff = coef(m1.2)
item_eff.m1.2 = eff[ startsWith(names(eff), "I") ]
subj_eff.m1.2 = eff[ startsWith(names(eff), "S") ]
subj_eff.m1.2 = c( subj_eff.m1.2, -sum(subj_eff.m1.2) )

est_m1.1 = c( item_eff, subj_eff )
est_m1.2 = c( item_eff.m1.2, subj_eff.m1.2 )
plot( 1, type="n", xlim=c(-2.5, 2.5), ylim=c(-2.5, 2.5), xlab="m1.2", ylab="m1.1" )
abline( 0,1, lty="dashed", col="grey" )
points( est_m1.2, est_m1.1, pch=19, col=cols )

## -----------------------------------------------------------
err_abs = function(x, y) mean( abs(x - y) )
err_sq  = function(x, y) mean( (x - y)^2 )


## -----------------------------------------------------------
err_abs(D, -item_eff.m1)
err_sq(D, -item_eff.m1)


## -----------------------------------------------------------
# Effect coding imposing constraint: betas of item to sums to zero
d_eff2 = d_dummy
idx = which( d_eff2$item_20 == 1 )
d_eff2[idx, glue("item_{1:19}") ] = -1
d_eff2$item_20 = NULL
names(d_eff2)[startsWith(names(d_eff2), "item_")] = glue("e{1:19}")


## -----------------------------------------------------------
m1.2 = glm( endorse ~ -1 + ., data=d_eff2, family = binomial('logit') )
summary(m1.2)

# Recode e to item
e_code = coef(m1.2)[101:119]
item_eff.m1.2 = c( e_code, -sum(e_code) )
subj_eff.m1.2 = coef(m1.2)[1:100]


## -----------------------------------------------------------
err_abs(D, -item_eff.m1.2)
err_sq(D, -item_eff.m1.2)


## -----------------------------------------------------------
d1 = d
# contrasts(d1$I) = contr.sum(n_item)
contrasts(d1$S) = contr.sum(n_subj)
m1 = glm( R ~ -1 + I + S, data=d1, family = binomial("logit") )

eff = coef(m1)
item_eff.m1 = eff[1:n_item]
subj_eff.m1 = eff[(n_item+1):(n_item+n_subj-1)]
subj_eff.m1 = c( subj_eff.m1, -sum(subj_eff.m1) )

## -----------------------------------------------------------
library(lme4)
# Partial pooling on subj
m2 = glmer(R ~ -1 + I + (1|S), data = d, 
             family = binomial(link='logit'))

item_eff.m2 = fixef(m2)
subj_eff.m2 = ranef(m2)$S[, 1]


## -----------------------------------------------------------
err_abs(D, -item_eff.m2)
err_sq(D, -item_eff.m2)


## -----------------------------------------------------------
# Partial pooling on item & subj
m2.2 = glmer(R ~ 1 + (1|S) + (1|I), data = d, 
             family = binomial(link='logit'))

subj_eff.m2.2 = ranef(m2.2)$S[, 1]
item_eff.m2.2 = ranef(m2.2)$I[, 1] + fixef(m2.2)[["(Intercept)"]]




## -----------------------------------------------------------
err_abs(D, -item_eff.m2.2)
err_sq(D, -item_eff.m2.2)


## ----fig.dim=c(8, 5)----------------------------------------
png("1PL-model-compare.png", 
    width = 2000, height = 1000, res = 450, pointsize = 5.5 )
plot( 1, type="n", ylim = c(-2.7, 2.7), xlim=c( 0, n_subj+n_item + 1 ), 
      ylab = "Estimated Difficulty", xlab = "Item Index" )
abline( v = n_item + .5, lwd=0.5 )
abline( h = 0, lty="dashed", lwd=0.5 )
points( c(D, A), pch=19 )
points( c(-item_eff.m1,   subj_eff.m1),   col=4)
# points( c(-item_eff.m2,   subj_eff.m2),   col="red"    , cex=1.2, lwd = 1.8 )
points( c(-item_eff.m2.2, subj_eff.m2.2), col=2 )
dev.off() 
