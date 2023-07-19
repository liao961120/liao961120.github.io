---
aliases:
- /2020/05/26/what-if-i-have-no-server.html
date: '2020-05-26'
description: Describe how to integrate Travis-CI, and Google Drive into a web app.
subtitle: Utilizing Travis-CI for Data Update in a Web App
tags:
- app
- Travis-CI
- JavaScript
title: What if I Have No Server?
---


In [my previous post](/2020/04/23/gloss-search.html), I describe how I created a web app that can search and locate patterns in interlinear glosses written in Word documents (`docx`) to facilitate the workflow of documenting language. I tried to make the (backend) app [extremely easy to install](https://github.com/liao961120/gloss-search/blob/master/README-en.md#usage), but still, most of my classmates didn't even try to install it. It is just to frightening for people without any programming experience to install python on their own. Hence, I decided to make the app even more user-friendly. Now, ANYBODY can use the app if she has access to the Internet and a web browser. Just visit <https://glosss.yongfu.name> and play with the app to see what happens. In this post, I describe how I made the app completely web-based (without setting up a server). 



## The App's structure

In relation to the title of this post, the app is not just web-based, it is also SERVERLESS---in the sense that there is no backend server listening to the queries entered by the user[^compare-to-previous]. All searching is done locally in the browser.
To setup the app, I only need a simple server that hosts static files (for the app written in HTML/CSS/JS and the data in JSON format), and [GitHub Pages](https://pages.github.com) is all that is needed. Specifically, I utilized three (free) services in order to allow the users to upload and search the glosses contained in their Word documents:

- **GitHub Pages**  
  GitHub Pages is used to host my app ([`liao961120/gloss-search-frontend`](https://github.com/liao961120/gloss-search-frontend)) and the processed JSON data that contains interlinear glosses (originally written in Word documents)
- **Google Drive**  
  Users are provided a GD folder to upload their Word documents
- **Travis CI**  
  After uploading their Word documents to GD, users can [trigger a Travis CI build](https://docs.travis-ci.com/user/triggering-builds) by clicking <img src="https://bit.ly/2X2r1aQ" style="display:inline;height:1em;width:auto;margin:0"> on the bottom-left corner of the [app](https://glosss.yongfu.name) (password needed). Under the hood, I encrypted my Travis CI's API token so that when the user enters the correct password, a POST request (containing the decrypted token) is sent to Travis CI to trigger a build. During the build, the Word documents saved in Google Drive are download and processed into JSON format and then pushed back to a GitHub repo that hosts the data.

The figure below summarizes the flow of the app's data:

<div class="figure">
	<img src="https://img.yongfu.name/posts/gloss-search-webbased.png" style="width:100%">
	<p class="caption">Figure 1: The numbers annotated to the arrows indicate the order of the execution. Processes with annotated text appended with <img src="https://img.yongfu.name/icon/user.png" style="display:inline;height:1em;width:auto;margin:0"> indicate that they are triggered by the user. Other processes proceed automatically.</p>
</div>


## Configuration of the Travis build

Below is the partial configuration[^travis-yml] of the Travis build that:

1. download the Word documents from Google Drive
1. process the Word documents into a JSON file (and a log file)
1. push the resulting files to [`gloss-search:gh-pages`](https://github.com/liao961120/gloss-search/tree/gh-pages) (set up in the `deploy: ` section)

(1) and (2) is done in the script [`GlossProcessor.py`](https://github.com/liao961120/gloss-search/blob/master/GlossProcessor.py). In the script, I call [`GitHub30/gdrive.sh`](https://github.com/GitHub30/gdrive.sh) to download files from Google Drive (this really saved me a large amount of time). Then I use the module `python-docx` (described in my previous post) to process the Word documents into a structured JSON file.

```yaml
language: python
python:
  - "3.7"

install:
  - pip install python-docx

# command to run tests
script:
  - python3 GlossProcessor.py https://drive.google.com/drive/folders/${BUDAI_RUKAI}

deploy:
  provider: pages
  skip-cleanup: true
  github-token: $GH_TOKEN  # Set in travis-ci.org dashboard, marked secure
  keep-history: true
  on:
    branch: master
```



## Encrypt/Decrypt API token in JavaScript

Travis CI is normally used as a testing service, but since code is tested by scripts, one can actually write scripts that do things other than testing. Since [my discovery of using Travis CI to render R Markdown](https://bookdown.org/yihui/bookdown/github.html) in the R community, a lot of creative ideas came to me (e.g., using [Travis Cron Jobs](https://docs.travis-ci.com/user/cron-jobs) to regularly [update plots depending on the data from a survey](/2019/02/17/visualize-language-loss.html)).

Usually, a Travis build is triggered by a push to the GiHub repo, a pull request, or a preset cron job. A more advanced way to trigger builds is to utilize Travis CI's API. As described in the [API document](https://docs.travis-ci.com/user/triggering-builds), to trigger a build on a repo (e.g., `liao961120/gloss-search`), one need to send a POST request to the endpoint `https://api.travis-ci.org/repo/liao961120%2Fgloss-search/requests`[^url-encode] along with the API token provided by Travis CI. The JS (Vue) code below is used for sending the POST request to Travis CI:

```js
triggerBuild: function() {
            const url =
                "https://api.travis-ci.org/repo/liao961120%2Fgloss-search/requests";
            const body = {
                request: {
                    branch: "master",
                    message: "Trigger build from glosss.yongfu.name"
                }
            };
            const decryptedText = this.CryptoJS.AES.decrypt(
                this.build_token,
                this.build_psswd
            ).toString(this.CryptoJS.enc.Utf8);
            const header = {
                "Content-Type": "application/json",
                Accept: "application/json",
                "Travis-API-Version": "3",
                Authorization: `token ${decryptedText}`
            };
            this.$http.post(`${url}`, body, { headers: header }).then(
                response => {
                    this.response = response;
                },
                response => {
                    this.response = response;
                }
            );
        }
```

Notice the variable `decryptedText` in the code above.
To prevent my API token from being exposed to the public, I have to encrypt my API token. The encrypted token is saved in the variable `build_token`, and the password to decrypt the encrypted token is given to the users privately. To trigger a build with the app, the user needs to enter the correct password (saved to the variable `build_psswd`). After the user enters the password, the app can then decrypt the encrypted token to the original API token. The API token is then placed in the POST request header (`` Authorization: `token ${decryptedText}` ``) and send to Travis CI.
The encryption and decryption of the API token is done with [a Vue wrapper](https://github.com/tpenaranda/vue-cryptojs) of the JS library [`crypto-js`](https://github.com/brix/crypto-js).



[^url-encode]: Note that the slash separating `liao961120` and `gloss-search` needs to be converted to `%2F` to prevent interpreting `liao961120/gloss-search` as different URL segments.

[^compare-to-previous]: A rough way to think of this new app (as compared to [the previous one](/2020/04/23/gloss-search.html)) is that the functionality of the backend part of the app (i.e., data preprocessing in Python) is replaceced by Travis CI. The old app listens on local file changes in the Word docuemnts, but Travis CI can never provide this functionality. However, the benefit of ease of use (no need to startup a server) is huge as compared to real-time data update provided by a backend server.

[^travis-yml]: For the full configuration, see <https://github.com/liao961120/gloss-search/blob/master/.travis.yml>.