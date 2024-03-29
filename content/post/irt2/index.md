---
title: Demystifying Item Response Theory (2/4)
subtitle: "IRT as Generalized Linear Models"
description: "simulation, IRT, Rasch, generalized linear model (GLM), directed acyclic graph (DAG), contrasts, dummy coding"
draft: false
date: '2023-03-06'
aliases:
    - /irt2
katex: true
mathjax: true
tags:
- r
- stats
- psychology
format: 
   gfm:
      output-file: "index"
      output-ext: "md"
      variant: +yaml_metadata_block
      df-print: tibble
editor:
   render-on-save: false
---

In [Part 1](/irt1), we went through the simplest item response model,
the 1PL model, from the perspective of simulations. Starting with item
difficulty and testee ability, we **worked forward** to simulate item
responses that mimic real-world data. Back then, we were precisely
laying out the **data generating process** that is assumed by the item
response theory. In this post, we **work backward**. We will start with
the item responses and work back toward the unobserved difficulties and
abilities, with the help of statistical models. But first, let’s
simulate the data we will be using!

``` r
logistic = function(x) 1 / (1 + exp(-x))
rbern = function( p, n=length(p) ) rbinom( n=n, size=1, prob=p )

set.seed(12)
n_item = 30   # number of items
n_subj = 60   # number of subjects
n_resp = n_subj * n_item  # number of responses

A = rnorm( n=n_subj, mean=0, sd=1 )  # Subjects' ability
D = seq( -1.6, 1, length=n_item )  # Items' difficulty

# The data
d = expand.grid( S=1:n_subj, I=1:n_item, KEEP.OUT.ATTRS = FALSE )
d$R = rbern( logistic(A[d$S] - D[d$I]) )
d$S = factor(d$S)
d$I = factor(d$I)
str(d)
```

    'data.frame':   1800 obs. of  3 variables:
     $ S: Factor w/ 60 levels "1","2","3","4",..: 1 2 3 4 5 6 7 8 9 10 ...
     $ I: Factor w/ 30 levels "1","2","3","4",..: 1 1 1 1 1 1 1 1 1 1 ...
     $ R: int  0 1 0 0 1 1 1 1 1 1 ...

In the code above, the first two lines are the definitions for the
logistic and the Bernoulli functions used previously. The second chunk
of code sets the shape of our data. This time, the simulated data is
much larger, with 30 items and 60 testees, or **subjects** (I will use
the more general term “subject” hereafter). Since we assume here that
each subject responds to every item, this gives us 1800 responses in the
data.

The subject abilities come from a normal distribution with a zero mean
and a standard deviation of one (the standard normal). The item
difficulties are equally-spaced values that range from -1.6 to 1. A
notable change from the previous post is that **number indices** are
used here for labeling items (`I`) and subjects (`S`). For simple
illustrations, letter indices are clearer. But for larger data sets,
number indices are easier to manipulate with code. Now, since `S` and
`I` are coded as integers, we need to explicitly convert them into
factors. Otherwise, the model will treat the number indices as values in
a continuous variable.

## DAGs Revisited

Before we move on to the statistical model, let me lay out the DAGs
again. The DAG on the right below is identical to the one in [Part
1](/irt1) (the left DAG here), but with a slight modification that
emphasizes the perspective from the statistical model. Here, the
observed $S$ and $I$ take place of the unobserved $A$ and $D$,
respectively. So why the difference?

<img src="dag.svg" style="max-height:150px" />

Recall that the nodes $A$ and $D$ represent the joint influences of a
subject’s ability and an item’s difficulty on the probability of success
on that item. However, the statistical model cannot notice $A$ and $D$
since they are **theoretical concepts** proposed by the IRT. What the
model “sees” is more similar to the DAG on the right. This DAG is
theoretically neutral. All it says is that the probability of success is
influenced by the particular subject and item present in an observation.
It does not further comment on the factors underlying each subject/item
that lead to the results.

Given the data and the right DAG, the statistical model estimates the
so-called **subject effects** and **item effects**. These effects will
be estimates of subject ability and item difficulty **if the IRT
assumptions are met**: when a subject and an item influence the result
**only through subject ability and item difficulty**. With the concepts
of **subject/item effects** in place, we can move on to the formulas of
the statistical model.

## Equation, Index and Annoying Things

