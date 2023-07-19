---
aliases:
- /2018/01/27/mathjax.html
date: '2018-01-27'
katex: true
mathjax_autoNumber: true
tags:
- blogging
title: MathJax Setup
---

THIS POST IS OUTDATED

---


MathJax is a JavaScript display engine for mathematics that works in all browsers. By including MathJax support on the website, LaTeX mathematical expressions are rendered as pretty mathematical equations. 

## Add MathJax Support 

Add the code below to the `<head> ... </head>` region of every page (`.html`) to enable MathJax support. The code below allows supporting `$` and `$$` in Markdown.

```html
<script type="text/x-mathjax-config">
    MathJax.Hub.Config({
      tex2jax: {inlineMath: [['$','$'], ['\\(','\\)']]}
    });
</script>
<script type="text/javascript" async src="//cdn.mathjax.org/mathjax/latest/MathJax.js?config=TeX-MML-AM_CHTML">
</script>
```

## Equation autoNumber
Add the code below to header if you want equation auto-numbering.
```html
<script type="text/x-mathjax-config">
  MathJax.Hub.Config({
    TeX: { equationNumbers: { autoNumber: "all" } }
  });
</script>
```

### Escape Numbering

Add `\notag` to the equations to escape auto-numbering, e.g.

#### Without `\notag`
```tex
$$\frac{d}{d\,t} N_{i}= b_{i} N_{i}\left[C S\right]_{i} - d_{i} N_{i}$$
```
gives

`$$\frac{d}{d\,t} \,N_{i}= b_{i} N_{i}\left[C S\right]_{i} - d_{i} N_{i}$$`


#### With `\notag`
```tex
$$\frac{d}{d\,t} N_{i}= b_{i} N_{i}\left[C S\right]_{i} - d_{i} N_{i} \notag$$
```
gives

`$$\frac{d}{d\,t} N_{i}= b_{i} N_{i}\left[C S\right]_{i} - d_{i} N_{i} \notag$$`

### Equation Reference

Add `\label{eq:name}` to equation to give identifier. Use `$\eqref{eq:name}$` to reference the labled equation[^1].

#### Example
I added `\label{eq:N}` at the end of the equation:
```tex
$$ \frac{d}{d\,t} N_{1} =\left[ b_{1} N_{1}\,\left( S_{2}\,c_{12}+S_{1}\,c_{11}\right)- d_{1} N_{1}\, \right] \label{eq:N}$$
```

`$$\frac{d}{d\,t} N_{1} =\left[ b_{1} N_{1}\,\left( S_{2}\,c_{12}+S_{1}\,c_{11}\right)- d_{1} N_{1}\, \right] \label{eq:N}$$`

<br>

Now, adding `$\eqref{eq:N}$` in the text, e.g,
```
See $\eqref{eq:N}$ for details.
```

, gives **See $\eqref{eq:N}$ for details.**

## GitHub Page Support
You can take a look at MathJax support of my page [here](https://github.com/liao961120/liao961120.github.io/blob/master/_includes/utils/), it's in the file `mathjax.html`.

`mathjax.html` contains two part. The first starts with 
`{% raw %}{% if site.mathjax == true or page.mathjax == true %}{% endraw %}`, and the code below it is the same as the code in the section, [Add MathJax Support](#add-mathjax-support).

The second starts with `{% raw %}{% if page.mathjax2 == true %}{% endraw %}`, and the code below it is the same as the code in the section, [Equation autoNumber](#equation-autonumber).


Note the variables `mathjax` and `mathjax2`[^2] in the liquid tags. You can set them globally[^3] in `_config.yml`, or individually in the yaml header of each post/page. For example, I set the code below in `_config.yml`.

```yaml
mathjax: true
mathjax2: false 
```

This allows mathjax support **without** equation auto-numbering to be the default setting of my site. When I want auto-numbering for some post (or page), I can set `mathjax2: true` in the yaml header of the post.
 
### Some Additional Warnings

When I was typing this post, I found that **GitHub Pages** may have trouble rendering pages containing **Latex**. This is because **GitHub Pages** sometimes confuses several curly braces (`{`) written together as Jekyll **liquid tags**, which could cause page build failure. You can avoid this by not using too complicated Latex syntax, especially those with many `{` (or `}`) connected together. If you want to explicitely include **liquid tags** in your posts, look [here](https://liao961120.github.io/Markdown_Features.html) for more details.



[^1]: Note that `\label` & `\notag` **can't** be used together (You can't label a numbering-escaped equation).
[^2]: Which is in `site.mathjax`, `page.mathjax`,and `page.mathjax2`, and are all set to `true`.
[^3]: The [base template](https://github.com/liao961120/liao961120.github.io/blob/master/_layouts/blog-base.html) of my blog imports scripts from `mathjax.html`(line 18), so the whole site supports mathjax (as long as the page uses the template of my blog).

