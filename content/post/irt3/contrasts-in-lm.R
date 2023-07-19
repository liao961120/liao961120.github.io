# https://stats.oarc.ucla.edu/r/library/r-library-contrast-coding-systems-for-categorical-variables
# https://stats.oarc.ucla.edu/r/modules/coding-for-categorical-variables-in-regression-models/
hsb2 <- read.csv("https://stats.idre.ucla.edu/stat/data/hsb2.csv")

hsb2$race.f <- factor(hsb2$race)
hsb2$ses = factor(hsb2$ses)
hsb2$prog = factor(hsb2$prog)
d = hsb2

# Default: treatment contrast
d1 = d
m = lm( write ~ -1 + race.f + ses + prog, data=d1 )
summary(m)


# Deviance contrast on `prog`
d1 = d
contrasts(d1$prog) = contr.sum(3) #contr.sum(4)
m = lm( write ~ -1 + race.f + ses + prog, data=d1 )
summary(m)


# Deviance contrast on `ses` & `prog`
d1 = d
contrasts(d1$ses) = contr.sum(3)
contrasts(d1$prog) = contr.sum(3)
m = lm( write ~ -1 + race.f + ses + prog, data=d1 )
summary(m)

