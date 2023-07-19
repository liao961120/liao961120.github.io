---
aliases:
- /2017/12/11/Life_Tables.html
date: '2017-12-11'
katex: true
tags:
- R
title: Constructing Life Tables with R
---




I have been using the package `dplyr` to handle with data for a while, and I thought I can use it with ease until I was stuck with my homework on **contructing a life table**. I found spreadsheets (either *Excel* or *Google Spreadsheets*) easy for handling this task, but had a hard time dealing with it in R. I think it was due to my unfamiliarity with the built-in functions and insufficient practice in R. So, I wrote this post as a review and practice of my data-wrangling skills in R. 



I will illustrate how I constructed a life table with R, and you'll find out how easy it is (and wonder how could I stumble on it).

## Load Packages

I used these packages to  construct a Life table.

```r
library(readr)
library(dplyr)
library(knitr)
```

## Load data
Load the csv file to `life_table`. The raw data contains 3 columns: **Age**, **Survivorship at Age x ($l_x$)**, and **Fecundity at Age x ($m_x$)**. I added `options(scipen=999)` to disable scientific notations.

```r
options(scipen=999)  # Disable Scientific Notation
life_table <- read_csv("life_table.csv")
life_table
```

```
# A tibble: 10 x 3
     Age        lx    mx
   <int>     <dbl> <int>
 1     0 1.0000000     0
 2     1 0.0000620  4600
 3     2 0.0000340  8700
 4     3 0.0000200 11600
 5     4 0.0000155 12700
 6     5 0.0000110 12700
 7     6 0.0000065 12700
 8     7 0.0000020 12700
 9     8 0.0000020 12700
10     9 0.0000000     0
```

## Variables to Construct

Here are the variables that need to be calculated.

|              Statistic              |     Notation      |                                 Calculation Formula                                 |
|:-----------------------------------:|:-----------------:|:-----------------------------------------------------------------------------------:|
|                                     |    $l_x m_x$    |                                                                                     |
|                                     |    $x l_x m_x$    |                                                                                     |
|                                     | $l_x m_x e^{-rx}$ |                                                                                     |
| Average survivorship<br>(age class) |       $L_x$       |                              `$L_x = (l_x + l_{x+1})/2$`                              |
|           Life expectancy           |       $e_x$       |                      `$e_x = (L_x + L_{x+1} + … + L_{max})/l_x$`                      |
|         Reproductive value          |       $V_x$       | $\displaystyle \frac{\sum_{y=x}^{max\hspace{0.3mm}x} e^{-ry} l_y m_y}{e^{-rx} l_x}$ |
|        Net reproductive rate        |       $R_0$       |                        $\sum_{all \hspace{0.3mm} x} l_x m_x$                        |
|           Generation time           |        $G$        |                 $\frac{\sum_{all \hspace{0.3mm} x} x l_x m_x}{R_0}$                 |
|     Intrinsic rate of increase      |  Approximate $r$  |                            $r \approx \frac{ln(R_0)}{G}$                            |
|     Intrinsic rate of increase      |    (True) $r$     |           $\displaystyle \sum_{all \hspace{0.3mm} x} e^{-rx}l_x m_x = 1$            |

$l_xm_xe^{-rx}$ and $V_x$ will be calculated twice for the approximate and the true $r$.

## Constructing Variables

### `mutate`: Creating new columns

Using the pipe `%>%` and the function `mutate` in package `dplyr`, I first constructed 7 new variables. Note the dependencies of the variables, so that I couldn't construct the life tables at once.

```r
life_table <- life_table %>%
    mutate("lx*mx"=lx*mx,
           "x*lx*mx"=Age*lx*mx,
           "Lx"=(lx+lead(lx))/2,
           "Lx"=replace(Lx, 10, 0),
           "ex"=rev(cumsum(rev(Lx)))/lx,
           "R0"=sum(lx*mx),
           "G"=sum(Age*lx*mx)/R0,
           "approx.r"=log(R0)/G
           )
```

Two things worth noting in the `mutate` function:

1. The code `"Lx"=(lx+lead(lx))/2, "Lx"=replace(Lx, 10, 0)`
    * `lead(lx)` shifts the whole column of $l_x$ to its next value, i.e. the column $l_x$ becomes $l_{(x+1)}$.
    * Due to `lead(lx)`, the last entry of the new column $L_x$ must be a `NA`, so I have to assign `0` to it (otherwise all calculations based on it will become `NA`s).
    
2. The code `"ex"=rev(cumsum(rev(Lx)))/lx` (This is where I was stuck)
    1. The numerator of `ex` is calculated by summing over $L_x$ to $L_{max}$, the maximum age of $L_x$. This is not so intuitive when working with R. 
    2. `rev(Lx)` reverse the order of $L_x$, and `cumsum()` is for *cummulative sum*. `cumsum(rev(Lx))` then is equivalent to *summing $L_x$ backwards* (i.e. from $L_{max}$ to $L_x$). 
    3. But since $L_x$ is reversed in the first place, `cumsum(rev(Lx))` is also in reverse order. Reversing `cumsum(rev(Lx))` with `rev()` then gives what I want.
    
