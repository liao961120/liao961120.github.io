---
aliases:
- /2019/01/30/recreate-rbloggers.html
date: '2019-01-30'
tags:
- Travis-CI
- R-bloggers
title: Using Travis-CI to Create R-bloggers for Taiwan
---


[R-bloggers.com](https://www.r-bloggers.com) is a great platform for R users, but I sometimes feel awkward to publish posts on R-bloggers when I have things to share that are only relevant to users in Taiwan[^taiwan]. Inspired by R-bloggers, I thought maybe I could use [Travis-CI](https://travis-ci.org) and GitHub to create a blog that automatically updates its posts by retrieving them from submitted RSS feeds, just like R-bloggers.


## R-bloggers for Taiwan

The name of the blog I created is "[R部落客](https://rbloggers.github.io)", which is *R-bloggers* literally in traditional Chinese. 

The blog is served using GitHub Pages and is hosted under the organization, [Rbloggers](https://github.com/Rbloggers), on GitHub. To make the platform work, there are three repositories created -- [RSSparser](https://github.com/Rbloggers/RSSparser), [Rbloggers.github.io](https://github.com/Rbloggers/Rbloggers.github.io), and [facebook-publish](https://github.com/Rbloggers/facebook-publish), all integrated with Travis-CI.
I set up a daily [cron job](https://docs.travis-ci.com/user/cron-jobs) to run on **RSSparser** repo, which generates JSON files to be used for creating new posts.
After finishing the build, Travis-CI pushes the JSON files to `gh-pages` branch of **RSSparser** and triggers a build (using [Travis-CI API](https://docs.travis-ci.com/user/triggering-builds/)) to run on **Rbloggers.github.io** repo.
The build on **Rbloggers.github.io** then writes new posts by retrieving the JSON files saved on branch `gh-pages` of **RSSparser**.
Another build is also triggered to run on **facebook-publish** by the build on **Rbloggers.github.io**, which shares the new posts created in **Rbloggers.github.io** on Facebook (using [Facebook API](https://developers.facebook.com/docs/pages/publishing)).


I learned about the capabilities of Travis-CI in the [bookdown book](https://bookdown.org/yihui/bookdown/github.html) and the [blogdown book](https://bookdown.org/yihui/blogdown/travis-github.html). Although not directly related to R, I think most R users will benefit a lot by if they know how to use Travis-CI.



## Looking for R Bloggers & Users from Taiwan

Currently, [R部落客](https://rbloggers.github.io) is in its infancy and needs support. We are looking for R users and bloggers who read and write in traditional Chinese. 

- If you are an R user, you can follow **R部落客** via [Facebook fan page](https://www.facebook.com/twRblogger).

- If you write blog posts about R in traditional Chinese, I believe **R部落客** will be a great platform to advertise your work. You can read more about joining **R部落客** [here](https://rbloggers.github.io/join.html).




[^taiwan]: Such as a new R package about [批踢踢](https://en.wikipedia.org/wiki/PTT_Bulletin_Board_System), how to painlessly knit Chinese R Markdown documents to PDF, and how to perform Chinese word segmentation in R etc.

