---
aliases:
- /2018/02/24/new_md_features.html
date: '2018-02-24'
tags:
- blogging
title: Some New Features of TeXt Theme
---



I started customizing my blog template soon after I forked it from [kitian616](https://github.com/kitian616/jekyll-TeXt-theme/). The downside of customizing is that once started, there's no going back. 


I saw some new features added to the [TeXt theme](https://tianqi.name/jekyll-TeXt-theme/) recently, some of which are quite appealing to me. Since I started custimizing my blog and since I'm a layman of web page design, I have to figure out how to implement these features by myself. 

The features I implemented:

1. [**Alert Text & Circled Image**](https://tianqi.name/jekyll-TeXt-theme/test/2017/08/08/additional-styles.html): These two features are basically simple CSS styling. I added these two features a bit different from the original **TeXt theme**, since we have different file structures now. But the concept is essentially the same, and I copy-and-pasted most of the code from [`_article.content.extra.scss`](https://github.com/kitian616/jekyll-TeXt-theme/blob/master/_sass/components/_article.content.extra.scss) of the **TeXt theme** to [`_article.content.scss`](https://github.com/liao961120/liao961120.github.io/blob/master/_sass/components/_article.content.scss) of my blog's source. I couldn't figure out what some variables in `_article.content.extra.scss` refered to, so I changed all of them to plain CSS without refering to other files or variables.


2. [**mermaid**](https://tianqi.name/jekyll-TeXt-theme/test/2017/06/06/mermaid.html): Implementing **mermaid** is much more easy than the CSS things above, since I had experience with how JavaScript works on static sites ([MathJax Setup](https://liao961120.github.io/2018/01/27/mathjax.html)). But I still encountered some difficulties: I don't know how [Tian Qi](https://github.com/kitian616) (author of **TeXt theme**) implemented it by setting code chunck language to `mermaid`. Anyway, I dealt with it by using the traditional html way[^mermaid]: using `<div class="mermaid"> ... </div>` directly in markdown (see section [mermaid](#mermaid)). I put the mermaid script in [`mathjax.html`](https://github.com/liao961120/liao961120.github.io/blob/master/_includes/utils/mathjax.html) instead of creating a new `mermaid.html`.

## Alert Text

Success Text.
{: .success}

Info Text.
{: .info}

Warning Text.
{: .warning}

Error Text.
{: .error}

### Code

```kramdown
Success Text.
{: .success}

Info Text.
{: .info}

Warning Text.
{: .warning}

Error Text.
{: .error}
```

### kramdown Feature

`{: something}` is a feature unique to kramdown syntax (the markdown syntax used by Jekyll). It's very useful for making markdown more powerful. The code (e.g. `{: .error}` above) works by attaching the class, `error` to the paragraph right above it (e.g. the paragraph, `Error Text.`, above `{: .error}`. For more information, take a look at this post, [Markdown Kramdown Tips & Tricks](https://about.gitlab.com/2016/07/19/markdown-kramdown-tips-and-tricks/#classes-ids-and-attributes){:target="blank}.


## Circled Image

![](https://img.yongfu.name/assets/images/tux.png){:height="80px" width="80px"}
{:.circle}

#### Code
```kramdown
![](path-to-image){:height="80px" width="80px"} 
{:.circle}
```

## mermaid

[mermaid](https://github.com/knsv/mermaid) is a script language for generating charts from simple text. Below is an example of drawing a flow chart using **mermaid**. [Documentation for Mermaid](https://mermaidjs.github.io){: target="_blank"}.

```mermaid
graph TD
    A(text)-->B((rounded))
    A-->C
    B-->D
    C-->D
```


#### Code

````md
```mermaid
graph TD;
    A(text)-->B(rounded);
    A-->C;
    B-->D;
    C-->D;
```
````

## Notes

[^mermaid]: See the section, **Simple usage on a web page**, in [Usage](https://mermaidjs.github.io/usage.html) of mermaid documentation.