The equations in (1) are the formulation of our model. This model is
known as the [logistic
regression](https://en.wikipedia.org/wiki/Logistic_regression), or in
GLM terms, the Generalized Linear Model of the binomial family with the
[logit link](https://en.wikipedia.org/wiki/Logit) (more on this later).
Lots of things are going on here. Don’t panic, I’ll walk you through
slowly.

$$
\begin{align}
& R_i \sim \text{Bernoulli}( P_i ) \\\\
& P_i = \text{logistic}( \mu_i )   \\\\
& \mu_i = \alpha_{[S_i]} + \delta_{[I_i]} 
\end{align} \tag{1}
$$

First, note the common subscript $_i$ to the variables above. The
presence of this common $_i$ indicates that **the equations are read at
the *observational* level**. The observational level is easier to think
of with help of the [long data
format](https://en.wikipedia.org/wiki/Wide_and_narrow_data). In this
long form of data, each row records an observation and is indexed by the
subscript $_i$. So you can think of the set of three equations as
describing the links among the variables for each observation. Note that
the long data format is also the format we have been using for the data
frames.

The last equation in (1), also related to the reading of the subscript
$_i$, deserves some elaboration, as some might feel confused about the
square brackets after $\alpha$ and $\delta$. Actually, we have already
met these brackets in [Part 1](/irt1). The brackets here serve a similar
function to R’s subset function `[]` that we have used for linking
particular ability/difficulty levels of a subject/item to the rows
(observations) of the data frame. So what the square brackets after
$\alpha$ and $\delta$ do exactly, is to “look up” the index of the
subject and item for the $_i$th observation such that the $\alpha$
corresponding to the subject and the $\delta$ corresponding to the item
could be correctly retrieved. The model can thus “know” which $\alpha$
and $\delta$ to update when it encounters an observation. For instance,
suppose we are on the 3rd row (observation) of the data, in which
$S_3 = 5$ and $I_3 = 8$. This tells the model that the observation gives
information about $\alpha_5$ and $\delta_8$. The model thus learns
something about them and updates accordingly.

I haven’t written about $\alpha$ and $\delta$ yet, but based on the
previous paragraph, you might already know what they are: $\alpha$s are
the subject effects and $\delta$s the item effects to be estimated by
the model.

Now, let me walk you through the equations from bottom to top:

- $\mu_i = \alpha_{[S_i]} + \delta_{[I_i]}$  
  No surprise here. This equation simply illustrates how the model
  computes a new variable $\mu$ from $\alpha$ and $\delta$.
- $P_i = \text{logistic}( \mu_i )$  
  The equation should look familiar. It indicates how the model maps
  $\mu$, which can range from $-\infty$ to $\infty$, to probability,
  $P$, through the logistic function.
- $R_i \sim \text{Bernoulli}( P_i )$  
  This equation describes that each observed response is generated from
  a Bernoulli distribution with probability $P_i$. Or even simpler,
  $R_i$ would be $1$ with probability $P_i$ and $0$ with probability
  $1 - P_i$.

These equations all look familiar because they are essentially
mathematical representations of the simulation we have done. Here, the
model formulation is simply simulation in reverse.

### The Logit Link

The GLM formulation of (1) is often seen in an alternative form in (2).
The only difference between (2) and (1) lies in the second equation.
Instead of the logistic function, the second equation in (2) uses the
[logit](https://en.wikipedia.org/wiki/Logit) function. What is the
logit?

$$
\begin{align}
& R_i \sim \text{Bernoulli}( P_i ) \\\\
& \text{logit}(P_i) = \mu_i        \\\\
& \mu_i = \alpha_{[S_i]} + \delta_{[I_i]} 
\end{align} \tag{2}
$$

The logit function is simply the **mirror of the logistic**. They do the
same mapping but in **reverse directions**:

- the logistic function maps real numbers to probabilities
- the logit function maps probabilities to real numbers

The logistic and the logit are **inverse functions** to each other. So
if a real number gets converted to the probability by the logistic, the
logit can convert it back to the original real, and vice versa.

``` r
logit = function( p ) log( p/(1-p) )
x = seq( -1, 1, by=0.1 )
( p = logistic(x) )  # Transformed x on probability space
```

     [1] 0.2689414 0.2890505 0.3100255 0.3318122 0.3543437 0.3775407 0.4013123
     [8] 0.4255575 0.4501660 0.4750208 0.5000000 0.5249792 0.5498340 0.5744425
    [15] 0.5986877 0.6224593 0.6456563 0.6681878 0.6899745 0.7109495 0.7310586

``` r
# Logit gives x back
logit(p)
```

     [1] -1.0 -0.9 -0.8 -0.7 -0.6 -0.5 -0.4 -0.3 -0.2 -0.1  0.0  0.1  0.2  0.3  0.4
    [16]  0.5  0.6  0.7  0.8  0.9  1.0

Some algebra would get us from the logistic to the logit:

$$
\begin{aligned}
\text{logistic}(x) &= \frac{1}{1 + e^{-x}} = p \\\\
& \Rightarrow ~~ e^{-x} = \frac{1-p}{p} \\\\
& \Rightarrow ~ -x = \text{log}(\frac{1-p}{p}) \\\\
& \Rightarrow ~~ x = -\text{log}(\frac{1-p}{p}) \\\\
& \phantom{\Rightarrow ~~ x } = \text{log}(\frac{p}{1-p}) = \text{logit}(p)
\end{aligned}
$$

There is really nothing special about the logit function. We have
learned all the important things through the logistic back in [Part
1](/irt1). I mention the logit here simply because the term is
frequently used. When people talk about GLMs, they prefer to use the
[link
function](https://en.wikipedia.org/wiki/Generalized_linear_model#Link_function)
to characterize the model. The link function, in the case of the
logistic regression here, is the logit function. It transforms the
outcome probabilities into real numbers that are modeled linearly. It’s
just the logistic, but works in the reverse direction.

## Fitting GLM

Now, we are packed with the statistical muscles to carry out the
analysis. Let’s fit the model on the data we’ve simulated. In R, this is
done through the function `glm()`. The first argument of `glm()` is the
formula, in which we specify our linear model with R’s model syntax.
There are in principle two ways, one succinct and the other tedious, to
express the formula **when there are *categorical predictors* in the
model**. I will first demonstrate the tedious one, as it exposes all the
details hidden by the succinct form. Though tedious, it saves us from
confusion.

### Dummy Coding

The formulas we specify in `glm()` (and other model fitting functions in
general) correspond pretty well to their mathematical counterparts. So
let me first present the math before we move on to the code. Lots of
things to explain here.

Equation (3.2) is rewritten from the last two equations,
$logit(P_i) = \mu_i$ and $\mu_i = \alpha_{[S_i]} + \delta_{[I_i]}$ in
(2), which I reproduce here in Equation (3.1) by combining the two
equations.

Earlier I mentioned that the square brackets after $\alpha$ and $\delta$
serve as a “look up” function to locate the relevant $\alpha$ and
$\delta$ of each subject and item in an observation. There is an
equivalent way to express the same formula without the use of these
“look up” functions, which is shown in equation (3.2). For the sake of
simplicity, let’s assume here that we have only two items (A, B) and
three subjects (J, K, L). For real data, equation (3.2) would be
extremely long.

$$
\begin{align}
  \tag{3.1} \text{logit}(\mu_i) &= \alpha_{[S_i]} + \delta_{[I_i]} \\\\
  \tag{3.2} \text{logit}(\mu_i) &= J_i \alpha_J + K_i \alpha_K + L_i \alpha_L + A_i \delta_A + B_i \delta_B
\end{align}
$$

The variables ($J_i, K_i, L_i, A_i, B_i$) in front of the $\alpha$s and
$\delta$s have a value of either 0 or 1. Here, they serve as a “switch”
that turns on the relevant $\alpha$ and $\delta$ and turns off the
others in each observation. This is easier to see with the help of the
tables below. Table 3.1 corresponds to Equation (3.1), and Table 3.2
corresponds to Equation (3.2). So, for instance, in row 2 of Table 3.2,
$K$ and $A$ are 1 while the others are 0. This turns on, or picks out,
$\alpha_K$ and $\delta_A$. As such, they would be updated by the model
when it reaches this observation. In row 2 of Table 3.1, $\alpha_K$ and
$\delta_A$ are picked out too, but not by the switches. They are
directly picked out through the *K* and *A* present in the row.

<table>
<tr>
<th>
Table 3.1
</th>
<th>
Table 3.2
</th>
</tr>
<tr>
<td>

| $_i$ | $S$ | $I$ |
|:----:|:---:|:---:|
|  1   |  J  |  A  |
|  2   |  K  |  A  |
|  3   |  L  |  B  |

</td>
<td>

| $_i$ | $J$ | $K$ | $L$ | $A$ | $B$ |
|:----:|:---:|:---:|:---:|:---:|:---:|
|  1   |  1  |  0  |  0  |  1  |  0  |
|  2   |  0  |  1  |  0  |  1  |  0  |
|  3   |  0  |  0  |  1  |  0  |  1  |

</td>
</tr>
</table>

The re-expression of Table 3.1 as Table 3.2 by coding the categories
into zeros and ones is known as **dummy coding**[^1]. Why do we need
dummy coding? In short, this is because regression programs do not
“understand” the difference between categorical and continuous
variables. They read only numbers. Dummy coding is essentially
representing categorical variables as continuous ones so that the
program would know how to deal with them. Most programs dummy code for
the users (such as `glm()`) if you give them categories. But there are
various ways to dummy code the categories and each of which results in a
different output. The interpretation of the output coefficients depends
on how the categories were coded. This confuses the novice as too much
is happening under the hood.

### Coding models: the long route

With the concepts of dummy coding in place, let’s code the model. I use
`dummy_cols()` from the `fastDummies` package to help me with dummy
coding. In the code below, I recode the item and subject variables into
zeros and ones. The result is identical to Table 3.2, except that it now
expands to 30 items and 60 subjects (90 columns in total). I won’t print
out the full dummy-coded data frame to save space. But be sure to take a
look at `d_dummy` to see how it corresponds to Table 3.2.

``` r
library(fastDummies)
d_dummy = dummy_cols( d, c("I", "S"), remove_selected_columns=TRUE )
dim(d_dummy)
```

    [1] 1800   91

``` r
colnames(d_dummy)
```

     [1] "R"    "I_1"  "I_2"  "I_3"  "I_4"  "I_5"  "I_6"  "I_7"  "I_8"  "I_9" 
    [11] "I_10" "I_11" "I_12" "I_13" "I_14" "I_15" "I_16" "I_17" "I_18" "I_19"
    [21] "I_20" "I_21" "I_22" "I_23" "I_24" "I_25" "I_26" "I_27" "I_28" "I_29"
    [31] "I_30" "S_1"  "S_2"  "S_3"  "S_4"  "S_5"  "S_6"  "S_7"  "S_8"  "S_9" 
    [41] "S_10" "S_11" "S_12" "S_13" "S_14" "S_15" "S_16" "S_17" "S_18" "S_19"
    [51] "S_20" "S_21" "S_22" "S_23" "S_24" "S_25" "S_26" "S_27" "S_28" "S_29"
    [61] "S_30" "S_31" "S_32" "S_33" "S_34" "S_35" "S_36" "S_37" "S_38" "S_39"
    [71] "S_40" "S_41" "S_42" "S_43" "S_44" "S_45" "S_46" "S_47" "S_48" "S_49"
    [81] "S_50" "S_51" "S_52" "S_53" "S_54" "S_55" "S_56" "S_57" "S_58" "S_59"
    [91] "S_60"

Now, we can fit the model with the dummy-coded data `d_dummy`. The first
argument in `glm()` specifies the formula in R’s model syntax. Based on
Equation (3.2), we include all the dummy variables in the table. In R,
this means typing out all the variables as
`R ~ S_1 + S_2 + ... + S_80 + I_1 + I_2 + ... + I_20`. That’s a lot of
work!

Luckily, R provides a handy syntax for this. Since we are including all
the variables except the outcome on the right-hand side of the formula,
we can simply type `R ~ .`. Here, the dot serves as a placeholder for
all the remaining variables not specified in the formula. We also need a
`-1` in front of the dot: `R ~ -1 + .`. The `-1` tells the model not to
estimate a global intercept, which is done by default[^2]. We don’t need
a global intercept here since we want all the effects to be presented in
the items and subjects. If a global intercept is estimated, it will
“suck out” what should have been part of the subject/item effects,
rendering the results hard to interpret.

The last thing to note in `glm()` is the `family` argument, which
characterizes the type of GLM used. Since we are fitting the data with
logistic regression, we pass `binomial("logit")` to `family`. The GLM
will then adopt the binomial distribution[^3] with the logit link to map
the right-hand linear terms to the outcome space.

``` r
m1 = glm( R ~ -1 + ., data=d_dummy, family=binomial("logit") )
summary(m1)
```


    Call:
    glm(formula = R ~ -1 + ., family = binomial("logit"), data = d_dummy)

    Deviance Residuals: 
        Min       1Q   Median       3Q      Max  
    -2.4291  -0.8850   0.2498   0.8978   2.7509  

    Coefficients: (1 not defined because of singularities)
           Estimate Std. Error z value Pr(>|z|)    
    I_1   1.926e+00  5.422e-01   3.553 0.000381 ***
    I_2   1.798e+00  5.339e-01   3.368 0.000758 ***
    I_3   1.154e+00  5.049e-01   2.286 0.022267 *  
    I_4   1.154e+00  5.049e-01   2.286 0.022267 *  
    I_5   1.351e+00  5.118e-01   2.639 0.008304 ** 
    I_6   9.686e-01  4.997e-01   1.939 0.052559 .  
    I_7   1.351e+00  5.118e-01   2.639 0.008304 ** 
    I_8   1.060e+00  5.021e-01   2.111 0.034737 *  
    I_9   9.686e-01  4.997e-01   1.939 0.052559 .  
    I_10  1.060e+00  5.021e-01   2.111 0.034737 *  
    I_11  5.368e-01  4.920e-01   1.091 0.275173    
    I_12  3.715e-01  4.905e-01   0.757 0.448848    
    I_13 -3.712e-02  4.901e-01  -0.076 0.939634    
    I_14 -3.712e-02  4.901e-01  -0.076 0.939634    
    I_15  1.263e-01  4.897e-01   0.258 0.796423    
    I_16  2.079e-01  4.898e-01   0.424 0.671244    
    I_17 -2.857e-01  4.922e-01  -0.581 0.561549    
    I_18  1.263e-01  4.897e-01   0.258 0.796423    
    I_19 -3.712e-02  4.901e-01  -0.076 0.939634    
    I_20  4.473e-02  4.898e-01   0.091 0.927249    
    I_21 -7.217e-01  5.000e-01  -1.443 0.148885    
    I_22 -1.194e-01  4.906e-01  -0.243 0.807787    
    I_23 -6.313e-01  4.979e-01  -1.268 0.204796    
    I_24 -7.217e-01  5.000e-01  -1.443 0.148885    
    I_25 -7.217e-01  5.000e-01  -1.443 0.148885    
    I_26 -7.217e-01  5.000e-01  -1.443 0.148885    
    I_27 -1.007e+00  5.082e-01  -1.981 0.047587 *  
    I_28 -1.212e+00  5.159e-01  -2.350 0.018770 *  
    I_29 -1.212e+00  5.159e-01  -2.350 0.018770 *  
    I_30 -1.961e+00  5.585e-01  -3.511 0.000447 ***
    S_1  -1.800e+00  6.322e-01  -2.847 0.004415 ** 
    S_2   1.732e+00  6.580e-01   2.632 0.008491 ** 
    S_3  -1.575e+00  6.143e-01  -2.564 0.010355 *  
    S_4  -8.194e-01  5.775e-01  -1.419 0.155962    
    S_5  -1.176e+00  5.909e-01  -1.991 0.046527 *  
    S_6   3.276e-01  5.732e-01   0.572 0.567650    
    S_7   4.966e-01  5.774e-01   0.860 0.389744    
    S_8  -3.227e-01  5.688e-01  -0.567 0.570509    
    S_9  -4.853e-01  5.705e-01  -0.851 0.394979    
    S_10  4.966e-01  5.774e-01   0.860 0.389744    
    S_11 -1.176e+00  5.909e-01  -1.991 0.046527 *  
    S_12 -1.369e+00  6.010e-01  -2.277 0.022758 *  
    S_13 -8.194e-01  5.775e-01  -1.419 0.155962    
    S_14 -1.613e-01  5.682e-01  -0.284 0.776469    
    S_15 -1.613e-01  5.682e-01  -0.284 0.776469    
    S_16 -1.176e+00  5.909e-01  -1.991 0.046527 *  
    S_17  1.253e+00  6.146e-01   2.039 0.041452 *  
    S_18  3.276e-01  5.732e-01   0.572 0.567650    
    S_19  1.046e+00  6.010e-01   1.741 0.081706 .  
    S_20 -8.194e-01  5.775e-01  -1.419 0.155962    
    S_21  4.966e-01  5.774e-01   0.860 0.389744    
    S_22  2.856e+00  8.565e-01   3.334 0.000855 ***
    S_23  1.479e+00  6.328e-01   2.337 0.019424 *  
    S_24 -9.940e-01  5.833e-01  -1.704 0.088343 .  
    S_25 -8.194e-01  5.775e-01  -1.419 0.155962    
    S_26  1.625e-01  5.704e-01   0.285 0.775661    
    S_27 -4.853e-01  5.705e-01  -0.851 0.394979    
    S_28 -3.227e-01  5.688e-01  -0.567 0.570509    
    S_29  1.680e-15  5.687e-01   0.000 1.000000    
    S_30  6.712e-01  5.831e-01   1.151 0.249706    
    S_31  6.712e-01  5.831e-01   1.151 0.249706    
    S_32  3.618e+00  1.111e+00   3.256 0.001131 ** 
    S_33 -1.613e-01  5.682e-01  -0.284 0.776469    
    S_34 -8.194e-01  5.775e-01  -1.419 0.155962    
    S_35 -4.853e-01  5.705e-01  -0.851 0.394979    
    S_36 -4.853e-01  5.705e-01  -0.851 0.394979    
    S_37  1.046e+00  6.010e-01   1.741 0.081706 .  
    S_38 -6.504e-01  5.734e-01  -1.134 0.256656    
    S_39  1.046e+00  6.010e-01   1.741 0.081706 .  
    S_40 -1.575e+00  6.143e-01  -2.564 0.010355 *  
    S_41  1.625e-01  5.704e-01   0.285 0.775661    
    S_42 -6.504e-01  5.734e-01  -1.134 0.256656    
    S_43  1.253e+00  6.146e-01   2.039 0.041452 *  
    S_44 -1.800e+00  6.322e-01  -2.847 0.004415 ** 
    S_45 -3.227e-01  5.688e-01  -0.567 0.570509    
    S_46  4.966e-01  5.774e-01   0.860 0.389744    
    S_47 -9.940e-01  5.833e-01  -1.704 0.088343 .  
    S_48  3.276e-01  5.732e-01   0.572 0.567650    
    S_49  8.536e-01  5.908e-01   1.445 0.148546    
    S_50 -3.227e-01  5.688e-01  -0.567 0.570509    
    S_51 -4.853e-01  5.705e-01  -0.851 0.394979    
    S_52 -1.613e-01  5.682e-01  -0.284 0.776469    
    S_53  6.712e-01  5.831e-01   1.151 0.249706    
    S_54  2.856e+00  8.565e-01   3.334 0.000855 ***
    S_55 -6.504e-01  5.734e-01  -1.134 0.256656    
    S_56  6.712e-01  5.831e-01   1.151 0.249706    
    S_57  1.253e+00  6.146e-01   2.039 0.041452 *  
    S_58 -9.940e-01  5.833e-01  -1.704 0.088343 .  
    S_59 -4.853e-01  5.705e-01  -0.851 0.394979    
    S_60         NA         NA      NA       NA    
    ---
    Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1

    (Dispersion parameter for binomial family taken to be 1)

        Null deviance: 2495.3  on 1800  degrees of freedom
    Residual deviance: 1927.2  on 1711  degrees of freedom
    AIC: 2105.2

    Number of Fisher Scoring iterations: 6

Take a look at the output. Something’s strange. Since there are 30 items
and 60 subjects in the data, we expect the model to return 90
coefficients, one for each subject/item effect. However, the last
coefficient, <code>S_60</code> in this case, is `NA`. The model does not
estimate this coefficient. Why?

#### Identifiability

The reason is that there are **infinite** sets of parameter combinations
that generate the same probabilities underlying our data. Thus, the
model is unable to work in reverse to infer a unique set of coefficients
from the data. To deal with this issue, R silently sets a constraint on
the parameters: it simply drops one of the parameters and estimates the
rest. When this is done, the remaining parameters become
[identifiable](https://en.wikipedia.org/wiki/Identifiability), and the
model would be able to estimate them.

But still, where did the infinity come from? Didn’t we simulate the
data? We didn’t introduce infinity, did we?

We ***did*** actually, in silence. Recall that the probability of
success on an item is determined by the difference between ability and
difficulty. Since it is the ***difference*** that matters, there could
be an infinite number of ability and difficulty pairs that yield the
same difference. By adding any common value to a pair, we get a new pair
of ability and difficulty that yields the same probability. The code
below demonstrates this. Here, I shift the ability and difficulty levels
by a common value `s`. The resulting probabilities should be identical
before and after the shift (except for a tiny floating point
imprecision). You can play with the code below by changing the value of
`s`. Identical results should always be yielded.

``` r
# Shift A/D by a common factor
s = 5
A2 = A + s
D2 = D + s

p1 = logistic( A[d$S] - D[d$I] )    # Probabilities before shift
p2 = logistic( A2[d$S] - D2[d$I] )  # Probabilities after shift
sum( abs(p1 - p2) )  # Should be extremely close to zero
```

    [1] 9.453549e-14

The way R deals with this issue of identifiability is not preferable
since we want to recover the parameters in our simulation (i.e., the set
of parameters without the shift). To get around R’s default treatment,
we have to impose constraints on the parameters ourselves.

Recall that subject abilities are generated according to a standard
normal distribution in the simulation. Since the standard normal has a
mean of zero, the **expectation of the sum of subject abilities is
*zero***. We can use this expectation as a constraint to the parameters
by constraining the subject effects to **sum to zero**. This constraint,
however, **does not** scale the model’s estimates to perfectly match the
true parameters since the true subject abilities never exactly sum to
zero in a single run of the simulation. However, the relative scale
would be close enough for the simulated parameters to be comparable to
those recovered by the model. Later in the next post, when the
**generalized linear mixed model** is introduced, you will see that
there is no need to impose such a constraint. The constraint is
naturally included through the model’s assumptions. The estimated
subject effects then, do not need to sum to zero. Subject effects would
be assumed to result from a normal distribution with a mean of zero.

Through dummy coding, we can impose the sum-to-zero constraint on the
subject effects. I illustrate this with the example previously presented
in Table 3.2, where there are only 3 subjects and 2 items. Table 3.3 is
re-coded from Table 3.2, in which the sum-to-zero constraint is imposed.

The sum-to-zero constraint is imposed by dropping one of the subjects
and coding the remaining as `-1` for all the observations where the
dropped subject is originally coded as `1`. This is shown in Table 3.3,
where I drop subject $L$ (hence the `-` in the column) and code the 3rd
row of $J$ and $K$ as `-1`.

<table>
<tr>
<th>
Table 3.2
</th>
<th>
Table 3.3
</th>
</tr>
<tr>
<td>

| $_i$ | $J$ | $K$ | $L$ | $A$ | $B$ |
|:----:|:---:|:---:|:---:|:---:|:---:|
|  1   |  1  |  0  |  0  |  1  |  0  |
|  2   |  0  |  1  |  0  |  1  |  0  |
|  3   |  0  |  0  |  1  |  0  |  1  |

</td>
<td>

| $_i$ | $J$ | $K$ | $L$ | $A$ | $B$ |
|:----:|:---:|:---:|:---:|:---:|:---:|
|  1   |  1  |  0  | \-  |  1  |  0  |
|  2   |  0  |  1  | \-  |  1  |  0  |
|  3   | -1  | -1  | \-  |  0  |  1  |

</td>
</tr>
</table>

With the coding scheme in Table 3.3, the estimated effect of subject $L$
can be reconstructed from the remaining subject effects returned by the
model. Since the sum of all subject effects is zero, the effect of
subject $L$ will be the negative of the others’ sum. This might seem a
bit confusing. But notice that the sum-to-zero constraint
**simultaneously applies to all effects in the variable**. Once the
effect of the dropped category is reconstructed, each effect will also
be the negative sum of the remaining effects.

Let’s impose this constraint on the data with code. Here, I will drop
the first subject `S_1`. You can choose any subject you like to drop,
and the result will be identical. The code from line 3 to 5 below pick
outs the rows where `S_1` is coded as `1` and recode them as `-1` on all
the subject columns. After the re-coding, the final line of code then
drops `S_1`.

``` r
d_dummy2 = d_dummy
toDrop = "S_1"
allCategories = startsWith( names(d_dummy2), "S_" )
idx_recode = which( d_dummy2[[toDrop]] == 1 )
d_dummy2[idx_recode, allCategories] = -1
d_dummy2[[toDrop]] = NULL
```

Now, let’s refit the model with this constraint-coded data. I simply
replace `d_dummy` with `d_dummy2` in the `data` argument. Everything
else is the same.

``` r
m1.1 = glm( R ~ -1 + ., data=d_dummy2, family=binomial("logit") )
# summary(m1.1)
```

If you print out the coefficients of the fitted model, you will see that
the result is what we expected. The model returns 89 coefficients, which
match the number of the predictor variables we passed in. No coefficient
is dropped. We already dropped it for the model. And since we dropped
the predictor in a principled way, we know how to reconstruct it. The
effect of the dropped `S_1` will be the negative sum of the remaining.
This is shown in the code below, which reconstructs all the item/subject
effects from the model’s coefficients.

``` r
eff = coef(m1.1)
item_eff = eff[ startsWith(names(eff), "I_") ]
subj_eff = eff[ startsWith(names(eff), "S_") ]
# Reconstruct S_1 from the remaining subject effects
subj_eff = c( -sum(subj_eff), subj_eff )
```

We can now plot the estimated effects against the true parameter values
from the simulation. The figures below plot the estimated effects on the
x-axis and the true parameters of the y-axis. The dashed line has a
slope of 1 without an intercept. This line indicates perfect matches
between the truth and the estimates. Notice that for the figure on the
right, I reverse the signs of the item effects to match the scale of
item difficulty. This is necessary since $D$ is subtracted from $A$ in
the simulation. In other words, the effect of difficulty assumed by the
1PL model is **negative**: the larger the difficulty, the less
probability of success on the item. However, `glm()` allows only
additive effects. The effects in the model are summed together to yield
predictions. Hence, the item effects estimated by `glm()` will be the
negative of those assumed by the 1PL model.

``` r
plot(  subj_eff, A, pch=19, col=4 ); abline(0, 1, lty="dashed" )
plot( -item_eff, D, pch=19, col=2 ); abline(0, 1, lty="dashed" )
```

<div class="two-column">

<img src="part2_files/figure-commonmark/unnamed-chunk-10-1.svg"
data-fig-align="center" />

<img src="part2_files/figure-commonmark/unnamed-chunk-10-2.svg"
data-fig-align="center" />

</div>

As seen in both figures, the dots scatter around the lines quite
randomly, which indicates that the model does recover the parameters. To
have a clearer view of the estimates’ accuracy, let me plot some more.

``` r
# Set figure margins
par(oma=c(0,0,0,0))  # outer margin
par(mar=c(3, 4, 3, 1.6) )  # margin

true_eff = c(D, A)
est_eff = c(-item_eff, subj_eff)
n_param = n_item + n_subj
cols = c( rep(2, n_item), rep(4, n_subj) )

y_lim = max( abs(c(true_eff, est_eff)) )
y_lim = c( -y_lim-.1, y_lim+.1 )
plot( 1, type="n", ylim=y_lim, xlim=c(1, n_param+1), ylab="Effect" )
abline( h=0, lty="dashed", col="grey" )
abline( v=n_item+0.5, col="grey")
points( true_eff, pch=19, col=cols )
points( est_eff, col=cols )
for (i in 1:n_param)
  lines( c(i, i), c(true_eff[i], est_eff[i]), col=cols[i] )
mtext( c("Items", "Subjects"), at=c(9, 61), padj = -.5, col=c(2, 4) )
```

<img src="part2_files/figure-commonmark/eff-est-1.svg"
style="width:100.0%" data-fig-align="center" />

In the plot above, I overlay the estimated effects onto the true
parameters. The dots are the true parameters and the circles are the
model’s estimates. The vertical lines connecting the dots and the
circles show the distances between the truth and the estimates. It is
obvious from the plot that, compared to item difficulties, subject
abilities are harder to estimate, as the distances to the truth are in
general larger for subject estimates. This is apparent in hindsight, as
each item is taken by 60 subjects whereas each subject only takes 30
items. Hence, the estimation for the items is more accurate, compared to
the subjects, as there are more data to estimate each.

The effect of manipulating the number of subjects and items is revealed
in the plot below. Here, I refit the model with data that have the
subject and the item numbers flipped. The subject abilities are now
estimated more accurately than the item difficulties. You can experiment
with this to see how the estimation accuracy changes with different
combinations of subject/item numbers. The functions `sim_data()` and
`plot_estimate()` in
[`estimate-acc.R`](https://github.com/liao961120/stom/blob/main/inst/blog/irt/estimate-acc.R)
can help you with this.

<img src="part2_files/figure-commonmark/unnamed-chunk-11-1.svg"
style="width:100.0%" data-fig-align="center" />

### Coding models: the easy route

We have gone through a long route, along which we have learned a lot.
Now, you are qualified to take the easy route: to use R’s handy function
for dummy coding. Note that this route won’t be easy at all if you never
went through the longer one. Rather, confusion is all you will get, and
you will have no confidence in the model you coded. Simple code is
simple only for those who are well-trained. So now, let’s fit the model
again. This time, we take the highway.

The trick for controlling how the model functions dummy code the
categorical variables is to use the `contrasts()` function to set up the
preferred coding scheme. In the code below, I pass the number of the
categories in $S$ (i.e., `n_subj`) to `contr.sum()`, which is a helper
function that codes the subjects in the exact same way as we did in
Table 3.3 (execute `contr.sum(3)` and you will see a table that
corresponds exactly to Table 3.3).

After the coding scheme is set, we can express categorical predictors in
the model formula directly. Everything else is the same except the last
line. Previously, I demonstrated dummy coding by dropping the first
subject in $S$. Here, `contr.sum()` drops the last subject by default.
Thus, the code for constructing the dropped subject is slightly
different here.

``` r
dat = d
# Drop the last S and impose sum-to-zero constraint on S
contrasts( dat$S ) = contr.sum( n_subj )
m1.2 = glm( R ~ -1 + I + S, data=dat, family=binomial("logit") )
eff = coef(m1.2)
item_eff.m1.2 = eff[ startsWith(names(eff), "I") ]
subj_eff.m1.2 = eff[ startsWith(names(eff), "S") ]
subj_eff.m1.2 = c( subj_eff.m1.2, -sum(subj_eff.m1.2) )
```

Now we have the estimated effects from the model, let’s check the
results. The figure below plots the current estimates (`m1.2`) against
previous ones (`m1.1`). The estimates from the two models agree, which
confirms that the second model is correctly coded.

``` r
est_m1.1 = c( item_eff, subj_eff )
est_m1.2 = c( item_eff.m1.2, subj_eff.m1.2 )
plot( 1, type="n", xlim=c(-2.5,2.5), ylim=c(-2.5,2.5), xlab="m1.2", ylab="m1.1" )
abline( 0,1, lty="dashed", col="grey" )
points( est_m1.2, est_m1.1, pch=19, col=cols )
```

<img src="part2_files/figure-commonmark/unnamed-chunk-13-1.svg"
style="width:100.0%" data-fig-align="center" />

## What’s next?

This post is lengthy, but not because it is hard. Rather, the concepts
presented are fairly simple. The post is lengthy because we got used to
texts that hide details from the readers. The text here does the
opposite: it presents all the **necessary details** to get the
statistical model working, without confusion. People often assume that
hidden details are trivial. But more often, it is just because writers
are too lazy to present the details. Statistics is hard partly because
it is loaded with details that are hidden and ignored. When details get
ignored long enough, they accumulate to become entangled and
uncrackable. Coding, again, is here to help. It dissolves the fuzziness
that otherwise accumulates and hinders understanding.

In [Part 3](/irt3), we move on to **Generalized Linear Mixed Models**,
which are extensions to GLMs that improve estimation and efficiency by
harnessing the information from common group memberships in the data. We
will use the same data, and the text would be much shorter, I hope.
Seeya!

[^1]: I use *dummy coding* as a general umbrella term to cover all
    systems for coding categorical variables. In R, what is known as
    “treatment coding” (`contr.treatment`) is sometimes called “dummy
    coding” by others. Here, I follow R’s convention. When “dummy
    coding” is used, I always refer to the general sense of re-coding
    categories as numbers (not necessarily zeros and ones).

[^2]: This default behavior of estimating a global intercept makes sense
    in the context of continuous predictors, such as the simple linear
    model shown below. In this case, we can succinctly express the
    formula as `y ~ x` in R’s model syntax. The estimate of the global
    intercept $\alpha$ would be given as the intercept coefficient in
    the model output.

    $$
    \begin{aligned}
    y_i &\sim \text{Normal}(\mu_i, \sigma) \\\\
    \mu_i &= \alpha + \beta x_i
    \end{aligned}
    $$

[^3]: I haven’t mentioned the [binomial
    distribution](https://en.wikipedia.org/wiki/Binomial_distribution)
    before. The binomial distribution is the extension of the Bernoulli
    distribution to $n$ independent trials. So if you repeat the
    Bernoulli process $n$ times and sum the outcomes, say, you toss the
    coin $n=10$ times and record the number of heads observed, the
    distribution of outcomes would follow a binomial distribution with
    parameters $n$ and $p$. So the Bernoulli distribution is simply a
    special case of the binomial distribution where $n=1$.
