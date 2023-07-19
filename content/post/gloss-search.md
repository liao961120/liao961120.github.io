---
aliases:
- /2020/04/23/gloss-search.html
date: '2020-04-23'
description: ''
subtitle: ''
tags:
- app
- Python
- Linguistics
title: Searching Interlinear Glosses Written in Word Documents
---


I am taking the course [Linguistic Fieldwork](https://nol2.aca.ntu.edu.tw/nol/coursesearch/print_table.php?course_id=142%20M0210&class=&dpt_code=1420&ser_no=10017&semester=108-2&lang=EN) this semester. Each week, we record and transcribe Budai Rukai, an Austronesian language spoken by [Rukai people (魯凱族)](https://en.wikipedia.org/wiki/Rukai_people). The resulting data (interlinear glosses) are written in a Word document (`.docx`) as required by the course instructor. Things get worse as the number of documents accumulates each week, since it becomes harder to locate specific linguistic patterns in the corpus of texts, as they are spread across multiple documents. 

Inspired by [the work](https://github.com/puerdon/corpus_processor) of my labmate, [Don](https://github.com/puerdon), I created a web app for searching interlinear glosses, which can search for and locate specific patterns in a collection of Word documents. This post describe the web app's basic design and improvements to [`puerdon/corpus_processor`](https://github.com/puerdon/corpus_processor), the project this web app got inspiration and succeeded from. For instructions about using the app, visit [`liao961120/gloss-search`](https://github.com/liao961120/gloss-search) ([English](https://github.com/liao961120/gloss-search/blob/master/README-en.md)) for more details.


<img src="https://img.yongfu.name/gif/gloss-search.gif" style="width:100%">



## Basic Design

The app's frontend was built with [Vue.js](https://vuejs.org), and the backend was written in [Python 3](https://python.org). The frontend was designed to ease the search and locating of certain patterns in the Word documents and is the only interface the users need to interact with. The backend is used to (1) parse the glosses written in Word documents into Python objects (dictionaries) and (2) perform the search on these Python objects based on the requests sent from the frontend. 


## Backend

The most challenging part of the backend program is that of (1) since Word is a [WYSIWYG](https://en.wikipedia.org/wiki/WYSIWYG) editing software, which means that two Word documents could have the exact same appearance while differ in their underlying structures. In other words, without considering the fact that different users differ in the way they use Word, the naive code used to parse Word documents are doomed to fail, even though the users SEEM to stick to a particular format. In order to deal with this problem, some kind of *normalization* needs to be done to all the Word documents such that documents that look the same are INDEED the same. The format of the Word document provided by our course instructor is as below:

```
[Number].
[Original language (optional)]
[EMPTY LINE (optional)]
[Gloss line 1 (original language)]
[Gloss line 2 (English)]
[Gloss line 3 (Mandarin)]
[EMPTY LINE]
#e [English translation]
#c [Chinese translation]
#n [Notes]
[EMPTY LINE]
```

Below is an illustration of what it 'looks' like in a Word document of interlinear glosses:

<img src="https://img.yongfu.name/posts/gloss-example.png" style="width:75%">

When you press `Enter` on the keyboard while editing a Word document, you SEEM to be creating a **line break**, but, in fact, you are creating a **new paragraph**. To create a line break without breaking the current paragraph, `Shift + Enter` instead of `Enter` should be pressed. This is an example of the user behaviors I needed to normalize before I can sucessfully parse the Word documents. 

To do this in Python, I extract all the paragraphs in a Word document using the module [`python-docx`](https://python-docx.readthedocs.io/en/latest)[^python-docx] and concatenate them with newline characters (`\n`) into a large string. Then, I split the string by `\n` into a list of lines, from which the starting and ending positions (the positions where `[gloss num].` is found in the list) of each elicitation could be located by simple pattern matching:

```python
from docx import Document


def process_doc(fp="corp/20200325.docx"):

    # Normalize document into a list of lines
    d = Document(fp)
    a_doc = '\n'.join(p.text for p in d.paragraphs)
    a_doc = a_doc.split('\n')

    # Find the positions of each elicitation
    pat_start = re.compile("^(\d{1,2})\.\s*$")
    glosses_on = []
    gloss_num_old = None
    for i, line in enumerate(a_doc):
        if pat_start.match(line):
            gloss_num_new = i

            # Save each elicitation range
            if gloss_num_old is not None:
                glosses_on.append( (gloss_num_old, gloss_num_new - 1) )
            gloss_num_old = gloss_num_new
    
    # Save last gloss
    i = gloss_num_old
    while True:
        i += 1
        if a_doc[i].strip().startswith('#'):
            if len(a_doc) == i + 1 or (not a_doc[i + 1].strip().startswith('#')):
                end_idx = i + 1
                break
    glosses_on.append( (gloss_num_old, i) )

    # Get all elicitations in the document
    glosses = []
    for start, end in glosses_on:
        gloss_num = int(re.match("(\d+)\.", a_doc[start])[1])
        gloss_lines = [ l.strip() for l in a_doc[(start + 1):end] ]
        glosses.append( (gloss_num, gloss_lines) )
    
    return glosses
```

One major improvement to [`puerdon/corpus_processor`](https://github.com/puerdon/corpus_processor) is dealing with gloss lines that span multiple lines, as exemplified in the code chunk below. This problem can be solved by removing all empty lines between the gloss lines and free lines (those starting with `#e`, `#c`, and `#n`) such that, when the free lines are excluded, the number of gloss lines **must** be multiples of three (the example below has 6 gloss lines in total). Normalizing each elicitation to this format allows me to concatenate multiple gloss lines into three for all elicitaion examples. The code that deal with this can be found in the function `assign_gloss_free_lines()` in [`GlossProcessor.py`](https://github.com/liao961120/gloss-search/blob/master/GlossProcessor.py).

```
14.
kay Elrenge watsili kay malri ki lalake ki talialalay

kay   Elrenge    w-a-tsili      kay    malri
this  Elrenge    AF-RLS-throw   this   ball
這    Elrenge    主焦-實現-丟     這      球 

ki     lalake   ki    talialalay
OBL    kid      _     noble
斜格    小孩     _     貴族

#e Elrenge throw a ball to the noble’s kid.
#c 這 Elrenge 丟一顆球給貴族的小孩
#n
```

After normalizing the Word documents, the documents are parsed and convert into the Python dictionary as shown below:

```python
{
    '20200325.docx': [
        (1, {
            'ori': ['yakay', 'ku', 'tatulru', 'ku', 'ababay', 'ku', 'agili'],
            'gloss': [
                ('yakay', 'have', '有'),
                ('ku', 'three', '3'),
                ('tatulru', 'female/male', '女性/男性'),
                ('(ku', 'yonger_brother/sister-1SG.POSS', '弟妹-我的.第一人稱單數.所有格'),
                ('ababay/sauvalay)', '_', '_'),
                ('ku', '_', '_'),
                ('agi-li', '_', '_')
                ],
            'free': [
                '#e I have 3 younger brother/sister',
                '#c 我有 3 個弟弟/妹妹',
                '#n  yakay ku 可省略'
                ]
            }
        ),
        (2, ...),
    
    ...
    '20200408.docx': [...],
}
```


## Frontend

The construction of the frontend was relatively easy, given that the most challenging part was already done in [my (dead) project on building a web app for interlinear glossing](/2020/02/22/leipzigVue.html). In brief, the component [`Leipzig.vue`](https://github.com/liao961120/gloss-search-frontend/blob/master/src/components/Leipzig.vue) is used to construct the aligned glosses (see figure below) from the data sent from backend (i.e., the python dictionary in the previous section, converted to JSON format). 

<img src="https://img.yongfu.name/posts/leipzig.js.png" style="width: 70%; float: center;">

Another relatively challenging part (to me) is implementing the highlighting function, which highlights the matching patterns in the glosses (as in the words with yellow background in the figure above). It was implemented by creating a [computed property](https://vuejs.org/v2/guide/computed.html) that wraps the parts of the data matching the search pattern into HTML `<span class="matchedtoken">` tags. I can then use CSS to decorate these tags.

The remaining parts of the fontend are about communicating with the server, which are relatively easy to set up. I actually just copy-and-pasted the code from my previous [KWIC concordancer project](https://github.com/liao961120/kwic/blob/master/src/components/kwic.vue).



[^python-docx]: I didn't spent much time exploring the API of [`python-docx`](https://python-docx.readthedocs.io/en/latest/) thanks to Don's PIONEERING (at least in our university, or even Taiwan, I believe) project [`puerdon/corpus_processor`](https://github.com/puerdon/corpus_processor).
