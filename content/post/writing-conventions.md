---
title: Pick and Stick to a Convention
subtitle: Personal workflow of writing with Pandoc
tags:
- thoughts
- writing-tools
- r-markdown
date: '2023-11-20'
---


Over the years, I have gradually moved from R Markdown to Pandoc's Markdown when writing documents that require fancy features such as citations and cross-references. R Markdown (and Quarto) is great, especially when the written piece involves a lot of code, but I often found it more efficient to split between the tasks of programming and writing (e.g., plotting with external scripts and then referencing the charts in the document). Furthermore, Pandoc's functionality is sufficient for my needs. In fact, I sometimes find Pandoc too powerful---once in a while, I come across some Pandoc options providing solutions to things I have dealt with some hacky javascript.

Ironically, powerful tools could result in inefficiency for novices, probably through the joint effect of memory limitation and [the paradox of choice](https://en.wikipedia.org/wiki/The_Paradox_of_Choice). We constantly forget useful features and have difficulties deciding the best way to implement a feature when there are multiple routes to achieve the goal. The syntax of Pandoc's Markdown is well-designed to specifically address some of the incompatibilities between HTML and LaTeX. However, just like all flavors of Markdown, Pandoc is also lenient about its syntax. Therefore, it's seductive for novices to mix Markdown with HTML, say when writing a blog post, and with LaTeX when targeting paged media. Repercussions become visible when you want to compile works, originally targeted at either the web or printing, into another format. 

The theme here is not minimalism in terms of a modest parsimonious set of Markdown features. Rather, I believe minimalism can be approached by picking a powerful tool, much more powerful than what one demands at the beginning, sticking to it, and mastering it. A powerful tool provides overarching principles and conventions that can only be visible and beneficial once one has mastered it. Sticking to these conventions saves the experienced from information overload, and they could instead focus on getting things done. This, I think, is the essence of minimalism. Any effort not directly invested into documenting and conveying ideas (e.g., worries about formatting, typesetting, visual appearance, etc.) acts against minimalism. 

Typesetting does help convey ideas, doesn't it, one might ask. I totally agree, and it does so by following a particular set of conventions. That's why journal publishers provide style guides and templates. A consistent style helps readers quickly grasp the messages in the papers. The problem is that authors often invest too much in typesetting, slowing down the writing process. Typesetting should be automated given its highly repetitive nature. And to automate the process, authors need to obey another set of conventions. Since the typesetting requirements of the final written products (e.g., printed books and fancy blog posts) are often quite complicated, the set of conventions for writing the source documents must also be large enough for typesetting to be automatable. This is why we need a powerful tool to provide the conventions in the first place. This is also why LaTeX has been prevalent among heavy writers---as long as one sticks to paged media, LaTeX can pretty much compile to any format on demand.

Nowadays, we often find it necessary to convert our works into both HTML and PDF. Pandoc is THE ideal tool for this, to the best of my knowledge. Given the highly incompatible nature of HTML and LaTeX styling, Pandoc does a great job of providing a common set of representations to be converted into native HTML and LaTeX elements. Whenever Pandoc does not provide such a representation, it signals that one might be asking too much. It is then a good time to rethink whether we indeed need the element, whether we require both HTML and PDF outputs, and whether we can afford additional efforts for typesetting both output formats. Luckily, I rarely find it necessary to go beyond what Pandoc has provided. With citation and bibliography provided by Pandoc [citeproc](https://pandoc.org/MANUAL.html#citations) and cross-referencing provided by [pandoc-crossref](https://github.com/lierdakil/pandoc-crossref), I have no problem writing papers and books that compile into both HTML and PDF. Instead, what I find tricky is Pandoc's overwhelming options. It would be very inefficient to look up the options every time one decides to write something. So I finally decided to document my workflow and conventions of writing with Pandoc[^pd].

[^pd]: I'm currently using Pandoc `3.1.6`, and therefore the options and settings may not be compatible with the `2.X.X` versions.


Figure
------

Figures create no issue at all as long as one sticks to PNGs or JPEGs. I love vector graphics, however. In addition, I often draw graphs with [TikZ](https://en.wikipedia.org/wiki/PGF/TikZ) that output to PDFs. It thus seems natural for me to include those PDFs as figures in my work to be compiled as a PDF document. What to do then, for the HTML outputs?

The answer lies in the mighty option [`--default-image-extension`](https://pandoc.org/MANUAL.html#option--default-image-extension). Basically, in my source document, most image links are written **without** the image extension. For instance, instead of `![](fig/foo.pdf)`, I use `![](fig/foo)` and set `--default-image-extension=pdf` when I'm compiling to PDF. If I want an HTML output, I would simply call Pandoc with `--default-image-extension=svg`, and Pandoc will locate the `.svg` version of the figures in `fig/` for me. No modification to the source document. To sum up, my figure workflow follows something like this:

1. Create graphics from individual `.tex` documents, R scripts, or anything else in a `fig/` directory.
    - For PDF graphics, I convert them into `.svg` with my custom wrapper function [`stom::pdf2svg()`](https://yongfu.name/stom/reference/pdf2png.html) around [Inkscape](https://inkscape.org).
    - For SVG graphics, I convert them into `.pdf` with a similar function `stom::svg2pdf()`.
    - For graphics of other formats (e.g., `.png`, `.jpg`, etc.), I keep them as is, and specify their paths **with extensions** in the source documents.
2. Reference the graphics **without extensions** in the image links except for those that only have a `.png` or `.jpg` version.
3. Setup two different commands or scripts for compiling the HTML and PDF outputs, respectively.
    - For the command compiling to HTML, the option `--default-image-extension=svg` is applied.
    - For the command compiling to PDF, the option `--default-image-extension=pdf` is used.


Heading
-------

I am accustomed to using level-2 headings (`##`) as the top-level heading when writing posts and articles. This makes Pandoc produce HTMLs that follow the conventions of web pages---one `h1` tag per HTML file. But things go wrong when you compile the document into PDFs (through `LaTeX` engines), especially when section numbering is enabled. In the output PDF, the top-level headings will be missing. If you turn on section numbering, you will see that the level-2 headings are given numbers starting with `0.`. To address the inconsistency, take a look at the option [`--shift-heading-level-by`](https://pandoc.org/MANUAL.html#option--shift-heading-level-by). By setting `--shift-heading-level-by=-1` for PDF outputs, I can adjust the heading levels in the output PDFs.


Citation
--------

Pandoc has native support for generating citations and bibliography when the [`--citeproc`](https://pandoc.org/MANUAL.html#citations) option is used. Pandoc's [citation syntax](https://pandoc.org/MANUAL.html#citation-syntax) is well-documented in its manual so I won't repeat it here. Another thing worth noting is the reference management software [Zotero](https://www.zotero.org) and its extension [BetterBibTex](https://github.com/retorquere/zotero-better-bibtex). We need them for customizing citation keys in the bibliography, which eases the process of citing works during writing. Search the internet for `Pandoc + Zotero` and you will find many resources with details. For example, take a look at this [document](https://github.com/laderast/magic-of-markdown/blob/master/pandoc-zotero/notes.md).


Cross-reference
---------------

Cross-referencing consists of a set of complicated functionalities. Many tools have been created for this task. For instance, in the R Markdown ecosystem, Bookdown introduces its own [crossref syntax](https://bookdown.org/yihui/rmarkdown-cookbook/cross-ref.html). Quarto has also developed another set of [crossref syntax](https://quarto.org/docs/authoring/cross-references.html) through Lua filters. Both of them build on---but go much more beyond---Pandoc. Using them thus requires familiarity with their ecosystems. A more Pandoc-centric solution is the [pandoc-crossref filter](https://github.com/lierdakil/pandoc-crossref). To use `pandoc-crossref`, one simply download an executable from GitHub and place it in one of the PATH directories. Specifying `--filter=pandoc-crossref` when calling Pandoc would then enable cross-referencing.

`pandoc-crossref`'s [documentation](https://lierdakil.github.io/pandoc-crossref/) is well-written. Be patient and take some time to read it. Personally, I find the functionalities quite overwhelming, so I wrap the configuration variables in an external [YAML file](https://github.com/liao961120/stom/blob/main/inst/template/pandoc-crossref.yaml) as described [here](https://lierdakil.github.io/pandoc-crossref/#settings-file). A minor thing to notice is `--filter=pandoc-crossref` should be **called before** `--citeproc` to avoid some potential issues.


Inline formatting
-----------------

Pandoc provides various [inline formattings](https://pandoc.org/MANUAL.html#inline-formatting) that convert nicely to LaTeX and HTML elements, such as *emphasis*, *strikeout*, *superscripts and subscripts*, *verbatim* (inline code), *underline*, *small caps*, and *highlighting*. 

It was a mixed feeling when I first learned about the small caps feature. I was excited but also regretted not looking up the small-cap feature because I had just used the tex command `\textsc{}` in a previous article. Anyway, it's cool that `[text]{.smallcaps}` gets converted to `\textsc{text}` for LaTeX and to `<span class="smallcaps">text</span>` for HTML. Many other features can similarly save you from mixing markdown with LaTeX/HTML syntax. Always be patient to read the documentation (reminding myself)!


Wrapping up
-----------

Given the tremendous amount of options required to compile a Pandoc Markdown document into outputs fitting my taste, I realized I had to wrap the massive Pandoc command into some functions. Therefore, I included [two functions](https://yongfu.name/stom/reference/pandoc_pdf.html) and [several CLI scripts](https://github.com/liao961120/stom/tree/main/inst/cli) in my personal package `stom` to help me with these massive commands.

For instance, to compile a Markdown file into a PDF, I can simply call:

```sh
pandoc_pdf writing-conventions.md
```

which generates this monstrous command under the hood:

```sh
pandoc.exe C:/Users/rd/AppData/Local/Temp/RtmpCO1Eg0/filea1d061f7a17 
    --from=markdown+tex_math_dollars+raw_tex+raw_attribute+bracketed_spans 
    --to=pdf 
    --pdf-engine=xelatex 
    --filter=pandoc-crossref 
    -M crossrefYaml="C:/Users/rd/AppData/Local/Programs/R/R-4.1.3/library/stom/template/pandoc-crossref.yaml" 
    --citeproc 
    --shift-heading-level-by=-1 
    -H C:/Users/rd/AppData/Local/Programs/R/R-4.1.3/library/stom/template/preamble.tex 
    -B C:/Users/rd/AppData/Local/Temp/RtmpCO1Eg0/filea1d015f53688 
    --template C:/Users/rd/AppData/Local/Programs/R/R-4.1.3/library/stom/template/default.latex 
    --number-sections 
    --default-image-extension=pdf 
    --variable=documentclass:amsart 
    --variable=classoption:reqno,12pt 
    -V mathspec 
    --variable=mainfont:"Adobe Caslon Pro" 
    --variable=mainfontoptions:Scale=1.28,Numbers={Lining,Proportional} 
    --variable=monofont:"Monego" 
    --variable=monofontoptions:Scale=1 
    --variable=mathfont:"Adobe Caslon Pro" 
    --variable=greek-mathfont:"GFS Porson" 
    --variable=mathfontoptions:Scale=1.28,Numbers={Lining,Proportional} 
    --variable=indent:true 
    --variable=geometry:"paperwidth=7in,paperheight=10in,text={5in,8in},left=1in,top=1in,headheight=0.25in,headsep=0.4in,footskip=0.4in" 
    -o writing-conventions.pdf
```

I'm showing this to illustrate that maintaining a document template can be quite complicated and requires an infrastructure (e.g., R package) to keep things neat. 
