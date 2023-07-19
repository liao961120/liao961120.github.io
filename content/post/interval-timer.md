---
aliases:
- /2021/06/06/interval-timer.html
date: '2021-06-06'
description: An interval training timer that is draggable.
tags:
- app
- JavaScript
title: A Timer for Interval Training
---


Last year I have tried home workouts since the gym was shutdown for about four months. During that time, I realized that it is harder to maintain the challenge and effectiveness of the workout since few training equipments are available at home. Later I found out that **time** is a crucial factor to increase the challenge and effectiveness of the training. By incorporating interval training to my workout schedule, I started to see the gains!
During this period, I used [intervaltimer.com][closed] to create my own interval training timer. This website (mobile app also available) allows users to build and save their own training timer. It is great, but I'm a bit upset with its user interface since it imposes many limitations on how a user can customize the intervals of the timer. In addition, some of the features on the website is locked in the associated mobile app. This has led me to the idea of creating an open source alternative to [intervaltimer.com][closed].

Recently, the outbreak of COVID-19 in Taiwan spare me quite a lot of time, and I have spent some of the time picking up JavaScript. Last Friday (Jun 4), I was randomly browsing the [HTML Drag and Drop API](https://developer.mozilla.org/en-US/docs/Web/API/HTML_Drag_and_Drop_API). This reminded me of the interval training timer. After watching a [video](https://www.youtube.com/watch?v=jfYWwQrtzzY) about building sortable drag and drop elements with vanilla JavaScript, I decided that it is time to carry out the project of building an interval timer.

It has been [almost two years](/2019/07/06/svg2png) since I wrote an app in vanilla JavaScript[^js-starter]. These days, I have been creating apps with JavaScript frameworks like Vue. It is great, but working with vanilla JavaScript is also pleasuring. Switching back and forth between two different ways of creating web apps is joyful, as it gives you the opportunity to think about programming in two quite distinct ways!


## Draggable Interval Timer

To keep the timer minimalist[^minimal], I wrote it in vanilla JavaScript, HTML & CSS (no server required of course). The most important feature of this timer is its **dragging** functionality, which gives users the flexibility of sorting the exercise blocks at will. Another useful feature is that custom timers created by the user are sharable through URLs. This makes up for the unavailability of the drag and drop API on touch screen devices (e.g. mobile phones) since a user can just create a timer on the PC/laptop and access the timer with a link on her mobile phone. Here is an [example][shareApp]!

![Draggable Interval Timer](https://raw.githubusercontent.com/liao961120/draggableTimer/main/demo/demo.gif)

The timer is available at [timer.yongfu.name](https://timer.yongfu.name) and the source code is on [GitHub](https://github.com/liao961120/draggableTimer). I'm looking forward to seeing your custom interval timers!



[^js-starter]: This is when I started to learn JavaScript **seriously**, thanks to [CS50's Web Programming with Python and JavaScript](https://cs50.harvard.edu/web/2018/).
[^minimal]: With more functionalities comes more limitations, this is what has happened with [intervaltimer.com][closed], I think.

[closed]: https://intervaltimer.com

[shareApp]: https://timer.yongfu.name/?data=_LSB__LB_%22name%22_CL_%22Get%20Ready%22_CM_%22time%22_CL_%225%22_CM_%22color%22_CL_%22_PD_38cdff%22_RB__CM__LB_%22name%22_CL_%22Sit%20up%22_CM_%22time%22_CL_%2245%22_CM_%22color%22_CL_%22_PD_ff0000%22_RB__CM__LB_%22name%22_CL_%22Rest%22_CM_%22time%22_CL_%2215%22_CM_%22color%22_CL_%22_PD_00d423%22_RB__CM__LB_%22name%22_CL_%22Push%20up%22_CM_%22time%22_CL_%2245%22_CM_%22color%22_CL_%22_PD_F76B00%22_RB__CM__LB_%22name%22_CL_%22Rest%22_CM_%22time%22_CL_%2215%22_CM_%22color%22_CL_%22_PD_00d423%22_RB__CM__LB_%22name%22_CL_%22Sit%20up%22_CM_%22time%22_CL_%2245%22_CM_%22color%22_CL_%22_PD_ff0000%22_RB__CM__LB_%22name%22_CL_%22Rest%22_CM_%22time%22_CL_%2215%22_CM_%22color%22_CL_%22_PD_00d423%22_RB__CM__LB_%22name%22_CL_%22Push%20up%22_CM_%22time%22_CL_%2245%22_CM_%22color%22_CL_%22_PD_F76B00%22_RB__CM__LB_%22name%22_CL_%22Rest%22_CM_%22time%22_CL_%2215%22_CM_%22color%22_CL_%22_PD_00d423%22_RB__CM__LB_%22name%22_CL_%22Sit%20up%22_CM_%22time%22_CL_%2245%22_CM_%22color%22_CL_%22_PD_ff0000%22_RB__RSB_
