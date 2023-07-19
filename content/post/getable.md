---
aliases:
- /2020/09/09/getable.html
date: '2020-09-09'
description: getable lets the user insert dynamic HTML tables in R Markdown by providing
  URLs to the data of the tables
tags:
- R
- R Markdown
- JavaScript
- R-bloggers
title: Getting Tabular Data Through JavaScript in Compiled R Markdown Documents
disqus: true
---


Recently, I have learned more about JavaScript and created a few JS web apps. This gave me the idea that we can separate the *content* and the *data* in an HTML document to make it more **dynamic**---the content stays static while the data could be updated independently without rewriting or recompiling the HTML document. This could be done by utilizing JavaScript's ability to asynchronously fetch data from the web and generate DOM elements based on these data.

I implemented this idea in my new R package [`getable`](https://github.com/liao961120/getable). Basically, `getable` lets the user insert *dynamic* HTML tables in R Markdown (HTML output only) by providing the URLs to the tables' data. Every time when the compiled HTML document is opened, the data are fetched from the web and used to generate the HTML tables. This means that the user can update the data (e.g., hosted in a public GitHub repo) without recompiling the HTML from R Markdown.
In addition to hosting data in GitHub repos or on static sites, the user could use **Google Spreadsheets** as the data store, as shown in the GIF below.

![](https://img.yongfu.name/posts/getable.gif)


## Installation

`getable` is now on CRAN, which can be installed with:

```r
install.packages("getable")
```

or, install the latest version from GitHub:

```r
remotes::install_github("liao961120/getable")
```


## Usage

`getable` comes with a template that you can import in RStudio by selecting: `File > New File > R Markdown > From Template > HTML Tables with Dynamic Data {GETable}`.

Or, you can simply run the command below in the R console:

```r
rmarkdown::draft("name_your_file.Rmd", template = "tablefromweb", package = "getable")
```

The template contains several files, of which `dfFromWeb.html`, `dfFromWeb.js`, and `dfFromWeb.css` are required for the compiled HTML to work properly (DO NOT change the RELATIVE PATHs between these files and the source Rmd). Note that you can style the appearance of the HTML tables with CSS in `dfFromWeb.css`, and if you know a lot about JS, you can even modify the code in `dfFromWeb.js` to use other JS libraries to generate the HTML tables. You can see a working example [here](https://yongfu.name/getable/demo/).


### Inserting Tables

Simply use the function `renderTable("<URL>")` in a code chunk to insert a dynamic HTML table. Remember to set the chunk option `results='asis'`:

````rmd
```{r results='asis'}
getable::renderTable("https://yongfu.name/getable/demo/data/df.csv")
```
````
