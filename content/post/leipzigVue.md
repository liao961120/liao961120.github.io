---
aliases:
- /2020/02/22/leipzigVue.html
date: '2020-02-22'
description: ''
subtitle: ''
tags:
- app
- JavaScript
- Linguistics
title: Recreating Leipizig.js with Vue for Interlinear Glossing
---


I noticed [Leipzig.js](https://bdchauvette.net/leipzig.js) from [George Moroz](https://github.com/agricolamz)'s GitHub activity (he starred [`bdchauvette/leipzig.js`](https://github.com/bdchauvette/leipzig.js/) a few months ago). This JS library is fantastic, and at the moment I saw it, I came up with an idea of building a web app facilitating interlinear glossing. 
During Chinese New Year, I finally started on the project. I thought it would be easy since I had some experience with Vue.js before[^viewmark], but it turned out that `leipzig.js` wasn't designed to work with Vue. 


## Dynamic Input Interface

What I had in mind was a web app that, while the user is typing, the rendered glosses get showed **synchronously** in another panel. Vue's conventional way of doing this is by creating a two-way data binding (`v-model`) to capture the user's input and dynamically render the HTML content based on the inputted data. This conflicts with `leipzig.js` since it only provides a high level function ([`Leipzig()`](https://github.com/bdchauvette/leipzig.js/wiki/Documentation)) to modify existing DOM elements to construct the glosses. Calling `Leipzig()` multiple times (without erasing the already rendered HTML) would break the DOM elements, which makes the function hard to work together with Vue[^leipzig-demo].

After multiple failures of making `Leipzig()` to work with Vue, I decided to abandoned `leipzig.js` and recreate its functionality with Vue. This wasn't as terrifying as it may seem, since I can use [`leipzig.js`'s CSS rules](https://github.com/bdchauvette/leipzig.js/blob/master/dist/leipzig.css) directly to help me align the rendered DOM elements by Vue. What I had to do was making sure that Vue generates [the exact same HTML structure](https://github.com/bdchauvette/leipzig.js/wiki/Documentation#configclasses) as `leipzig.js`'s rendered glosses. The resulting input interface is shown in the GIF below.

![Leipzig.js rebuilt with Vue](https://img.yongfu.name/gif/leipzig-vue.gif)

The source code of this vue component can be found in [`Leipzig.vue`](https://github.com/liao961120/gloss/blob/master/src/components/Leipzig.vue).


## Other Parts of the App

There are several advantages of adopting Vue instead of using traditional JS approaches to build the app. Since what I wanted to build was an app that can also **store, manage, and export glosses** for the user, I needed a framework to help me manage this complexity (e.g., [Vuex](https://github.com/liao961120/gloss/blob/master/src/views/Edit.vue)), and Vue provides a good and manageable way to build a complex web app. After learning Vuex and experiencing some failures in my previous [Vue project](https://github.com/liao961120/viewMark) (due to increasing complexity as the app grows larger), I'm pretty sure that I could build a better app with less complexity this time. But just when I was moving forward to other parts of the app, I was stuck by other work to do, so I'm currently not developing this app. Currently, the only usable part of this app is its dynamic input interface for previewing glosses.


[^leipzig-demo]: Though it is possible to create a dynamic input experience with `leipizig.js` with a more traditional JS approach. You can read the [source code](https://bdchauvette.net/leipzig.js/theme/js/demo.js) of this [Live demo of Leipzig.js](https://bdchauvette.net/leipzig.js/demo/) to find out how it works!

[^viewmark]: In 2019 summer, I learned Vue.js on [The Net Ninja's YouTube channel](https://www.youtube.com/playlist?list=PL4cUxeGkcC9gQcYgjhBoeQH7wiAyZNrYa) and built a [markdown editor](https://viewmark.yongfu.name) for fun.