### Calculating $r$ by while loop

By the **Eular-Lotka equation**, I can calculate $r$.

$$\displaystyle \sum_{all \hspace{0.3mm} x} e^{-rx}l_x m_x = 1$$

Using `while` loop and Approximate $r$ calculated earlier as the starting value for `r`, $r$ is calculated as below. 

```r
df <- as.data.frame(life_table)
r <- 0.0812198
x <- sum(exp(-r*df$Age)*df$`lx*mx`)
while (abs(x-1) >= 0.000001) {
    if (x-1>0){
        r <- r+0.00000001
    }
    else{
        r <- r-0.00000001
    }
    x <- sum(exp(-r*df$Age)*df$`lx*mx`)
    r
}
```

The rest is simple, and the logic applied is the same.

```r
life_table <- life_table %>%
    mutate(
        "approx.r"=log(R0)/G,
        "r"=r,
        "Vx"=rev(cumsum(rev(exp(-r*Age)*lx*mx)))/exp(-r*Age)*lx,
        "lx*mx*e^-rx"= lx*mx*exp(-r*Age),
        "approx.Vx"=rev(cumsum(rev(exp(-approx.r*Age)*lx*mx)))/exp(-approx.r*Age)*lx,
        "approx.lx*mx*e^-rx"= lx*mx*exp(-approx.r*Age)
    )
```
Now, I'm done constructing a life table.

## Printing pretty Life Table


```r
kable(life_table, format="markdown", align="c")
```

| $Age$ |   $l_x$   | $m_x$ | $l_x m_x$ | $x l_x m_x$ |   $L_x$   |  $e_x$   | $R_0$  |   $G$   | $Approximate$ <br>$r$ |    $r$    |   $V_x$   | $l_x m_x e^{-rx}$ | $Approximate$ <br>$V_x$ | $Approximate$ <br>$l_x m_x e^{-rx}$ |
|:-----:|:---------:|:-----:|:---------:|:-----------:|:---------:|:--------:|:------:|:-------:|:---------------------:|:---------:|:---------:|:-----------------:|:-----------------------:|:-----------------------------------:|
|   0   | 1.0000000 |   0   |  0.00000  |   0.0000    | 0.5000310 | 0.500153 | 1.2829 | 3.06727 |       0.0812198       | 0.0847117 | 1.0000010 |     0.0000000     |        1.0099103        |              0.0000000              |
|   1   | 0.0000620 | 4600  |  0.28520  |   0.2852    | 0.0000480 | 1.967742 | 1.2829 | 3.06727 |       0.0812198       | 0.0847117 | 0.0000675 |     0.2620352     |        0.0000679        |              0.2629518              |
|   2   | 0.0000340 | 8700  |  0.29580  |   0.5916    | 0.0000270 | 2.176471 | 1.2829 | 3.06727 |       0.0812198       | 0.0847117 | 0.0000297 |     0.2497000     |        0.0000299        |              0.2514499              |
|   3   | 0.0000200 | 11600 |  0.23200  |   0.6960    | 0.0000178 | 2.350000 | 1.2829 | 3.06727 |       0.0812198       | 0.0847117 | 0.0000126 |     0.1799362     |        0.0000126        |              0.1818310              |
|   4   | 0.0000155 | 12700 |  0.19685  |   0.7874    | 0.0000132 | 1.887097 | 1.2829 | 3.06727 |       0.0812198       | 0.0847117 | 0.0000067 |     0.1402737     |        0.0000067        |              0.1422467              |
|   5   | 0.0000110 | 12700 |  0.13970  |   0.6985    | 0.0000087 | 1.454546 | 1.2829 | 3.06727 |       0.0812198       | 0.0847117 | 0.0000028 |     0.0914634     |        0.0000028        |              0.0930743              |
|   6   | 0.0000065 | 12700 |  0.08255  |   0.4953    | 0.0000042 | 1.115385 | 1.2829 | 3.06727 |       0.0812198       | 0.0847117 | 0.0000008 |     0.0496567     |        0.0000008        |              0.0507081              |
|   7   | 0.0000020 | 12700 |  0.02540  |   0.1778    | 0.0000020 | 1.500000 | 1.2829 | 3.06727 |       0.0812198       | 0.0847117 | 0.0000001 |     0.0140380     |        0.0000001        |              0.0143853              |
|   8   | 0.0000020 | 12700 |  0.02540  |   0.2032    | 0.0000010 | 0.500000 | 1.2829 | 3.06727 |       0.0812198       | 0.0847117 | 0.0000001 |     0.0128978     |        0.0000001        |              0.0132632              |
|   9   | 0.0000000 |   0   |  0.00000  |   0.0000    | 0.0000000 |   NaN    | 1.2829 | 3.06727 |       0.0812198       | 0.0847117 | 0.0000000 |     0.0000000     |        0.0000000        |              0.0000000              |

Note that I edited the column names of the table in a text editor to make it display in **LaTeX** style. There is no simple `knitr` function (at least I don't know) that print out pretty displayed style text in a table generated from a data frame 
