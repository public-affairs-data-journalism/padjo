---
title: Public Affairs Data Journalism
layout: home
current_course:
  name: comm_273d
  term: fall_2014
---

This is the homepage for the Stanford course __COMM 273D, Public Affairs Data Journalism I__ as taught by [Hearst Professional in Residence, Dan Nguyen](http://stanford.edu/~dun) for the Stanford [Computational Journalism Lab](http://cjlab.stanford.edu).

If you're a casual visitor, you're probably most interested in the [Tutorials](/tutorials). You can also visit the class sites for my two other electives this year:

- COMM 213 - [Computational Methods in the Civic Sphere](http://www.compciv.org/)
- COMM 277A - [Computational Journalism](http://www.compjour.org/)


### Fall 2015

__Session:__ September 21 to December 4, 2015 

__Hours:__ Tuesdays and Thursdays, 1:30 to 2:50PM

__Location:__ McClatchy Hall ([Building 120](http://campus-map.stanford.edu/?srch=120-410)), Room 410

The __Fall 2015__ site, currently under construction, will be at: [http://2015.padjo.org](http://2015.padjo.org)

The __Fall 2014__ site is archived here: [http://fall2014.padjo.org](http://fall2014.padjo.org).


#### Quick Links


+ [Tutorials](/tutorials)
+ [Recommended readings list](/readings)
+ [Suggested datasets](/datasets)
+ [Syllabus for COMM 273D Fall 2014](/lectures/comm_273d/2014_fall/syllabus)
+ [Github repo](https://github.com/public-affairs-data-journalism/padjo) for padjo.org


__Contact__: Check the course syllabus for office hours. You can also email me at my `stanford.edu` address: (`dun`).



--------------

## Core concepts

Our primary goal is to learn __how to argue with and against data__. To understand the business of our government, including the power it wields over &ndash; or yields *to* &ndash; our institutions, then we must understand data, the byproduct of that business, and often, its fuel.


We see data as a means of understanding and, when necessary, critiquing the "data-driven decisions" in public affairs. Our focus is on concepts rather than technology and mathematical problem solving over statistical methods. The core of our work is ultimately the same core of traditional reporting: the initiative to question, the independent research of facts, and the desire to inform the public.

Our three main strategies:

1. To systematically collect and count the data that, for various reasons, has not been officially collected, e.g. [Homicide Watch](http://homicidewatch.org/) and ProPublica's [When Caregivers Harm](http://www.propublica.org/series/nurses)
2. To efficiently analyze large &ndash; but otherwise benign &ndash; datasets to find evidence of something significant, e.g. the [Sun Sentinel's Above the Law: Speeding Cops](http://www.pulitzer.org/citation/2013-Public-Service),  Reuters' [Water's Edge](http://www.reuters.com/investigates/special-report/waters-edge-the-crisis-of-rising-sea-levels/#article-1-insidious-invasion), Center for Investigative Reporting's [On Shaky Ground](http://californiawatch.org/earthquakes)
3. To join and compare datasets, e.g. all of the above


----------



## Techniques and tools

![img](/files/homepage/paper-snow-plow.jpg)


Knowing how to use the tools &ndash; and why they are needed &ndash; allows us to efficiently explore and analyze data ourselves, which is key to understanding data concepts in a meaningful way.

I've tried to keep the tools and programs as agnostic as possible:


### Plain-text editor
{: .sec}

![img](/files/homepage/text-editor.png)

There is no perfect data tool. So get used to importing and exporting data from spreadsheet to database to web application &ndash; and back. The common interface between all of these systems is _just_ text.

This is why most of the data we'll encounter will be plaintext, i.e. [delimiter-separated values](http://en.wikipedia.org/wiki/Delimiter-separated_values), or, will be content (such as from PDFs) that we'll want to convert to plain text.

A plain-text editor (as opposed to a rich-text editor, such as Microsoft Word) can be the most effective way to explore and clean up a dataset before you attempt to analyze it with a spreadsheet or database.

We will cover a few text-based concepts: using [Markdown](https://help.github.com/articles/markdown-basics) to write web-and-human-friendly documents. And [regular expressions](http://regex.bastardsbook.com/), a kind of Find-and-Replace on steroids. 

The best general purpose, cross-platform text editor is [Sublime Text](http://www.sublimetext.com/), which has a 30-day free trial. For Windows, there is the free [Notepad++](http://notepad-plus-plus.org/). For Mac, there is the free [TextWrangler](http://www.barebones.com/support/textwrangler/manual.html)

##### Text-editor skills
- The purpose of delimiters
- Regular expressions


### Spreadsheet
{: .sec}

![img](/files/homepage/spreadsheet.png)


Spreadsheets are the most accessible way to explore, analyze, and visualize small to medium-sized (100,000 rows) datasets. They're also handy for just organizing and structuring your notes and thoughts (which can effortlessly be turned into "data" later). Modern spreadsheets typically have a layer of "data types", i.e., "July 4, 1776" is no longer _plaintext_, but a _date_, which allows the user to apply data-specific formulas, e.g. `=WEEKDAY(some_cell_with_a_date)` to get the day of week.

(However, the assumptions made by a spreadsheet can sometimes destroy data, which is why it's necessary to deal with data as _just text_).

In class, we'll be using [Google Spreadsheets](//sheets.google.com) for their mostly-intuitive interface and online collaboration features. However, Microsoft Excel and the open-source [LibreOffice](http://www.libreoffice.org/) can also be used.

##### Spreadsheet skills
- Sorting and filtering
- Data organization
- Pivot tables and aggregation
- Quick visualizations




### Database
{: .sec}

![img](/files/homepage/database.png)

For most of our data analysis and exploration, a relational database will be overpowered and awkward. However, for the _joining_ of datasets, i.e. two different tables that share the same column (such as an ID number), there is not a more direct way to do so than to express our desire than through [Structured Query Language](http://en.wikipedia.org/wiki/SQL), i.e. SQL.

When you write SQL, you will technically be _programming_. However, to not get lost in the weeds, we'll only be covering a basic set of SQL commands, and will frequently be exporting data from a database into a spreadsheet.

We'll be accessing databases through graphical user interfaces. For all platforms, you can install the Firefox web browser and then, the [SQLite Manager plugin](https://addons.mozilla.org/en-US/firefox/addon/sqlite-manager/). On Mac, the best free database GUI is [Sequel Pro](http://www.sequelpro.com/)

##### Database skills

- Inner and outer joins
- Foreign key relationships


### Optional tools:
{: .sec}

- [OpenRefine (Macs and PCs)](http://openrefine.org/) - OpenRefine looks like a spreadsheet but has much narrower use case: the cleaning of data. But it's the best at what it does, and the difference between being average and good at data cleaning can easily make or break an entire project.
- [Mou (for Macs)](http://25.io/mou/) - A Markdown editor that lets you preview your work.
- [Github desktop client](https://mac.github.com/) - For when you tire of using the web interface.
- [Google Fusion Tables](https://support.google.com/fusiontables/answer/2571232?hl=en) - a hybrid of online database and visualization tool. Particularly useful for simple mapping of large datasets.
- [ModeAnalytics](https://modeanalytics.com/) - A kind-of "Github for MySQL", allowing collaboration and sharing of datasets and queries via the web browser.



-----------

## Related coursework at Stanford

COMM 273D is the prerequisite for [COMM 274D: Public Affairs Data Journalism II](https://explorecourses.stanford.edu/search?view=catalog&filter-coursestatus-Active=on&page=0&catalog=&academicYear=&q=COMM+274D&collapse=), taught in the winter by [Cheryl Phillips](http://journalism.stanford.edu/news-cheryl-phillips/).

I am also teaching the following two classes (open to undergraduates outside of the journalism program):

- [COMM 113/213: Computational Methods in the Civic Sphere](https://explorecourses.stanford.edu/search?view=catalog&filter-coursestatus-Active=on&page=0&catalog=&academicYear=&q=COMM+213+Civic+Sphere&collapse=) in the winter quarter
- [COMM 177A/277A: Computational Journalism](https://explorecourses.stanford.edu/search?view=catalog&filter-coursestatus-Active=on&page=0&catalog=&academicYear=&q=COMM+277A&collapse=) in the spring quarter.

How I see the relationship between the 3 courses I'm teaching: 

- __Public Affairs Data Journalism I__ covers the work and process of journalism, as well as the tools and concepts needed to efficiently understand data &ndash; data, that for the most part, I will have extracted and cleaned for class use. 
- __Computational Methods__ covers the problem-solving skills needed to collect and explore data for public accountability stories, as well as additional techniques for visualizing and publishing data journalism.
-  __Computational Journalism__ focuses on using computational methods and problem-solving to produce a project with civic impact, whether it be a web application or via other mediums.

