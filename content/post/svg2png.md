---
aliases:
- /2019/07/06/svg2png.html
date: '2019-07-06'
description: '`svg2png`, a web page to batch convert svg images to png images.'
tags:
- app
- JavaScript
title: Convert SVGs to PNGs with Your Web Browser
---


I recently found a great [course about web programming](https://courses.edx.org/courses/course-v1:HarvardX+CS50W+Web/course/) on edX and learned a lot from it (I knew little about back-end web development and were unfamiliar with JavaScript). When I learned that it is possible to [*draw* an SVG with the mouse in the browser](https://video.cs50.net/web/2018/spring/lectures/6?t=1h35m5s), some interesting stuff came up to me   --- *can I download the SVG after I finished drawing?* I found some solutions on the web pretty easily. Meanwhile, another interesting idea came upon --- *can I use the browser to convert local SVG images to PNG images?*
It turns out that this is completely possible with pure JavaScript. I started to realize how mighty web browsers are.

As an exercise to familiarize myself with JavaScript, I implemented this idea in a simple static web page, [svg2png](https://svg2png.yongfu.name), which can convert multiple SVG images to PNG images (with options to set the resolution of the PNGs).

## No Server, Zero Dependencies

One good thing about [svg2png](https://svg2png.yongfu.name) is that the computations are all done in the browser. So compared to other online services (e.g. [this](https://svgtopng.com/)), there are no file upload limits. Also, [svg2png](https://svg2png.yongfu.name) lives on the web, so there is no need to download any thing (instead of a modern browser) before using it. 

## How It Works?

I used HTML5's `<input type='file' multiple>` to let users upload their SVGs. After that, the files are converted into [object URL](https://developer.mozilla.org/zh-TW/docs/Web/API/URL/createObjectURL)s. This allows me to load the SVG images (invisibly) with `<img src=objectURL>`, so I can get the information of these images (height and width).

The second step is to render the SVG on [Canvas](https://www.w3schools.com/html/html5_canvas.asp) with the [canvg](https://github.com/canvg/canvg) library in order to convert it to PNG later (using [`canvas.toBlob()`](https://developer.mozilla.org/en-US/docs/Web/API/HTMLCanvasElement/toBlob)).

The trick to adjust the DPI of the output PNG is by scaling the height and width of the canvas, which is handily provided by the [`scaleWidth` and `scaleHeight` options in `canvg()`](https://github.com/canvg/canvg#usage-on-the-browser). But since I have no way to get the size information of the original image directly from the File object retrieved from `<input type='file'>`, I have to load the SVG images with the `<img>` tags first.

The source code of this simple project can be found [here](https://github.com/liao961120/svg2png) on GitHub.

