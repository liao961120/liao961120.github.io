---
aliases:
- /2019/03/07/ntuthesis.html
date: '2019-03-07'
katex: false
mermaid: false
tags:
- R Markdown
- R
- writing-tool
- 中文
title: ntuthesis
subtitle: "用 Markdown 撰寫博碩士論文"
---


2023.2.27 更：下文套件已失修，若有需求，請參考 [thesis](https://github.com/liao961120/thesis)。

---

去年十月份的研究所甄試，實在找不到合乎主題的文章報告可以附在審查資料。想想自己可以拿來說嘴的大概只剩 R Markdown，於是寫了[一篇 (硬是扯上語言學的) 文章](https://liao961120.github.io/ling-rmd)交了上去。為了怕被面試老師問：「你在文章中說的可信嗎？文章中哪裡可看出你的研究能力？」便在文章中引用自己撰寫的[套件](https://liao961120.github.io/linguisticsdown)[^linguisticsdown]。由於還是害怕文章太過空泛，又將文章中的部份想法 -- R Markdown 模板，實作出來以備不時之需，[`ntuthesis`](https://liao961120.github.io/ntuthesis) 因而誕生了。結果 ... 面試時，老師們根本沒有問到有關 R Markdown 的問題。

<!--more-->

[^linguisticsdown]: `linguisticsdown` 當時僅有 3 個函數，而且是在兩天內寫完然後提交到 CRAN。雖然簡陋，但我覺得這套件是目前我所[製造出來的一堆玩具](/#projects)中最有用的。



## 緣起

這個用 R Markdown 寫論文的想法，其實在一年多前[剛認識 R Markdown 時](/2018/01/31/RlearningPath.html)時就有了。當時還不太確定是否可行，僅覺得如果可行的話一定會很有趣。現在，我百分百確定這是可行的 、九成九確定它能幫你省下論文排版的功夫。

`ntuthesis` 原本僅是個 [bookdown](https://github.com/rstudio/bookdown) (R Markdown 的一個擴充) 論文模板，但為了讓其便於使用，我將它作成套件。`ntuthesis` 的目的只有一個 -- 讓作者能專注在**論文內容**的寫作。其它論文寫作的麻煩事：排版、口試委員審定書、目錄、圖目錄、表目錄、文獻引用格式、浮水印，全部都能自動生成。論文模板的概念並不新穎，且現存許多 LaTeX 論文模板。但撰寫 LaTeX 的過程非常辛苦，因為作者必須時時將注意力放在**論文排版**上。相對的，`ntuthesis` 讓作者能用 [Markdown](https://zh.wikipedia.org/wiki/Markdown#示例) 撰寫論文，甚至可使用 R 語言直接在論文中動態產生結果 (如統計圖、數值與報表)。


## 總是需要跨出第一步

現在的問題是，臺灣還沒有人用過 `ntuthesis` 撰寫論文，而當「第一位」總是相當可怕的，更何況還要脫離自己習慣的寫作環境 (例如，MS Word)。作為 `ntuthesis` 的作者，**我一定會用 `ntuthesis` 撰寫論文**，但不會是在短期內 (我才剛錄取研究所)。所以這篇文章的目的基本上有兩個：

1. 推銷 `ntuthesis`：

    尋找願意使用 `ntuthesis` 撰寫論文的研究生
    
1. 為 `ntuthesis` 擔保[^guarantee]：

    > 你專心寫論文，我負責處理論文格式。

    如果使用 `ntuthesis` 撰寫臺大[^ntu]論文，你只要擔心論文的內容，任何套件相關的問題 (如排版設定不正確、bug、說明文件不清楚等) 我都會 (盡力) 協助解決 (不擺爛)。

    
[^guarantee]: 由於我未來會使用 `ntuthesis` 撰寫論文，所以請相信我有動機 (至少自此之後的兩年) 維護此套件。

[^ntu]: `ntuthesis` 其實亦可[撰寫他校論文](https://liao961120.github.io/ntuthesis/articles/extend_template.html)，但目前缺乏他校 (封面) 模板。



## 一點點的使用門檻

天下沒有白吃的午餐，使用新東西固然有點門檻：

- 若已在用 R Markdown，那這門檻應該很低

- 若已經會用 bookdown，恭喜你沒有門檻問題

- 若不懂 R Markdown，甚至完全不懂 Markdown

    1. 請花 3 分鐘閱讀[維基百科](https://zh.wikipedia.org/wiki/Markdown)，花 5 分鐘[用用看 Markdown](https://jbt.github.io/markdown-editor)
    
    2. 花一段悠閒的時光 (我是在臺中至臺北的客運上用平板滑完的)，輕鬆地閱讀僅 137 頁的 [bookdown Book](https://bookdown.org/yihui/bookdown/) ([PDF](https://bookdown.org/yihui/bookdown/bookdown.pdf))。請不要很認真的細讀每頁，挑自己需要的看。請不要把它當成是負擔。當成是增廣見聞，欣賞世界上竟然有這種東西。看這本書真的很享受。


## 問題

若有任何關於 `ntuthesis` 的問題，請儘管提出來。我最歡迎在 GitHub 提出 [issue](https://github.com/liao961120/ntuthesis/issues)，但若沒有 GitHub 帳號，也可以透過 [Email](mailto:liao961120@gmail.com) 與我聯絡。




