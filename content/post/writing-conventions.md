---
title: Pick and Stick to a Convention
subtitle: My rules for writing in Pandoc's Markdown
tags:
- thoughts
- writing-tools
- r-markdown
date: '2023-11-16'
draft: true
---


Over the years, I have gradually moved from R Markdown to Pandoc's Markdown when writing documents that require fancy features such as citations and cross-references. R Markdown (and Quarto) is still great, especially when the writing pieces involve a lot of code, but I often found it more efficient to split between the tasks of programming and writing (e.g., plotting with external scripts and then reference the charts in the document). Furthermore, Pandoc's functionality is sufficient for my needs. In fact, I sometimes find Pandoc too powerful---once in a while, I come across some Pandoc variables providing solutions to things I have dealt with some hacky javascript.

Ironically, powerful tools could result in inefficiency for novices, probably through the joint effect of memory limitation and [the paradox of choice](https://en.wikipedia.org/wiki/The_Paradox_of_Choice). We constantly forget useful features we once knew and have difficulties deciding the best way to implement a feature when there are multiple routes to achieve the goal. The syntax of Pandoc's Markdown is well-designed to specifically address some of the incompatibilities between HTML and LaTeX. However, just like all flavors of Markdown, Pandoc is also lenient about its syntax. Therefore, it's seductive for novices to mix Markdown with HTML, say when writing a blog post, and with LaTeX when targeting paged media. Repercussions arrive when you want to compile some pieces of work, originally targeted at either the web or printed papers, into another format. That's when you realize if you had followed [Pandoc's MANUAL](https://pandoc.org/MANUAL.html) closely, you could have saved yourself from the headache.

The take-home message here is not minimalism in terms of NOT using fancy syntax beyond a particular flavor of Markdown. Rather, I believe minimalism can be approached by picking a powerful---much more than what one currently demands---tool at the beginning, sticking to it, and mastering it. A powerful tool provides overarching principles and conventions that can only be visible and beneficial once one has mastered it. Sticking to these conventions saves the experienced from information overload, and they could instead focus on getting things done. This, I think, is the essence of minimalism. Any effort not directly invested into documenting and conveying ideas (e.g., worries about formatting, typesetting, visual appearance, etc.) acts against minimalism. Typesetting does help convey ideas, doesn't it, one might ask. I agree, a hundred percent, and it does so by following a particular set of conventions. That's why journal publishers provide style guides and templates. A consistent style helps readers quickly grasp the messages in the papers. The problem is that authors often invest too much in typesetting, slowing down the writing process. Typesetting should be automated given the its highly repetitive nature. And to automate the process, authors need to obey another set of conventions. Since the typesetting requirements of the final written products (e.g., printed books and fancy blog posts) are often quite complicated, the set of conventions for writing the source documents must be large enough for typesetting to be automatable. This is why we need a powerful tool to provide the conventions in the first place. This is also why LaTeX has been prevalent among heavy writers. As long as one sticks to paged media, LaTeX can pretty much compile to any format on demand.

Nowadays, we often find it necessary to convert our work into both HTML and PDF. Pandoc is THE ideal tool for this, to the best of my knowledge. Given the highly incompatible nature of HTML and LaTeX styling, Pandoc did a great job of providing a common set of element representations to be converted into native HTML and LaTeX elements. Whenever Pandoc does not provide such a representation, it signals that one might be asking too much. It is then good time to rethink whether you indeed need the element, whether you require both HTML and PDF outputs, and whether you can afford typesetting for both output formats. Luckily, I rarely find it necessary to go beyond what Pandoc has provided. With citation and bibliography provided by Pandoc [citeproc](https://pandoc.org/MANUAL.html#citations) and cross-referencing provided by [pandoc-crossref](https://github.com/lierdakil/pandoc-crossref), I have no problem writing papers and books that get converted to both HTML and PDF. The problem is that they are too powerful that I used to get overwhelmed by the available options. It would be very inefficient to look up the options every time you decide to write something. So I finally decided to document my workflow and conventions of writing in Pandoc's Markdown, after various failures.


Figures
-------

Figures would cause no issue at all as long as you stick to PNGs or JPEGs. I love vector graphics, however. In addition, I often draw graphs with [TikZ](https://en.wikipedia.org/wiki/PGF/TikZ) that output as PDFs. It thus seems natural for me to include those PDFs as figures in my work to be compiled as a PDF document. What to do then, for the HTML outputs?

The answer lies in the mighty option [`--default-image-extension`](https://pandoc.org/MANUAL.html#option--default-image-extension). Basically, in my source document, the image links are written **without** the image extension. For instance, instead of `![](fig/foo.pdf)`, I use `![](fig/foo)` and set `--default-image-extension=pdf` when I'm compiling to PDF. If I want an HTML output, I would simply call pandoc with `--default-image-extension=svg`, and Pandoc will locate the `.svg` version of the figure in `fig/` for me. No modification to the source document. To sum up, my figure workflow follows something like this:

1. Create graphics from individual `.tex` documents, R scripts, or anything else in a `fig/` directory.
    - For PDF graphics, I convert them into `.svg` with my custom wrapper function [`stom::pdf2svg()`](https://yongfu.name/stom/reference/pdf2png.html) around [Inkscape](https://inkscape.org).
    - For SVG graphics, I convert them into `.pdf` with a similar function `stom::svg2pdf()`.
    - For graphics of other formats (e.g., `.png`, `.jpg`, etc.), I keep them as they are. When including them in the source document, remember to add the image extensions.
2. Reference the graphics without extensions in the image links except for those that only have a `.png` or `.jpg` version.
3. Setup two different commands or scripts for compiling the HTML and PDF outputs, respectively.
    - For the command compiling to HTML, the option `--default-image-extension=svg` is given.
    - For the command compiling to PDF, the option `--default-image-extension=pdf` is used.


Headings
--------

I am accustomed to use level-2 headings (`##`) as the top-level heading when writing posts and articles. This makes Pandoc produce HTMLs that follow the conventions of web pages---one `h1` tag per page. But things go wrong when you compile the document into PDFs (through `LaTeX` engines), espeically when section numbering is enabled. In the output PDF, the top-level headings will be missing. If you turn on section numbering, you would see that the level-2 headings are given numbers starting with `0.`. To address the inconsistency, take a look at the option [`--shift-heading-level-by`](https://pandoc.org/MANUAL.html#option--shift-heading-level-by). By setting `--shift-heading-level-by=-1` for PDF outputs, I am able to adjust the heading levels in the output PDFs.


Citations
---------

Pandoc has native support for generating citations and a bibliography when the [`--citeproc`](https://pandoc.org/MANUAL.html#citations) option is used. Pandoc's [citation syntax](https://pandoc.org/MANUAL.html#citation-syntax) is well-documented in its manual so I won't repeat it here. Another thing worth noting is the reference management software [Zotero](https://www.zotero.org) and its extension [BetterBibTex](https://github.com/retorquere/zotero-better-bibtex). We need them for customizing citation keys in the bibliography, which would ease the process of citing works when writing. Search the internet for `Pandoc + Zotero` and you will locate many resources for futher details, such as the document [here](https://github.com/laderast/magic-of-markdown/blob/master/pandoc-zotero/notes.md).


Cross-reference
---------------

Cross-referencing sections, figures, tables, equation, etc. is enabled through the [pandoc-crossref filter](https://github.com/lierdakil/pandoc-crossref). It is a feature rich project. There are many parameters one can modify to customize the looking of the cross-reference products. Since I have also tried out the crossref syntax of Bookdown and Quarto, I often found myself confused with their similar yet different syntax. I finally decided to stick with pandoc-crossref, since it is a single binary without further dependencies.


<!-- 
Cross-ref (before citeproc)
Smallcaps
 -->