---
layout: tutorial
title: Getting Started with SQLite and Sequel Pro
description: An introduction to using SQL with a GUI client
date: 2014-09-25
published: true
---

This is a quick guide to the interface for the __2 graphical user interfaces__ recommended for our initial foray into SQL databases. They are by no means the only ones, I recommend them because they work well and are free.

### SQL, SQLite, and MySQL

First, some terminology: [SQL](http://en.wikipedia.org/wiki/SQL) stands for __Structured Query Language__, which is a type of __programming language__ used in working with databases. When you write SQL to do data work, you are _programming_.

[SQLite](http://www.sqlite.org/) and [MySQL](http://www.mysql.com/) are two different database systems that use two different variants of SQL. For the scope of our work, they will basically be _interchangeable_ because they are both very similar. SQLite and MySQL refer to the _database software itself_, not the _graphical user interfaces_ that we'll be using to work with the databases (e.g. Sequel Pro for MySQL, and SQLite Manager for SQLite)

A quick technical aside: __Why am I recommending either SQLite or MySQL?__ Because both have their tradeoffs in terms of installing it on your computer. Getting SQLite on your computer can be as easy as installing the Firefox Browser, which comes packaged with SQLite. But the _graphical user interface_ for SQLite is not as nice as some of the GUIs available for MySQL. However, with MySQL, you typically have to install MySQL yourself, which is typically not as easy as installing Firefox.


### Choosing a GUI

The graphical user interfaces (i.e. GUIs) mentioned here make it so that working with databases have some of the conveniences of working with spreadsheets.

__To sum up the descriptions below:__ If you're on __Mac OS X__, try to use __Sequel Pro__, which sits atop the __MySQL__ software. Windows and Linux have their own MySQL clients, including [HeidiSQL](http://www.heidisql.com/). But you may have problems installing __MySQL__ itself.

If all else fails, install the __Firefox__ browser, then the SQLite Manager plugin. The sacrifice you make is having a more spartan of an interface.


More details below:


#### Sequel Pro

![img](files/tutorials/databases/sequel-pro-intro.png)

[Download Sequel Pro here.](http://www.sequelpro.com/)

If you have a Mac, then the [Sequel Pro client](http://www.sequelpro.com/) is hands-down the best client to use when interfacing with a __MySQL__ database. It has the nice look-and-feel of a modern, native OS X app because it *is* one. The main drawback of course is that Sequel Pro is only available for OS X. 

Another drawback for novice users is that Sequel Pro uses __MySQL__, which means you'll have to [first install the MySQL software ](http://dev.mysql.com/doc/refman/5.0/en/macosx-installation.html)yourself...which can be easy or very hard, depending on your situation.

See the [official Installing MySQL on Mac OS X instructions here](http://dev.mysql.com/doc/refman/5.0/en/macosx-installation.html). However, you may have to Google around for independently-written guides on it.

Jump to [Getting Started with Sequel Pro](#sequel-pro-instructions)


#### SQLite Manager for Firefox

![img](files/tutorials/databases/sqlite-manager-intro.png)

Download the [Firefox Browser here](https://www.mozilla.org/en-US/firefox/new/). Then add the [SQLite Manager plugin here](https://addons.mozilla.org/en-US/firefox/addon/sqlite-manager/).

The upside of __[SQLite Manager](https://addons.mozilla.org/en-US/firefox/addon/sqlite-manager/)__ is that it runs on anything that the Firefox Browser runs on, which is most modern systems. And you don't have to install the SQLite software yourself, because Firefox comes with it. The downside is that the SQLite Manager, while an excellent piece of free software, isn't as user-friendly as Sequel Pro. 

Jump to [Getting Started with SQLite Manager](#sqlite-manager-instructions)


#### Alternative GUIs

Here are a few alternative packages, some of which cost money:

##### MySQL GUIs

- [HeidiSQL](http://www.heidisql.com/) - a popular and __free__ GUI for __MySQL__ (and a few other SQL variants). Developed for Windows but can be made to work with OS X.
- [MySQL Workbench](http://www.mysql.com/products/workbench/) - a GUI maintained by MySQL's developers. Free and cross-platform
- [Navicat](http://www.navicat.com/products/navicat-for-mysql) - a cross-platform commercial GUI. It's functional, and common in the workplace, but it costs money. 

##### SQLite GUIs

- [SQLite Browser](https://github.com/sqlitebrowser/sqlitebrowser) - a popular and free GUI for SQLite for Windows and OS X.
- [Base 2](http://menial.co.uk/base/) - A commercial GUI available only for Mac OS X.
- [Navicat](http://www.navicat.com/products/navicat-for-sqlite) - Just like they have commercial cross-platform GUIs for MySQL.



-------------
{: #sequel-pro-instructions}

## Getting started with Sequel Pro

*These instructions are for the __Sequel Pro__ client for OS X. [Go here for SQLite Manager instructions](#sqlite-manager-instructions)*

First, you must install MySQL &ndash; this might be a very difficult situation depending on your setup. If that's the case, you might want to [settle for SQLite Manager](#sqlite-manager-instructions). I'm not going to give much guidance on this step [except to point to the official instructions](http://dev.mysql.com/doc/refman/5.0/en/macosx-installation.html). Good luck!

After MySQL is installed, [download Sequel Pro](http://sequelpro.com/).


### Importing SQL files

Sequel Pro can import CSV files, but to make things easy, we'll just import SQL files, which contain all the code to build a database with pre-inserted data.

You can download __either one__ of these files:

- [SFPD Incident Reports 2003-2013 (231MB)](http://stash.padjo.org.s3.amazonaws.com/dumps/sql/sfpd_incident_reports_2003_2013.sql.zip) - All the San Francisco Police Department incident reports, from 2003 to 2013. Roughly 1.5 million records total
- [SFPD Assault Reports 2003-2013 (19MB)](http://stash.padjo.org/dumps/sql/sfpd_assault_reports_2003_2013.sql.zip) - Just the SFPD reports categorized as `ASSAULT`. Roughly 130,000 records.

Obviously, if you have a slower computer, you may want to start off with the smaller file.



#### Creating a new MySQL database


1. Open the Sequel Pro app. A __Connection__ dialog box should pop up. The __Settings__ here will differ depending on how you installed things. Hopefully a __Host__ value of 127.0.0.1, __username__ of `root`, and a __Port__ of `3306` will be your default settings. Hit the __Connect__ button. If you get error messages at this point, um...look around for help on your machine's setup. Or just use Firefox and __SQLite Manager__.
2. In the menubar, select __Database > Add Database__
3. Name it something like `sfpd` and hit the __Add__ button
4. In the menubar, select __File > Import__, then select the SQL file that you downloaded.
5. After the import is done, look at the left sidebar and click on the `sfpd_incidents` table.


##### Video


<video id="sequel-pro-open-database-001" class="video-js vjs-default-skin" controls preload="false" width="100%"> <source src="/files/videos/databases/sequel-pro-open-database-001.mp4" type='video/mp4' /></video>




### Sequel Pro interface

The Sequel Pro interface is about as simplified of a database GUI as I've ever seen. Here's an overview of the functions and views we'll be using:

- __Structure__: In the rare situations where we add columns via point-and-click, we can do it here.
    
    ![img](files/tutorials/databases/sequel-pro-structure-tab.png)

- __Content__: In the relatively-rare situations (usually when we're unfamiliar with the database) where we want to browse the data as if it were a spreadsheet, this tab provides limited browsing and editing capability.

    ![img](files/tutorials/databases/sequel-pro-content-tab.png)


- __Query__: This is where we'll spend a majority of our time: writing SQL queries, executing them, and seeing the filtered results.

    ![img](files/tutorials/databases/sequel-pro-query-tab.png)


For the most part, you only have to be familiar with __Query__, as that's where the work gets done.



### The Query tab

Here's a quick run-through of how to run a basic `SELECT` query in Sequel Pro. After this, you'll know enough about the Sequel Pro to do some basic work, and you can move on to the [Select and Where tutorial](/tutorials/databases/select-and-where)

1. Click on the __Query__ tab
2. Type in a query, such as: 

     ```sql
     SELECT * FROM sfpd_incidents WHERE date > "2012"
     ```

3. Hit __Run Current__, which will execute the query you've written. You'll see the results of your query in the bottom panel.
4. Optional: You can click the little __Gear button__ at the bottom of the results and and __Export Result__ as CSV. So in our current scenario, we would produce a CSV of reports from 2012 to 2013.

##### Video

<video id="sequel-pro-execute-query-002" class="video-js vjs-default-skin" controls preload="false" width="100%"> <source src="/files/videos/databases/sequel-pro-execute-query-002.mp4" type='video/mp4' /></video>

OK, now you know enough to write and execute SQL. Move on to the [Select and Where tutorial](/tutorials/databases/select-and-where).











--------
{: #sqlite-manager-instructions}

## Getting started with SQLite Manager

*These instructions are for the __SQLite Manager__ client. [Go here for Sequel Pro](#sequel-pro-instructions)*

First, install the [Firefox Browser](https://www.mozilla.org/en-US/firefox/new/). Then install the [SQLite Manager plugin](https://addons.mozilla.org/en-US/firefox/addon/sqlite-manager/).


### Importing SQLite databases

The SQLite Manager can import CSV files, but to make things easy, we'll start off with actual SQLite database files.

You can download __either one__ of these files:

- [SFPD Incident Reports 2003-2013 (270.3MB)](http://stash.padjo.org/dumps/sql/sfpd_incident_reports_2003_2013.sqlite.zip) - All the San Francisco Police Department incident reports, from 2003 to 2013. Roughly 1.5 million records total
- [SFPD Assault Reports 2003-2013 (21.9MB)](http://stash.padjo.org/dumps/sql/sfpd_assault_reports_2003_2013.sqlite.zip) - Just the SFPD reports categorized as `ASSAULT`. Roughly 130,000 records.

Obviously, if you have a slower computer, you may want to start off with the smaller file.


#### Opening a SQLite database


1. Open your Firefox Browser
2. In the menubar, select __Tools > SQLite Manager__
3. The menubar will now change context to reflect that you're basically using a different program, i.e. SQLite Manager versus the Firefox Browser. From this new menubar, select __Database > Connect Database__
4. Now select the `sqlite` database you just downloaded.
5. Our database is simple and contains only one __table__. In the left sidebar, click the __Tables__ dropdown and then the table label, `sfpd_incidents` 

##### Video

<video id="sqlite-manager-open-database-001" class="video-js vjs-default-skin" controls preload="false" width="100%"> <source src="/files/videos/databases/sqlite-manager-open-database-001.mp4" type='video/mp4' /></video>






### SQLite Manager's interface

I won't lie, SQLIte Manager's interface can be a bit confusing and cluttered. Here's a quick overview of the 3 SQLite's tab/submenus that we'll end up using:

- __Structure__: In the rare situations where we add columns via point-and-click, we can do it here.
    
    ![img](files/tutorials/databases/sqlite-manager-structure-tab.png)

- __Browse & Search__: In the relatively-rare situations (usually when we're unfamiliar with the database) where we want to browse the data as if it were a spreadsheet, this tab provides limited searching and editing capability.

    ![img](files/tutorials/databases/sqlite-manager-browse-tab.png)

- __Execute SQL__: This is where we'll spend a majority of our time: writing SQL queries, executing them, and seeing the filtered results.

    ![img](files/tutorials/databases/sqlite-manager-execute-sql.png)

For the most part, you only have to be familiar with __Execute SQL__, as that's where the work gets done.

### Executing queries

Here's a quick run-through of how to run a basic `SELECT` query in the SQLite Manager. After this, you'll know enough about the SQLite Manager to do some basic work, and you can move on to the [Select and Where tutorial](/tutorials/databases/select-and-where)

1. Click on the __Execute SQL__ tab
2. Type in a query, such as: 

     ~~~sql
     SELECT * FROM sfpd_incidents WHERE date > "2012"
     ~~~
3. Hit __Run SQL__. You'll see the results of your query in the bottom panel.
4. Optional: You can click the __Actions__ dropdown menu and export the results of your query as a CSV file by clicking __Save Result (CSV) to File__  . So in our current scenario, we would produce a CSV of reports just in 2012 to 2013.


##### Video

<video id="sqlite-manager-execute-query-002" class="video-js vjs-default-skin" controls preload="false" width="100%"> <source src="/files/videos/databases/sqlite-manager-execute-query-002.mp4" type='video/mp4' /></video>




## Basic database terminology

This class is concerned only with how to query databases. I don't have any intention to teach database administration, but at the same time, it's necessary to understand a little bit of the underlying structure.

### Databases

Think of it as a spreadsheet file, referred to as a __Workbook__in Microsoft Excel, that contains multiple sheets or tabs:

![img](files/tutorials/databases/multiple-tabs-excel.png)

Typically with database software, you'll be asked to __connect__ to a database. This is not much different than just opening a Workbook file in Excel before doing work on it.

In this lesson, the database will be named `sfpd`.


### Tables

Think of these as the __individual tabs/sheets__ of an Excel Workbook. They're all part of the same file, but they contain their own data fields and rows. Most of the fun with databases involves _joining_ different tables together via some common field.


If you're familiar with the `VLOOKUP` [functionality in a spreadsheet](http://computers.tutsplus.com/tutorials/how-to-extract-data-from-a-spreadsheet-using-vlookup-match-and-index--cms-20641), then you might [have tried to link different tabs/sheets within the same workbook](http://computers.tutsplus.com/tutorials/how-to-extract-data-from-a-spreadsheet-using-vlookup-match-and-index--cms-20641):

    =VLOOKUP(something_, table range, column number, [true/false])

In this lesson, the table will be named `sfpd_incidents` because it contains incident reports.


### Database engine

This refers to the __software__ you're using to work with a database, e.g. [MySQL](http://www.mysql.com/) or [SQLite](http://sqlite.com/index.html). It is analogous to Microsoft Excel, Mac OSX Numbers, OpenOffice, or Google Spreadsheets. Each of those are _different_ programs though they all involve manipulating spreadsheets. To work with an Excel spreadsheet inside of Google Spreadsheets, you typically _export_ data from the Excel file and _import_ it into Google Spreadsheets, which has its own spreadsheet file format.

In the same way, you can export data out of SQLite (typically, as a CSV) and import it into MySQL. But you can't just open a SQLite database and work with it directly from MySQL.

### Database server

This refers to the _computer_ that hosts the database and runs the database software needed to access that database. For the purposes of this lesson, the __database server__ will be your own computer, i.e. what you're using to read this right now. In the real world, you often connect to remote databases hosted on other computers &ndash; either across the world or perhaps somewhere in your company's offices. 

I suppose in spreadsheet-terminology, the computer that you've been using Excel on could be thought of (somewhat inaccurately) as a local "Excel server".

Note: To be really technical about it, a MySQL database server uses a different server process than what you, the _client_ uses. SQLite is [a "serverless" database](https://www.sqlite.org/serverless.html).

The upshot for you, the novice is that installing and using SQLite will be little different than what it takes to install and run Excel. Choosing a "database" means finding where the database file (usually with a `sqlite` extension) is saved on your computer.

#### MySQL servers

With MySQL, you have to not only install the MySQL "client" software, but your computer will be running a _server_ process in the background to serve up the databases.

So with any MySQL graphical-user-interface you use, you'll typically be asked to choose a __server__ to connect to, and _then_ you'll select a __database__ to work with.

![img](files/tutorials/databases/sequel-pro-connect-screen.png)

(If you are having problems getting MySQL to run on your personal computer, often times it will be a server connection type of issue. Hope you don't run into it, because fixing it is beyond the scope of this tutorial...)


### Database GUI

This refers to the friendly graphical interface you're using on top of the database software, e.g. [Sequel Pro](http://sequelpro.com/) for MySQL and [Firefox's SQLite Manager](https://addons.mozilla.org/en-US/firefox/addon/sqlite-manager/) for SQLite.

There is no direct analogy to the spreadsheet world, because part of the appeal of spreadsheet programs is that the GUI is inseparable from the spreadsheet-software &ndash; i.e. Excel is both the spreadsheet-manipulating program and the nice interface for it.

This is what MySQL looks like _without a GUI_

![img](files/tutorials/databases/sql-commandline.png)


##### Video

Watch me do a `SELECT` query from the command-line:

<video id="sql-select-command-line-0011" class="video-js vjs-default-skin" controls preload="false" width="100%"> <source src="/files/videos/databases/sql-select-command-line-0011.mp4" type='video/mp4' /></video>

Compare that to using the Sequel Pro GUI:

<video id="sql-select-pro-0012" class="video-js vjs-default-skin" controls preload="false" width="100%"> <source src="/files/videos/databases/sql-select-sequel-pro-0012.mp4" type='video/mp4' /></video>



### All together

For the purposes of this lesson, all we care about are __databases__ and __tables__. For this _specific_ lesson, we're using a database which has a single table, so it's no different than opening a Workbook in Excel and having just a single tab/sheet.

But when I refer to "open the database", what I mean is:

1. Run your __database GUI__ (e.g. Sequel Pro or SQLite Manager)
2. Turn on the __database engine__ (MySQL or SQLite); the GUI will already to that for you.
3. Connect to the __database server__ that's currently running on your computer (If you're using MySQL/Sequel Pro), which is usually set to `127.0.0.1`
4. Select a database (in this lesson, it'll be named `sfpd`)
5. Query a particular table, e.g. `sfpd_incidents`.




---

OK, now you know enough to write and execute SQL. Move on to the [Select and Where tutorial](/tutorials/databases/select-and-where).


