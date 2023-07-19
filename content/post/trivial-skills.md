---
aliases:
- /2019/01/04/trivial-skills.html
date: '2019-01-04'
description: ''
tags:
- thoughts
- 中文
title: 大四老屁股的一些小技巧
---


在似乎完成了很多但又似乎沒達成什麼的感覺中，大學生活逐漸步入尾聲。回顧這幾年學到的東西，沒幾個可以拿出來說嘴，更別說是對每個人都有用的能力或技巧。不過有些小技巧似乎過於「微不足道」，反而沒人意識到這些技巧也是花時間摸索出來的。

<!--more-->

沒有指引之下的學習需要經過不少試誤、耗費許多時間精力。這篇文章將記錄這三年多來學會的一些「微不足道」的小技巧。再不寫下來，我或許會把這些事情視為理所當然，忘記這背後是多少經驗的累積。

## 影印書籍

大一時就開始去影印店印一些課本[^textbook]，當時什麼都不知道，只是將 PDF 檔交給影印店。隨著印過越來越多書才逐漸抓住印書時該注意的一些小地方：

1. 減輕重量：
    - 書要印成 B5，A4 太大過重
    - 書的頁數不要超過 500 頁，若超過可分成兩個 PDF 檔印

1. 頁數增減：
    - Preface, Acknowledgment 可以刪掉，但 References 和 Index 不建議刪掉
    - 如果 References 和 Index 很多頁，可以將[兩面合併為一面](https://online2pdf.com/multiple-pages-per-sheet)
    - 如果一本書分成兩部份印，最好兩本都保留 Contents, References 和 Index。亦即，盡量讓每部份的書 self-contained

1. 美觀：
    - 注意奇偶數頁碼：

        - 
            如果你曾看過[書的 PDF 檔](https://bookdown.org/yihui/blogdown/blogdown.pdf)，或許曾注意到**有些頁面會刻意留白**。這些空白頁是為了確保**奇數頁碼的頁面永遠在(翻開的)書的右邊，偶數頁碼的頁面永遠在書的左邊**。此外，新章節(Contents, Chapter x, References 和 Index 等都算章節)通常以奇數頁開頭[^two-sided]。  
            若頁碼是在頁面的正中間下方(而非角落)，那通常就沒有上述的特徵。

            在增減書的頁面時(特別是刪除 Preface 和 Acknowledgment 頁面)，有時需在新章節開始前插入或刪除空白頁面，以維持**奇數頁碼的頁面永遠在(翻開的)書的右邊，偶數頁碼的頁面永遠在書的左邊**。
    
    - 裁切 PDF：
    
        - PDF 的頁邊空白過大或有不重要的字串時，可以使用 [briss](https://sourceforge.net/projects/briss/) 之類的軟體一次裁切所有的頁面。

    - 如果喜歡，可以[自製封面](https://docs.google.com/document/d/1jB0ceBE0cFDyaNDQ5t-DmGujxHlHj1WGJYRXRnZgPNg/edit?usp=sharing)

    - 請老闆**印書背**

1. 如果是台大學生或住公館附近，推薦[遠雄影印](https://goo.gl/maps/UtUB8QnYgMv)


## 寫卡片

儒家文化下的讀書人要精通琴棋書畫，但我從未看過我們這代精通四藝[^four]的人，我自己更是一項都不行。四藝當中，我認為最重要的是「書」。儘管平時並不如何在意自己字醜，但要寫卡片時(尤其是*重要的卡片*)，才發現字醜真的很要命。

對於許多字寫不漂亮的人(至少我是這樣)，很大一部分原因是無法掌握每個字所需佔據的空間。我在寫卡片時，需先在卡片上用鉛筆打草稿，而這也是最頭痛的地方。首先，需小心翼翼的輕描免得留下印痕；寫完之後需將鉛筆筆跡擦掉，因此常連帶將未乾的原子筆墨水拓開而毀掉卡片。為了解決這些問題，我決定不在卡片上打草稿，而是用一張跟卡片一樣大的白紙當草稿寫過一次，然後在卡片上**用鉛筆輕點定位出每個字的位置**。*這真的浪費很多時間*，因為

1. 需要先測量卡片的大小，剪出符合此大小的白紙，並在這張白紙上：
    1. 決定字的大小，然後計算、點出一行中每個字的位置
    1. 決定行距，然後標出每行的位置
    1. 寫完草稿

1. 在卡片上點出每個字的位置後，再將字寫上去

當我第一次這樣寫完卡片後，我忽然意識到**第 1 點一定有工具能代替手工**。於是，我找到了一個完全符合需求的線上[方格紙產生器](https://incompetech.com/graphpaper/squaredots/)：


<img src="https://img.yongfu.name/assets/images/grid_paper.png" style="width:70%">

這個**方格紙產生器**可以自訂字的間距 (Grid Spacing) 以及紙張和頁邊的大小。因此有了這個工具後，就可以在量測完卡片的大小後，輸入數值做出草稿用紙。


## 上台報告(投影片)

上台報告對我來說是個很大的挑戰，因為我會緊張到忘記本來要講演的邏輯。克服這挑戰的關鍵當然是練習 -- *寫下報告的講稿反覆練習，直到能自然(自動化)地完成報告*。但除了練習之外，我過去一直忽略**工具**的重要性。事實上，有了正確的工具後，根本**不需擔心會忘記要講什麼**。

幾乎所有投影片工具 (PowerPoint, Google Slides, [reveal.js](https://revealjs.com), [Remark.js](https://remarkjs.com)) 都有**簡報者模式 (presenter mode)**：

<figure>
<img src="https://img.yongfu.name/assets/images/google_slide.gif" alt="Google Slides Presenter Mode" width='85%'/>
<figcaption>Google 簡報者模式。左邊是簡報者看到的內容，右邊是觀眾看到的同步內容。</figcaption>
</figure>

<figure>
<img src="https://img.yongfu.name/assets/images/remarkjs.gif" alt="Remark.js Presenter Mode" width='85%'/>
<figcaption>Remark.js 簡報者模式。左邊是簡報者看到的內容，右邊是觀眾看到的同步內容。</figcaption>
</figure>

但我知道有人因為不知道**簡報者模式需配合[延伸螢幕](https://support.microsoft.com/zh-tw/help/4340331/windows-10-set-up-dual-monitors)使用**而未曾使用這個功能(對，就是我！)。透過延伸螢幕，可以在自己的電腦與投影幕上同步顯示投影片，只是其中一個是有筆記的簡報者模式，另一個則是給觀眾看的一般模式。


## 電子辭典

在電腦上看英文內容遇到不懂的單字時，往往要開啟瀏覽器去查單字。若有很多單字不懂，就要反覆切換視窗畫面。Mac 內建有辭典工具，透過反白文字就可在小視窗中查詢該單字，並可以[安裝第三方字典檔](https://diary.taskinghouse.com/posts/2186795-install-traditional-chinese-english-dictionary-to-mac-built-in-dictionary/)擴充其詞彙。

Windows 和 Linux 使用者沒有這麼方便的內建辭典功能，但透過 [GoldenDict](http://goldendict.org/) 可以達到一樣的效果。**GoldenDict** 是一個開源的字典軟體，本身不含字典檔，但支援多種字典檔案格式，因此可以安裝多個字典檔擴充其詞彙。

使用方式：

- 將字反白後再按快捷鍵 (可自訂)，就會跳出小視窗顯示該字的查詢結果


<figure>
<img src="https://img.yongfu.name/assets/images/golden_dict.gif" alt="GoldenDict" width='85%'/>
<figcaption>GoldenDict，開源電子辭典軟體。支援多種字典檔案格式，但本身不含字典檔，需額外下載。</figcaption>
</figure>


## 記錄想法

*沒有記憶就彷彿不曾存在* 。生活在資訊量爆炸的時代，「記住重要的事情，忽略不重要的刺激」似乎變成一項重要的能力。如果我們不努力記下重要的事情，那這些記憶就會被其它瑣碎的、不重要的刺激[^redundent]洗掉。

面對海量的資訊，網路上有許多專案管理軟體可以幫忙記下事情。我自己習慣使用 [Trello](https://trello.com)，因為覺得它使用起來相當順手(筆記可用 Markdown 語法、Board, List, Card 的階層分類方式)。例如，我用一個 Board 記下未來可能會用到的[線上資源](https://trello.com/b/UerBS2oH/online-resources)。除此之外，目前還有其它十幾個 Board，各自管理一個主題。

用什麼專案管理軟體當然不是重點，最重要的是，在遇見重要想法時能立刻記錄下來。生活在這奇怪的時代 (資訊科技可以幫助人們過得更好，但也可以把人們害得很慘)，學習善用資訊科技的產物變得非常重要。





[^textbook]: 對於某些科系，像是資訊相關科系，可能更有機會印書，因為許多書都可取得開放的 PDF 檔。
[^two-sided]: 這裡是以橫式書寫，例如英文書。LaTeX 可以在 [document class 中設定](https://www.overleaf.com/learn/latex/Single_sided_and_double_sided_documents) `oneside` 或 `twoside` 來決定是否要有這項特徵。

[^four]: 現代版的四藝也行。我可以想到的是：吉他、麻將(?)、鋼筆字、向量繪圖。

[^redundent]: 通訊軟體訊息、社群網路上自動播放的影片、廢文...族繁不及備載。