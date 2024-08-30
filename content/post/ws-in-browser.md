---
title: Word Segmentation in the Browser
subtitle: "JavaScript's Intl.Segmenter"
description: "Chinese word segmentation, Intl.Segmenter, Minimalism, Jieba"
date: '2024-08-28'
katex: false
draft: false
ignoreToc: "h3,h4,h5,h6"
tags:
- javascript
- linguistics
---

I recently searched Google for "JavaScript Chinese Word Segmentation", and the only reliable links are those related to [Jieba](https://github.com/fxsjy/jieba). 
Jieba is an antique, and there are much better Chinese Word Segmentation (CWS) engines out there. 
However, these powerful---but bulky---neural network monsters become a heavy burden when faced with the reality of deployment and maintanance. Even if deployment and maintanance don't cost much, dissemination still gets hindered and becomes impossible as projects accumulate. 
A tool that needs constant maintainance is probably useless unless one is very well-funded. 

Javascript and static web pages are much more reassuring[^1]. Once they are up, they just stay there.
If we place dissemination as the top priority and could let go of other benefits of a bulky tool, the pure-JS solution nearly always wins.

[^1]: I guess this feeling resulted from my experience of working in institutions with limited funding, the numerous 404 dead links to seemingly exciting resources, and probably my one eighth Hakka origin.

So here's the problem. I'm considering building a tool for analyzing the phonetic distributions of a given Chinese text. 
At the implementation level, the tool should take a string of text as input, segment it into words, look up a dictionary to convert the words into corresponding phonetic representations, and finally compute the phonetic distributions.
A Python implementation of this will be relatively easy, and the best available CWS tool could be incorporated without much effort.
However, dissemination will be hard, particularly since the target users of the tool will not be comfortable with the detail of setting up computers.
On the other hand, if the final product is just a static web page, the users can simply use it without second thoughts.

The dilemma is usually about making things easier for the users or the developers. I'm now tilting more towards the side of implementing the tool in JS instead of Python. However, NLP-related tasks are a lot easier in Python. Jieba, as pointed out above, is probably the only CWS tool that has been [optimized for browser usage](https://github.com/fengkx/jieba-wasm). Contemplating more on the nature of the task I'm facing though, I realized that a not-so-accurate CWS engine might be tolerable . As the primary goal of the tool concerns the accuracy of the phones/syllables, not the word boundaries, it is potentially possible to utilize JS's native [`Intl.Segmenter()`](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Intl/Segmenter) for CWS. As long as most terms are correctly segmented, the mapping of their forms to pronounciations should be fine (errors are only introduced when a character resulting from incorrect CWS has different pronounciations when occuring in different words). 

Here's the code for Chinese word segmentation in JavaScript without any external dependencies:

```javascript
const segmenter = new Intl.Segmenter('zh-TW', { granularity: 'word' });
const s = `早在故事開始前，黑魔王索倫於第二紀元1600年鑄造了至尊魔戒，
以便統御其它由人類、精靈、矮人所持有的魔法戒指。
第二紀元3441年，索倫在精靈及人類最後同盟戰役中被擊敗，
伊蘭迪爾之子埃西鐸砍下了他手中的魔戒，聲稱是自己的傳家之寶。
埃西鐸後來死於半獸人的箭矢之下，魔戒因此掉入安都因河，從此消失在歷史的記載中。`;
const iterator1 = segmenter.segment(s);

const out = [];
const segged = Array.from(iterator1);
for (let i=0; i<segged.length; i++)
  out.push(segged[i].segment)

console.log(out.join('|'))
```
