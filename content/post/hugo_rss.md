---
aliases:
- /2018/12/13/hugo_rss.html
date: '2018-12-13'
description: Customizing Hugo RSS Template for R-bloggers
tags:
- blogging
- R-bloggers
title: Customizing Hugo / Blogdown RSS Templates
---


[Blogdown](https://github.com/rstudio/blogdown) makes it easy to create Hugo blogs or personal websites, and it is becoming more and more popular in the R community. Once the blog is created, people might want to submit their blogs' RSS feeds to [R-bloggers](https://www.r-bloggers.com/). But before that can happen, one must modify the RSS template to meet the [requirements](https://www.r-bloggers.com/add-your-blog/) of RSS submission.

Due to my successful experience in [creating a new Jekyll RSS template](/2018/08/02/rblogger-criteria.html) for my blog, I thought it would be easy to customize the RSS template of Hugo blogs to make it suitable for **R-bloggers**. _I was WRONG_. Hugo has stricter rules for modifying RSS templates[^jekyll], and it took me a while to figure out how to modify the **category/tag RSS templates**.

By default, Hugo generates different RSS feeds for each section and taxonomy[^hugodoc]. I will write about how to modify _a subset of them_ to create category- or tag-specific RSS feeds for **R-bloggers**, i.e, making the `<description>` field of the RSS feed display **full content**, rather than an excerpt, of a post.


## Overwriting the default RSS Template

You won't find any RSS template files shipped with Hugo themes (at least [Hugo Acadimic theme](https://github.com/gcushen/hugo-academic) doesn't). RSS files (`index.xml`) will be generated (in `public/`) according to the default RSS template. 

To override the default RSS template **without touching the theme template**, 

1. Copy the [default RSS template](https://gohugo.io/templates/rss/#the-embedded-rss-xml)

1. Change `<description>{% raw  %}{{ .Summary | html }}{% endraw  %}</description>` to `<description>{% raw  %}{{ .Content | html }}{% endraw  %}</description>`

1. Create subdirectories in `layouts/` and save the RSS template files (name them `rss.xml`) in them (one for each subdirectory).

Putting RSS templates in different subdirectories will have effects on different kind of RSS feeds. The file name (e.g. `rss.xml`) of the template also matters and can't be arbitrary. Read Hugo's documentation on [Lookup Order for RSS Templates](https://gohugo.io/templates/rss/#lookup-order-for-rss-templates) for details[^lookup].

## An Example: Hugo Acadimic Theme

I use [Hugo Acadimic theme](https://github.com/gcushen/hugo-academic) as an example to set two kinds of RSS templates:

1. A template that causes **RSS feeds under every category** to display _full content_ of the posts
    - Browse [RSS feed](https://liao961120.github.io/Hugo-RSS/categories/r/index.xml)
    - GitHub source: [layouts/categories/rss.xml](https://github.com/liao961120/Hugo-RSS/blob/master/layouts/categories/rss.xml)

1. A template with `<category>` fields to capture all _post tags_
    - Browse [RSS feed](https://liao961120.github.io/Hugo-RSS/post/index.xml)
    - GitHub source: [layouts/post/rss.xml](https://github.com/liao961120/Hugo-RSS/blob/master/layouts/post/rss.xml)


### Directory Tree

Below is the directory structure (simplified) after adding RSS templates to **Hugo Acadimic theme**. I added and modified `rss.xml` in `/layouts/post/` and `/layouts/categories/`. Then `/docs/post/index.xml` and <code>/docs/categories/<b>r</b>/index.xml</code> get generated according to `/layouts/post/rss.xml` and `/layouts/categories/rss.xml`, respectively.


Note that `/docs` is `/public` by default, when `publishDir = "docs"` is not set in `/config.toml`. Using `/docs` allows me to [publish Hugo blog on GitHub Pages](https://gohugo.io/hosting-and-deployment/hosting-on-github/). **DO NOT add `publishDir = "docs"` in `config.toml` if you're serving the site with netlify**.

```yaml
/
├── index.Rmd
├── Hugo-RSS.Rproj
├── config.toml
├── content/
│   ├── home/
│   └── post/
│       ├── 2015-07-23-r-rmarkdown.html
│       └── 2015-07-23-r-rmarkdown.Rmd
│
├── layouts/
│   ├── post/
│   │   └── rss.xml          # Add/Modify RSS template here
│   └── categories/
│       └── rss.xml          # Add/Modify RSS template here
│
├── docs/                    # change 'public' to 'docs' in /config.toml
│   ├── index.html
│   ├── index.xml
│   ├── home/
│   ├── post/
│   │   ├── index.xml        # set in '/layouts/post/rss.xml' 
│   │   ├── index.html
│   │   ├── 2015-07-23-r-rmarkdown/
│   │   └── 2015-07-23-r-rmarkdown_files/
│   └── categories/
│       └── r/
│           ├── index.xml    # set in '/layouts/categories/rss.xml'      
│           └── index.html
└── themes/
    └── hugo-academic/
```

### Source Code

You can check out the complete directory at [GitHub](https://github.com/liao961120/Hugo-RSS) and the [web page](https://liao961120.github.io/Hugo-RSS/) generated from this repo.




[^jekyll]: For Jekyll blogs, creating a new RSS feed is just like creating a new page in the blog, and one can even use custom file names for RSS template files (such as [feed.rbloggers.xml](https://github.com/liao961120/blog/blob/master/feed.rbloggers.xml)).

[^hugodoc]: See <https://gohugo.io/templates/rss/> for more information.

[^lookup]: I have to admit that I don't completely understand Hugo's RSS template look up order. I can't predict the behaviors of Hugo precisely.