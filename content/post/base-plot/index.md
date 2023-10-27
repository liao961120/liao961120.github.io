---
title: Base R Plotting Notes
# subtitle: "Base R"
description: "Base R, plot, graphics"
date: '2023-10-27'
aliases:
    - /base-plot
katex: true
draft: true
ignoreToc: "h3,h4,h5,h6"
tags:
- r
- stats
format: 
   gfm:
      output-file: "index"
      output-ext: "md"
      variant: +yaml_metadata_block+raw_html
      df-print: tibble
# filters:
  # - quarto
  # - list-table.lua
editor:
   render-on-save: false
---

My admiration for the base R plotting system has been growing since I
started plotting complicated statistics plots. Complexity in these plots
can arise for many reasons. For one, it might simply result from the
structure of data when working with complicated statistical models
(e.g., multilevel models). Conventions are another source. People hate
changes to conventions, and there might be good reasons for it. Or maybe
not. Whatever the reasons though, the truth is that we often need to
follow the conventions, and this introduces complexity. For instance,
creating a plot in R to replicate the one originally drawn in Excel
could be extremely hard, and it is nearly always impossible to do so
with higher-level plotting packages such as `ggplot2`. To approach the
look of a plot created outside of R, life would be much easier when a
lower-level system such as the base R plotting system is utilized. Base
R lets you tweak a lot of things, but this also annoys people because
everyone always forgets the needed plotting parameters.

Below is just a cumulation of the base R plots I’ve created. It is
intended to help me search and locate the code for plotting certain
features. Hence, the remainder of this post is divided into sections by
plots, each of which consists of (1) the code, (2) the output plot, and
(3) a list of features presented in the plot.

## Interaction Plots

### Features

- Legend outside of plotting region: `par()`, `legend()`, `mar`, `xpd`,
  `inset`
- Shaded region: `polygon()`
- Custom axis (categorical axis): `axis()`
- text / label: `text()`

### Code & Plot

``` r
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
```

    # A tibble: 3 x 5
      Species      S.L   S.W   P.L   P.W
      <fct>      <dbl> <dbl> <dbl> <dbl>
    1 setosa      5.01  3.43  1.46 0.246
    2 versicolor  5.94  2.77  4.26 1.33 
    3 virginica   6.59  2.97  5.55 2.03 
    [1] "S.L" "S.W" "P.L" "P.W"

``` r
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
```

<img src="main_files/figure-commonmark/unnamed-chunk-2-1.svg"
style="width:100.0%" data-fig-align="center" />
