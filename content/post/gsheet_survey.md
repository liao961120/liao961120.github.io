---
aliases:
- /2018/04/20/gsheet_survey.html
date: '2018-04-20'
description: 透過結合靜態網頁、DataCamp light、以及 google 試算表，使填寫結果即時回饋成為可能
mermaid: false
tags:
- 中文
title: google 表單即時回饋
---



<style>
pre > code {white-space: pre-wrap;}
</style>

google 表單大幅降低蒐集問卷資料的難度；此外，表單將回應**自動彙整成試算表**更使分析資料變得非常容易。然而，google 表單缺乏一項重要的功能：**即時將結果回饋給填寫者**[^test]。

<!--more-->

讓問卷填寫者能馬上知道結果，可以增加其填寫意願，同時也是負責的態度(在回饋不會造成負面影響的前提下)。當然，這在 google 表單本身的限制下無法達成。以下將介紹如何結合 **google 試算表** 以及 **[DataCamp Light](https://github.com/datacamp/datacamp-light)**，讓任何人都能製作出一個在**靜態網頁**上運行的平台，**使填寫者能在此填寫問卷、查詢結果**。

實際操作
--------------------

繼續閱讀下去前，可先至[回饋功能示範平台](https://img.yongfu.name/assets/gsheet_post/demo/)操作看看，比較容易理解下文內容。文章中的說明即是依據此**回饋功能示範平台**。


概觀: 運作邏輯 
--------------------------------------


<img src="https://img.yongfu.name/assets/images/post_img/gsheet_mermaid.png" alt="運作邏輯" style="width:32em">

<!-- see `https://img.yongfu.name/assets/images/post_img/gsheet_mermaid.mermaid.txt` -->

上圖的每個方塊(除了左圖的**試算表**)名稱，皆對應到**回饋功能示範平台**背後運作的檔案。圖需要分**左**、**右**來看：

- **左側**以使用者觀點為中心，顯示使用者填寫問卷(送出資料)到獲得回饋之間，資料流動的路程。

- **右側**的流程圖，實際上是左圖**試算表**(表單、DataCamp之間)那格的完整路程，意即資料在 google 試算表間的流動及運算。使用者獲得的回饋即是由這些試算表的運算產生。

**回饋功能**運作的邏輯其實非常簡單：在問卷送出後，透過 **google 試算表**處理資料(運算、整理)；接著透過 **DataCamp light** 執行預先寫入的 R 語言，讀取經 **google 試算表**處理後的資料；最後使用者輸入查詢金鑰(於問卷中填寫)，篩選出那筆自己填寫的資料。

以下，說明如何設置問卷回饋系統的各個成分，並使用此[資料夾](https://drive.google.com/open?id=16lRn7UUo_-8OUdfaYrg7CSUNIvOAmAM8)中的檔案說明。檔案間的關係完全對應至上文**概觀**中的[概念圖](#mermaidChart0)，亦即**問卷回饋平台**背後蒐集及運算資料所使用到的檔案。下方的說明，單純閱讀文字會難以理解。若有打算實作，可實際打開資料夾中的檔案以配合閱讀，或甚至完全自己重複文中的步驟。


表單、試算表 設置
---------------------------------------

這節將設置**問卷回饋平台**的**資料蒐集與運算功能**，包含 1 個 google 表單(`表單`)及 3 個 google 試算表(`表單回應`, `運算分析`, `結果查找`)。

### 連結表單至試算表

這項功能使用過 google 表單的人都知道，可參考 [google 說明](https://support.google.com/docs/answer/2917686?hl=zh-Hant)，以下簡單說明：

從雲端硬碟進入到表單後，即會顯示下圖的頁面(需具編輯權限)。注意需於**中間白色方塊**點選「**回覆**」，畫面才會如下圖(預設畫面是「問題」)。

![](https://img.yongfu.name/assets/gsheet_post/linksheet.PNG)

接著點選白色方塊右上方的綠色 icon，即會出現 2 個選項：

- 建立新試算表，並命名。 (預設名稱為「無標題表單 (回應)」)
- 選取現有的試算表

選擇建立新的試算表。  
點選建立後，即會在與表單相同的資料夾中建立試算表，我將其命名為**表單回應**(即**概觀**中[右圖](#mermaidChart0)的`表單回應`)。  
此後，每當有人填完問卷，`表單回應`即會自動新增一列(row)資料。

### 試算表間的連結: `IMPORTRANGE`

**千萬不能編輯`表單回應`**，這可能會破壞收集到的問卷資料。google 試算表有一個很實用的函數`IMPORTRANGE`，能夠選取一試算表中特定的範圍，將其連結至另一獨立的試算表中(獨立檔案)。因此，每當原先的試算表更新，透過`IMPORTRANGE`連結的新試算表也會跟著更新。如此，即可在不更動`表單回應`下，對`表單回應`的內容進行運算。

若此文關於`IMPORTRANGE`有描述不清的地方，可參考[這篇](http://isvincent.pixnet.net/blog/post/46090834-excel-google%E8%A9%A6%E7%AE%97%E8%A1%A8%E5%A6%82%E4%BD%95%E9%97%9C%E8%81%AF%E5%88%B0%E5%8F%A6%E4%B8%80%E5%80%8B%E8%A9%A6%E7%AE%97%E8%A1%A8%E7%9A%84%E5%85%A7)寫得相當清楚的文章。
{: .info}

```vbscript
IMPORTRANGE("<URL>", "<工作表名稱>!<儲存格範圍>")
```
- `<URL>`: 所欲匯入資料之試算表的網址，在此為`表單回應`之URL
- `<工作表名稱>`: `表單回應`只有一個工作表，將其名稱填入這裡。
- `<儲存格範圍>`: 儲存格範圍視問卷的題數與筆數而定，其格式為：`A1:F9999`。大寫字母代表欄位，一個欄位即為問卷上的一題；字母後面的數字是列數，一筆資料(一份問卷)佔有一列(row)。

### **`運算分析`**試算表

#### 匯入
在[`運算分析`](https://docs.google.com/spreadsheets/d/1znFpdD_Kt1Jk274l0yD1dGZZyhsh7m1Xji9IYZUigEU/edit#gid=0)中的儲存格`A1`，我輸入了以下公式：

```vbscript
=IMPORTRANGE("https://docs.google.com/spreadsheets/d/1-eOAbpOZ1aeuNUHo3b0olLTrheq-T-pe2BsRXK-P-mM/edit#gid=579070166", "表單回應 1!A1:E9999")
```

以匯入[`表單回應`](https://docs.google.com/spreadsheets/d/1-eOAbpOZ1aeuNUHo3b0olLTrheq-T-pe2BsRXK-P-mM/edit#gid=579070166)的 A 至 E 欄[^num]。

#### 運算公式
我在 G 欄設定公式計算 Q1, Q2, Q3 的分數總合，其中 **Q3 是反向計分**。

#### 時間戳記

由於之後會透過 DataCamp Light 讀取 google 試算表，但其並不支援**英文以外的文字**，因此需**將試算表的格式改為英文**：

選擇試算表 `檔案` > `試算表設定` > `一般`:

- 語言代碼: `美國`
- 時區: `(GMT+08:00) Taipei`[^tz]

更改完試算表語言後，需更改**時間戳記**的格式[^format]：

1. 選擇時間戳記那欄(在此為 A 欄)
2. `格式` > `數值` > `日期時間`

### **`結果查找`**試算表


`運算分析`設置完成之後，需要**選擇希望使用者查詢時，能看到的項目**:

1. **時間戳記**: A 欄
2. **Token**: E 欄
3. **score**: G 欄

因此，需將`結果查找`中的 A、B、C 欄分別對應到`運算分析`中的 A、E、G 欄。在`結果查找`的儲存格`A1`、`B1`、`C1`，分別使用`IMPORTRANGE`：

1. 儲存格`A1`

```vbscript
=IMPORTRANGE("https://docs.google.com/spreadsheets/d/1znFpdD_Kt1Jk274l0yD1dGZZyhsh7m1Xji9IYZUigEU/edit#gid=0", "工作表1!A1:A9999")
```

2. 儲存格`B1`

```vbscript
=IMPORTRANGE("https://docs.google.com/spreadsheets/d/1znFpdD_Kt1Jk274l0yD1dGZZyhsh7m1Xji9IYZUigEU/edit#gid=0", "工作表1!E1:E9999")
```

3. 儲存格`C1`

```vbscript
=IMPORTRANGE("https://docs.google.com/spreadsheets/d/1znFpdD_Kt1Jk274l0yD1dGZZyhsh7m1Xji9IYZUigEU/edit#gid=0", "工作表1!G1:G9999")
```

DataCamp Light 設置
-------------------------------------

[DataCamp](https://www.datacamp.com/) 是一個學習資料科學程式語言的線上教學網站，有 R 和 Python 的教學。[DataCamp Light](https://github.com/datacamp/datacamp-light) 是一個互動式的程式語言輔助教學工具。其能夠鑲嵌在網頁上，讓使用者直接透過網頁學習 R 或 Python。

![](https://img.yongfu.name/assets/gsheet_post/DataCamp.PNG)

這裡即透過 DataCamp 執行預先寫入的 R Script，讀取儲存在雲端的`結果查找`。使用者在 DataCamp Light 輸入的`Token`是用來篩選資料，以回傳使用者填寫的那筆問卷。

### 取得試算表權限

DataCamp Light 讀取的是`結果查找`的內容，因此需將`結果查找`需將`結果查找`透過連結**分享**[^privacy]至網路: 

開啟`結果查找`，選取右上角藍色按鍵**共用**即會開啟下圖中的小視窗：

![](https://img.yongfu.name/assets/gsheet_post/release_csv.PNG)

接著，

1. 選取「知道連結的人均**可以檢視**」(注意**不要選到可以編輯**)
2. 複製連結
3. 按下方「完成」


### 完整程式碼

以下是[回饋功能示範平台](https://img.yongfu.name/assets/gsheet_post/demo/)的 DataCamp Light 程式碼(html)：

```xml
<script src="https://cdn.datacamp.com/datacamp-light-latest.min.js"></script>
<div data-datacamp-exercise data-lang="r">
  <code data-type="pre-exercise-code">
    library(googlesheets)
    data <- gs_read(gs_url("https://docs.google.com/spreadsheets/d/1ufuzTL9VCxdvX1QeFQcMGxYbEMq1ZEWVht3CEDpXBmc/edit?usp=sharing"))
              
    data <- as.data.frame(data)
    colnames(data) <- c("DateTime", "Token", "Score")
    data <- data[which(!is.na(data$DateTime)),]
    score <- function(token) {
      i <- which(data$Token == token)
      data[i,]
    }
  </code>
  <code data-type="sample-code">
    # Put Token in "". Ex: score("abcde123")
    score("Enter_your_Token")
  </code>
</div>
```

下面將分別說明這些程式碼的意義。

**注意**  
DataCamp Light **僅能正常顯示英文**，因此需確定 R Script 以及使用者填入的 Token 皆沒有多位元組字(例如，中文)。
{: .error}


### 預先執行程式碼

下面為`<code data-type="pre-exercise-code">...</code>`之間的程式碼  
此段程式碼是使用者看不到，但會預先執行的 R Script，其中可分成 3 個部分：**讀取資料**、**資料刪減**、**查找函數**。

```R
library(googlesheets)
data <- gs_read(gs_url("https://docs.google.com/spreadsheets/d/1ufuzTL9VCxdvX1QeFQcMGxYbEMq1ZEWVht3CEDpXBmc/edit?usp=sharing"))

data <- as.data.frame(data)
colnames(data) <- c("DateTime", "Token", "Score")
data <- data[which(!is.na(data$DateTime)),]

score <- function(token) {
  i <- which(data$Token == token)
  data[i,]
}
```

#### 讀取資料

```R
library(googlesheets)
data <- gs_read(gs_url("https://docs.google.com/spreadsheets/..."))
```

上面這段程式碼透過雲端讀取`結果查找`，並將其儲存於變項`data`。函數內的連結即是上面在設置`結果查找`的讀取權限時的共用分享連結。

#### 資料刪減

```R
data <- as.data.frame(data)
colnames(data) <- c("DateTime", "Token", "Score")
data <- data[which(!is.na(data$DateTime)),]
```

上面的程式碼做了 3 件事(1 行 1 件事)：

1. 將`data`轉變成 base R 的`data.frame`。由`readr::read_csv`讀進來的`data.frame`會是`tibble`，而`tibble`在 DataCamp Light 的 console  印出時，會顯示出幾項對使用者沒用的訊息(這是 R 給資料分析者看的)，但傳統的 base R `data.frame`不會。
2. 第二行則是將資料中每一個變項的名稱，更改為 **DateTime**(`時間戳記`)、**Token**(`Token`)、**Score**(`Score`)。括號內的名稱是`結果查找`內的變項名稱。
3. 第三行是用以刪減多餘的資料。由於在`運算結果`套用公式時，勢必要為**未來**的儲存格著想：預先套入公式，才能計算未來產生的資料，因此，讀入的資料大多數都是空白的，僅有`Score`那欄為 6[^blank]。

#### 查找函數

```R
score <- function(token) {
  i <- which(data$Token == token)
  data[i,]
}
```

這是 DataCamp Light 在此最關鍵的功能。`score()`是一函數，讓填寫者透過當初於問卷填寫的 Token ，查詢自己的問卷回饋[^two_data]。該函數的功能，即是在`data`中的`Token`變項，尋找符合使用者輸入的值，並將符合的資料印在 console 上。


### 顯示程式碼

下面為`<code data-type="sample-code">...</code>`之間的程式碼，是使用者看的到的 R Script：

```r
# Put Token in "". Ex: score("abcde123")
score("Enter_your_Token")
```
第一行是註解(同一行中，`#`之後的內容不會執行)，可用來說明。  
第二行預先印出`score()`函數，讓使用者僅需輸入 Token 而不需自行打出函數。


靜態網頁 設置
---------------------------------------

對於完全沒有概念的人，設置靜態網頁可能會是比較困難的部分，因為多數人對此相當陌生。靜態網頁在此的目的是為了讓  DataCamp Light 的程式碼(即一段 HTML)能夠運行，因此若讀者使用的部落格平台允許自由變更網頁的 html 並且能自由匯入 JS[^blog]，則可以忽略此節內容。

### GitHub Pages

架設靜態網頁[^static]並非難事，難的是做出漂亮的靜態網頁。然而，網頁越漂亮，其結構通常也更加複雜。如何(短時間)打造美觀的靜態網頁以及基礎 HTML, CSS 的概念並非此文的目的。對於有這些需求的讀者，我推薦 [Yihui Xie](https://yihui.name/) 的 [blogdown](https://bookdown.org/yihui/blogdown/)。

以下提供一個最精簡的例子，由註冊 GitHub 帳號到架設網頁，過程中僅需使用到瀏覽器(GUI)，不需用到 Git。

#### 註冊與建立 Repo
1. 至 https://github.com/ ，填寫註冊資訊(一個 email 僅能註冊一次)，並記得去信箱認證。**Username** 即為之後網站的網址，以下圖為例，minimalghpage.github.io。

	![](https://img.yongfu.name/assets/gsheet_post/github_signup.PNG)

1. 信箱認證後，將自動跳回 GitHub 頁面。之後，基本上不需更動出現之畫面的設定，只要按下一步。最後應會出現下圖，按右上角圖示並選取 **Your Profile**。
	
	![account info](https://img.yongfu.name/assets/gsheet_post/gh_main.PNG)

1. 按下網頁中上方的 **Repositories** 後應會出現下圖，接著再按下右上方的綠色按鈕 **New**。
	
	![](https://img.yongfu.name/assets/gsheet_post/gh_repo.PNG)

1. 出現下圖後，在 **Repository name** 輸入`<username>.github.io`(`<username>`一定要與當初註冊時填入的 **Username** 一模一樣)，並**勾選**下方 **Initialize this repository with a README**。最後按 **Create repository**。

	![](https://img.yongfu.name/assets/gsheet_post/create_repo.PNG)


#### 上傳網頁

1. [下載](https://minhaskamal.github.io/DownGit/#/home?url=https://github.com/liao961120/local_depend/tree/master/minimal_web_DataCampLight) **Minimal Web Page** (下載後需解壓縮。)

2. 至剛剛建立的 Repository (`<username>.github.io`)，點擊 **Upload files** (圖中黃色螢光處)。  

	![](https://img.yongfu.name/assets/gsheet_post/gh_upload.PNG)

3. 進入新畫面後，將`index.html`, `search.html`, `.nojekyll`拖曳上傳，並按下畫面最下方 **Commit changes**.

4. 上傳完成後，即可看到下圖。`.nojekyll`不會顯示出來。  
	
	![](https://img.yongfu.name/assets/gsheet_post/gh_uploaded.PNG)

5. **完成！**過 1, 2 分鐘後，即可至`<username>.github.io`檢視網頁。
6. 之後若要修改檔案，將修改過後的檔案依相同步驟上傳即可。


### Minimal Web Page

[Minimal Web Page](https://github.com/liao961120/local_depend/tree/master/minimal_web_DataCampLight) 裡面有三個檔案：`index.html`, `search.html`, `.nojekyll`。

- `index.html`: 這是網站的首頁，亦即瀏覽器進入`https://<username>.github.io/`時所讀取的檔案。此檔案內含 HTML 必要結構，並且匯入 [bootstrap](https://getbootstrap.com/docs/4.0/getting-started/introduction/) 的 CSS 和 JS 以快速製作漂亮的 Button 和 Modal。
- `search.html`：這份檔案即為上文 DataCamp light 的[完整程式碼](#完整程式碼)，加上一些 HTML 的必要結構以及重新整理頁面的按鈕(Reload)。若需修改其中的 R Script，需用[文字編輯器](https://zh.wikipedia.org/wiki/%E6%96%87%E6%9C%AC%E7%BC%96%E8%BE%91%E5%99%A8)開啟此檔案修改`<code>...</code>`裡面的內容。
- `.nojekyll`: [Jekyll](https://help.github.com/articles/using-jekyll-as-a-static-site-generator-with-github-pages/) 是 GitHub Pages 預設的靜態網頁產生器，能自動將 Markdown 生成`.html`，對於常寫文章的使用者很方便：不需每次發文都要自己將文章轉為 html 檔。`.nojekyll`在此的作用是告訴 GitHub Pages **不要使用 Jekyll 產生網頁**，因為使用 Jekyll 產生網頁，repository 需符合特定的檔案格式與架構[^jekyll]。

#### R 使用者

會用 Rmarkdown 的人，可直接[下載](https://minhaskamal.github.io/DownGit/#/home?url=https://github.com/liao961120/blog/tree/masterhttps://img.yongfu.name/assets/gsheet_post/demo)**回饋功能示範平台**製作網頁(需額外安裝一些 package)，不須使用上述資料夾內的檔案。這能省下許多製作網頁(`index.html`)的時間。

R markdown 是 Markdown 的擴充，其輸出的 HTML 格式已經過簡單的排版，同時也支援 Bootstrap (**Minimal Web Page** 裡的 HTML 也有匯入 Bootstrap)，因此能夠輕易地製作出**美觀**的網頁。Rmarkdown 可輸出許多格式，其中 [html_document](https://rmarkdown.rstudio.com/html_document_format.html) 最為簡單。Rmarkdown 的語法([Cheat Sheet](https://www.rstudio.com/wp-content/uploads/2015/03/rmarkdown-reference.pdf))即為 Markdown 語法加上許多額外的功能(透過 R 實現)。
<div id="privacy"></div>

隱私問題
----------------------------------

在此需特別提醒問卷填寫者隱私的問題。由於查詢個人的問卷回饋需透過 DataCamp Light，其**由雲端讀取之試算表(`結果查找`)是公開的**。縱使網頁表面看不見`結果查找`的網址，但只要檢視網頁的原始碼(透過瀏覽器的開發人員工具，或至 GitHub 直接下載`search.html`)，即可取得`結果查找`的網址，並下載整份資料[^secure]。

以這裡的例子說明，`結果查找`僅含有 3 欄：時間戳記、Token、分數。這 3 欄是任何人都能看見的內容，其中 **Token 是由問卷填寫者直接填寫**，因此

在設計問卷時，需於 Token 那題特別提醒填寫者：**不能填寫能關聯到個人身份的內容，如學號、e-mail 等**。

<div style="font-size:10pt; text-align:right">Last updated: Apr 27, 2018</div>

<!-- Footnotes -->
[^test]: 其實 google 表單確實能即時回饋分數，但僅限[測驗模式](https://support.google.com/docs/answer/7032287?hl=zh-Hant)，有諸多限制，例如，題目僅能為「對」或「錯」，無法處理反向計分的問題，無法使用線性刻度 (linear scale) 計分等。

[^num]: 若擔心填答人數超過 9998 人，可設個更大的數字，如`E99999`。

[^tz]: 你也可以設置時區，通常依據的是多數問卷填寫者所在位置的時區。這邊設為台北時間。

[^format]: 這邊是為了方便之後 R parse 日期格式。

[^static]: 這裡的靜態網頁是架設在 GitHub 上，代表(1)可以任意修改網頁；(2)網頁的內容(檔案)是完全公開的。因此，相對於其他部落格平台，如 Blogger， 網站管理人的彈性相當大，而且網頁上不會出現廣告。然而，由於檔案是完全公開的，需**注意隱私以及版權問題**。

[^blog]: 我對目前的部落格平台功能相當不熟悉，但就我所知提供此功能的應該不多。DataCamp Light 有提供 WordPress(不是 WordPress.com) 外掛，詳見 [DataCamp Light Wordpress Plugin](https://github.com/datacamp/datacamp-light-wordpress)。

[^jekyll]: 這是自行在 GitHub Pages 上架設部落格最困難的地方：使用者需對 Jekyll 有一定程度的理解。這同時也是我推薦 [blogdown](https://github.com/rstudio/blogdown) 的原因，其讓使用者略過理解複雜的靜態網頁產生器，而能專心在網頁的內容上。

[^secure]: 然`結果查找`透過`IMPORTRANGE`匯入的試算表只要**未開放共用連結**，仍是安全的。這也是為何即使僅需 2 個(或甚至 1 個)試算表和 DataCamp Light 即可做到問卷回饋，但我仍使用了 3 個試算表。<br>(另一原因是考量 google 及 DataCamp Light 的運算資源及時間。縱使我較喜歡，也應該要用 R 語言處理資料，考量到 google 擁有較強大及穩定的運算資源，多數的運算因此交給 google 試算表，而 DataCamp Light 僅用來讀取資料。)

[^two_data]: 若有兩筆以上的資料有相同的 Token，`score()`就會篩選出相同筆數的資料，並將這些資料印在 console 上。此時，可以透過 **DateTime** 那行來確定填寫時間，以找到自己填寫的那筆資料。

[^blank]: 總分(Score) = 空白(Q1) + 空白(Q2) + 6(6 - Q3)。Q3 是反向計分的五點量尺。

[^privacy]: 這關係到隱私問題，詳見最後一節[隱私問題](#privacy)
