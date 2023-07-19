---
aliases:
- /2019/04/29/xaringan_tips.html
date: '2019-04-29'
description: Tips to Reduce the Complexity of Slide Making with Xaringan
tags:
- R Markdown
- R-bloggers
title: Tips to Reduce the Complexity of Slide Making with Xaringan
disqus: true
---


Although I'm a strong believer in R Markdown, I'm not so sure about it in the realm of slide making. After using GUI slide making tools such as Powerpoint or Google Slides for years, it is not easy to get used to making slides with markdown, since it requires additional processing in the brain -- the conversion between images in the brain and the markup language to create them on the slides.
[`xaringan::inf_mr()`](https://yihui.name/en/2019/02/ultimate-inf-mr/) greatly reduces this burden on the brain, but one serious drawback still persists. When making slides with Markdown, the source document often gets very long. I frequently found myself lost in the source document (after scrolling up and down), not knowing which part of the slide is it that I'm looking at[^markup-lang].
To be fair, there are great things about making slides with markdown, for example, it's easier to manage and reuse images through URLs, and markdown is convenient for formatting code (automatic syntax highlighting).

I have been making a lot of slides with Xaringan lately. After spending hours on Xaringan, I began to have more faith in making slides with markdown because I figured out some tips to reduce the pain caused by markup langauges. The idea is simple -- reduce the length and complexity of the source R Markdown document. `knitr` is my friend here.

[^markup-lang]: This is the major drawback of markup languages compared to GUI authoring tools. Although markdown itself is designed to deal with this drawback (i.e. the too-complicated HTML syntax), the inherently complex structure of slideshows still complicates the source document of the slides writen in markdown.


## Use Several Source Documents

[bookdown](https://github.com/rstudio/bookdown) uses several Rmd files to generate a book. The same idea can be used in Xaringan, and here are some advantages I can think of:

- By splitting the source document into several meaningful sub-documents, you can locate particular parts of your slide faster (the so-called "[chunking](https://en.wikipedia.org/wiki/Chunking_(psychology))").

- Your slides can be easily reused, since you can copy a part of your slides by choosing the relevent Rmd file(s). (Not copy-and-pasting text from the parts you want in one lengthy Rmd file)


### Child Document

To use several source Rmd documents to generate a single Xaringan (or any R Markdown) output, use knitr chunk option `child` to include other Rmd files in a Rmd document. For example, I would create one `index.Rmd` and several Rmd files with meaningful names (e.g., `opening.Rmd`, `intro-github.Rmd`, `contact.Rmd`, etc.):

```yml
my-slide/
├── index.Rmd
├── opening.Rmd
├── intro-github.Rmd
├── contact.Rmd
├── html-table.txt
├── img/
└── addons/
    ├── custom.css
    └── macros.js
```

The chunk option `child` is then used in `index.Rmd` to include other `*.Rmd`:

````yaml

```{r setup, include=FALSE}
knitr::opts_chunk$set(echo = FALSE)
options(knitr.duplicate.label = 'allow')
```

```{r child='opening.Rmd'}
```

```{r child='contact.Rmd'}
```
````

## Complex Markups in Independent Files

Sometimes we may want to put cool things in the slides that can only be created from HTML syntax, for example, the table below (generated from [TablesGenerator.com](https://www.tablesgenerator.com/html_tables#)):


<table style="border-collapse:collapse;border-spacing:0;margin:0px auto" class="tg"><tr><th style="font-family:Arial, sans-serif;font-size:14px;font-weight:normal;padding:10px 5px;border-style:solid;border-width:1px;overflow:hidden;word-break:normal;border-color:#343434;text-align:center" colspan="2" rowspan="2"></th><th style="font-family:Arial, sans-serif;font-size:14px;font-weight:bold;padding:10px 5px;border-style:solid;border-width:1px;overflow:hidden;word-break:normal;border-color:#343434;text-align:center" colspan="2">Heuristic</th></tr><tr><td style="font-family:Arial, sans-serif;font-size:14px;padding:10px 5px;border-style:solid;border-width:1px;overflow:hidden;word-break:normal;border-color:#343434;background-color:#efefef;text-align:center">plausible</td><td style="font-family:Arial, sans-serif;font-size:14px;padding:10px 5px;border-style:solid;border-width:1px;overflow:hidden;word-break:normal;border-color:#343434;background-color:#efefef;text-align:center">implausible</td></tr><tr><td style="font-family:Arial, sans-serif;font-size:14px;padding:10px 5px;border-style:solid;border-width:1px;overflow:hidden;word-break:normal;border-color:#343434;font-weight:bold;text-align:center" rowspan="2">Syntax-driven</td><td style="font-family:Arial, sans-serif;font-size:14px;padding:10px 5px;border-style:solid;border-width:1px;overflow:hidden;word-break:normal;border-color:#343434;background-color:#efefef;text-align:center">plausible</td><td style="font-family:Arial, sans-serif;font-size:14px;padding:10px 5px;border-style:solid;border-width:1px;overflow:hidden;word-break:normal;border-color:#343434;background-color:#9abad9;text-align:center"><span style="text-decoration: line-through;">P600</span><br><span style="text-decoration: line-through;">N400</span></td><td style="font-family:Arial, sans-serif;font-size:medium;padding:10px 5px;border-style:solid;border-width:1px;overflow:hidden;word-break:normal;border-color:#343434;background-color:#9abad9;text-align:center"><span style="color:rgb(254, 0, 0)">✗</span></td></tr><tr><td style="font-family:Arial, sans-serif;font-size:14px;padding:10px 5px;border-style:solid;border-width:1px;overflow:hidden;word-break:normal;border-color:#343434;background-color:#efefef;text-align:center">implausible</td><td style="font-family:Arial, sans-serif;font-size:14px;padding:10px 5px;border-style:solid;border-width:1px;overflow:hidden;word-break:normal;border-color:#343434;background-color:#9abad9;text-align:center">P600</td><td style="font-family:Arial, sans-serif;font-size:14px;padding:10px 5px;border-style:solid;border-width:1px;overflow:hidden;word-break:normal;border-color:#343434;background-color:#9abad9;text-align:center">N400</td></tr></table>

This table looks simple, but it is generated by a 2728-character-long HTML code, which greatly increases the length and complexity of the source document. To make the source document cleaner, you can put code of these kinds in separate text files and include them into the R Markdown source document by `knitr::asis_output(readLines('html-table.txt'))`[^readlines] and R Markdown [inline code](https://rmarkdown.rstudio.com/lesson-4.html) <code>`r `</code>:

```markdown
A table generated from
[TablesGenerator.com](https://www.tablesgenerator.com/html_tables#):

`r knitr::asis_output(readLines('html-table.txt'))`
```

[^readlines]: Note that there is only one line in `html-table.txt` so `readLines()` returns a character vector of length 1. If there are multiple lines in the text file, one needs to use `paste(readLines('html-table.txt'), collapse = '\n')` to properly print out the text file.


## remark.js Built-in Functionalities

[remark.js](https://github.com/gnab/remark) actually provides useful functionalities to help reduce the complexity of the slides. **READ THE DOCs**, and it might save you a great deal of time. [Xaringan](https://github.com/yihui/xaringan/wiki) and [remark.js](https://github.com/gnab/remark/wiki) both provide good wiki pages, and I regret I read them too late -- after I spent a lot of time copy-and-pasting and made my Rmd source document uglier.

Below are some notes extract from Xaringan & remark.js Wiki pages. They serve as quick references (for myself) and aren't meant to be detailed. Again, **READ THE DOCs**!


### Configuration


Xaringan Configuration (remark has a more thorough [documentation](https://github.com/gnab/remark/wiki/Configuration)) is set in YAML frontmatter:

```yml
output:
  xaringan::moon_reader:
    nature:
      ratio: "16:10"
      beforeInit: ["addons/macros.js", "https://platform.twitter.com/widgets.js"]
      highlightLines: true
      highlightSpans: false
      navigation:
        scroll: false
    css: [default, default-fonts, addons/custom.css]
    yolo: false
    seal: true
```

### remark Special Syntax

- [name](https://github.com/gnab/remark/wiki/Markdown#name): Adding ID to a slide
  
  ```
  name: about
  
  ## About
  ```
  
  - reference with `see [About](#about)`
  
  
- [count](https://github.com/gnab/remark/wiki/Markdown#count)

  ```
  count: false
  
  This slide will not be counted.
  ```
  
- [template](https://github.com/gnab/remark/wiki/Markdown#template)

      name: template-slide

      Some content.

      ---
      template: template-slide

      Content appended to template-slide's content.

- [layout](https://github.com/yihui/xaringan/wiki/Slide-layouts)

### Macros

- Image with Absolute postition:
  
  Define macros in `addons/macros.js`:  
  ```javascript
  remark.macros['abs'] = function(width="30%", left="85%", top="15%", cl="") {
  var url = this;
  return '<img src="' + url + '" style="position:absolute;left:' + left + ';top:' + top + ';width:' + width + '" class="' + cl + '" />';
  };
  ```

  Use it in markdown:  
  ```markdown
  ![:abs width, left, top](url)
  
  ![:abs 30%, 50%, 0%](url)
  
  <img src="url" style="position:absolute; width:30%; left:50%; top:0%;">
  ```
