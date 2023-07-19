---
aliases:
- /2019/03/02/wintogo.html
date: '2019-03-02'
tags:
- 中文
title: 安裝 UEFI 開機功能之 Windows To Go
---



這學期修課 (地圖與地理資訊系統) 需要使用 [ArcGIS](https://zh.wikipedia.org/wiki/ArcGIS)。由於 ArcGIS 僅能運行於 Windows 上，加上

<!--more-->

1. 我真的受不了 Virtualbox 跑 Windows 的速度
1. 我不想在我的電腦 dual boot Windows


因此我用了 [Windows To Go](https://zh.wikipedia.org/wiki/Windows_To_Go)，將 Windows 10 安裝於外接硬碟，讓電腦可以透過外接硬碟直接運行 Windows10。

因為我對電腦硬體沒什麼概念，安裝 Windows To Go 花了我一大堆時間。這個筆記主要參考
[Macbook Air 2013 製作 UEFI 引導的 Windows To Go](https://www.mobile01.com/topicdetail.php?f=481&t=3598474) 和 [將Windows 10打包至USB裝置帶著跑](https://www.kocpc.com.tw/archives/96445) 這兩篇文章撰寫而成，這裡僅是快速記下我在 Windows 上使用 [Diskpart](https://en.wikipedia.org/wiki/Diskpart) 安裝 Windows To Go 至外接硬碟的過程，若有問題...不要問我。

順便在這裡呼籲老師們，站在教育者的立場，應該少使用閉源、不支援跨平台的軟體。當然，我理解每個領域有自己傳統、預設的系統，但世界正在改變，而且學生的就業也越來越廣泛，這些「傳統」的系統常常價格昂貴，不會是學生未來會使用到的軟體。


## 事前準備

1. Windows 10 ISO 安裝檔 (我從學校的授權軟體下載)
1. 一台已安裝 Windows 10 的電腦
1. 一個外接硬碟


先將 ISO 檔複製到 Windows 10 的電腦上，按右鍵掛載。其會以 CD ROM 的形式出現在本機 (e.g. `V:` 槽)

## Diskpart 建立磁區

以系統管理員權限執行命令提示字元，依序執行以下指令：

1. `diskpart`

1. `list disk`

1. `select disk #`: `#` 是數字，為要安裝 Windows To Go 的外接硬碟

1. `clean`: 清除硬碟上所有 partition

1. `convert GPT`: 使用 GPT partition table

1. `create partition EFI size=300`: 建立 EFI 開機磁區 (300 MB)

1. `list partition`

1. `select partition #`: `#` 是數字，選擇剛建立的 EFI 磁區

1. `format quick fs=fat32`: 將 EFI 磁區格式化

1. `assign letter=S`: 將 EFI 磁區掛載於 `S` 槽

1. `exit`: 離開 diskpart

## 使用 GUI 建立磁區

理論上這邊也可以用 Diskpart 建立，但我沒 (興趣) 試過，所以依照我原來看到的教學寫下。

1. 打開 `電腦管理` (可用搜尋)，會出現下圖

    ![](https://attach.mobile01.com/attach/201310/mobile01-e1a97e2bc92d451f77a9eca571e142a5.png)

1. 在左欄點選 `磁碟管理`，即可在中間下方看到剛建立的 EFI 磁區以及未配置的磁碟空間

1. 右鍵點選未配置空間 > `新增簡單磁區`

    - 建立 NTFS 分割 (格式化)，可以自行決定要多大的空間 (我設 150 GB)。
    
    - 記下此新增的磁區掛在哪個槽 (e.g. `E:`)


## 將 ISO 檔安裝到外接硬碟

1. 回到命令提示字元，輸入：

    `dism /apply-image /imagefile:V:\sources\install.wim /index:1 /applydir:E:\`
    
    其中，`V` 是掛載之 Windows ISO 檔，`E` 是剛劃分之 150 GB 外接硬碟中的磁區。

1. 在上述指令跑完後，使用

    `bcdboot E:\Windows /s S: /f UEFI`
    
    將開機檔案從 Windows To Go 的磁區 (`E:`) 複製到 EFI 磁區 (`S:`) 中。
    

## 在外接硬碟安裝 Windows To Go

接下來，就可以拿著這個外接硬碟去開機了。找一台支援 UEFI 開機的電腦，開機前先將外接硬碟插入，開機時按快捷鍵進入開機選單，選擇以外接硬碟開機。若不想每次開機都要進入開機選單，可修改 Boot option priority (見下圖)，將此外接硬碟設為第一優先，電腦內建作業系統開機設為第二。如此，在每次開機時，若外接硬碟是插著的，那就會以 Windows To Go 開機；若未插入外接硬碟，則會進入電腦原本的作業系統。

![](https://i0.wp.com/image.walker-a.com/2016/01/ros/ros-19.jpg)


第一次開機時，會跑出安裝 Windows 的畫面。安裝好之後，就完成了 Windows To Go 的設定。


## 參考資料

上文中的兩張圖片分別取自 1. 和 2.

1. [Macbook Air 2013 製作 UEFI 引導的 Windows To Go + Time Machine的外接硬碟](https://www.mobile01.com/topicdetail.php?f=481&t=3598474)

1. [將 Windows 10打包至USB裝置帶著跑](https://www.kocpc.com.tw/archives/96445)

1. [diskpart 硬碟分割指令](http://blog.ilc.edu.tw/blog/index.php?op=printView&articleId=505798&blogId=25793)


1. [What Is an EFI File?](https://www.lifewire.com/efi-file-2620983)
