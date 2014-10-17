---
layout: tutorial
title: The SELECT statement and FROM clause
description: Starting up a SQL database and seeing data
date: 2014-09-29
---

This is a lesson on simply how to _open_ a database and _show_ data from a database. If you're thinking, _"What the hell? In Excel, I just open a file and there is the data"_...

Yep!_ That's correct. The SQL `SELECT` statement and `FROM` clause will be a first taste of how _explicit_ SQL is compared to your standard spreadsheet. A spreadsheet will conveniently display all of its contents upon opening. A SQL database will only show you only _what you tell it to show you_.

<!-- SPLIT_SUMMARY -->


> Note: For this SQL lesson, I will be using the __Sequel Pro__ GUI for the __MySQL__ database engine and will be querying the SFPD incident reports categorized as `ASSAULT`
> 
> If you want to see exactly the same results I do, you'll want to download and import the__ MySQL database of 2003 to 2013 assault reports from the SFPD__.
> 
> I've also created the __SQLite__ version of that database, which should functionally be the same as the MySQL version. 
> 
> For both MySQL and SQLite, I've also created a database of _all_ the SFPD reports from 2003 to 2013. All the queries should work the same, except you can explore all the different categories of crime. The tradeoff is that the database is much bigger, and so will be slower to download, import, and query. If you're completely new to all this, I would just go with the __assaults__ database, just so any errors you make don't take even longer to figure out.
> 
> - [__MySQL__ assault reports: 130,097 rows](http://stash.padjo.org/dumps/sql/sfpd_assault_reports_2003_2013.sql.zip) 
> - [__MySQL__ all incident reports: 1,491,764 rows ](http://stash.padjo.org.s3.amazonaws.com/dumps/sql/sfpd_incident_reports_2003_2013.sql.zip)
> - [__SQLite__ assault reports: 130,097 rows](http://stash.padjo.org/dumps/sql/sfpd_assault_reports_2003_2013.sqlite.zip) 
> - [__SQLite__ all incident reports: 1,491,764 rows ](http://stash.padjo.org.s3.amazonaws.com/dumps/sql/sfpd_incident_reports_2003_2013.sqlite.zip)
{: .warning.well}



The SQL interpreter's insistence on being told exactly what to do can be annoying when you just want to see everything by default, which is why most database GUIs let you _browse_ a data table via the __Browse/Content__ functionality:

![img](/files/tutorials/databases/sequel-pro-content-tab.png)

But what if you want to see only a few columns, if just to reduce the amount of visual clutter? In a __spreadhseet__, you would have to manually rearrange or hide the columns &ndash; or, as some foolish novices do and regret later: __delete__ the unwanted columns.

With SQL, you can __select__ data fields with a query like this:

~~~ sql
SELECT Category, Descript, Date, Time FROM sfpd_incidents
~~~


![img](files/tutorials/databases/sql-select-columns.png)

##### Video

Watch me execute a `SELECT` query with Sequel Pro:

<video id="sql-select-gui-0011" class="video-js vjs-default-skin" controls preload="false" width="100%"> <source src="/files/videos/databases/sql-select-sequel-pro-0012.mp4" type='video/mp4' /></video>


The typing may seem tedious, but the tradeoff is that by being _explicit_, you do away with the fumbling click-and-drag-and-button-pushing motions that will inevitably result in embarrassing data mistakes, even for the best of Excel-masters; [ask these Harvard economists about it](http://www.nytimes.com/2013/04/19/opinion/krugman-the-excel-depression.html).


## The `SELECT` statement

This expression retrieves columns. Used alone, it will retrieve literal or computed values. It's not particularly interesting until we refer to __tables__, but let's see what the syntax looks like by itself:


#### `SELECT` a value

Executing this basic query:

~~~sql
SELECT "hello world";
~~~

Will return a single column titled `"hello world"` and a single row with the value of `"hello world"`. Nothing special here:

![img](files/tutorials/databases/sql-hello-world.png)

Querying for a _computational_ statement, such as adding two numbers together:

~~~sql
SELECT 10 + 32;
~~~

&ndash; will result in this:

| 10+32 |
|-------|
|    42 |
{: .sql-table}



#### `SELECT` a series of values/columns

Use commas to select multiple fields/values:


~~~sql
SELECT "A", "B", 9 + 7, "Hello world"
~~~


| A | B | 9 + 7 | Hello world |
|---|---|-------|-------------|
| A | B |    16 | Hello world |
{: .sql-table}



## The `FROM` clause

If we think of `SELECT` as a _sentence_, then our sentences so far have been very simple. Just as in English, we add complexity to our SQL statements with _clauses_.

So far, the SQL program hasn't actually touched our database tables. With the `FROM` clause, we can specify the _columns_ we want to `SELECT`. The "grammar" goes like this:

> __SELECT__ [a column name] __FROM__ [a table name]

Written as a SQL statement:

~~~sql
SELECT Location FROM sfpd_incidents
~~~

The result:

![img](files/tutorials/databases/sql-select-location.png)

The query will return the value of the `Location` column for _every_ row. If you're using the database of just the SFPD _assaults_ from 2003 to 2013, the result will contain 130,097 rows.


Just as an exercise, try querying:

~~~sql
SELECT "hello world" FROM sfpd_incidents;
~~~

The result should look like this:

(again, one row) 

|    hello world     |
|--------------------|
| hello world        |
| hello world        |
| hello world        |
| ...(130,097 times) | 
{: .sql-table}


Note: You'll likely never do something like that, but it's worth just reemphasizing the basics of `SELECT` here.

#### Selecting multiple columns from a table

No surprises here:

~~~sql
SELECT Location, X, Y
FROM sfpd_incidents
~~~


|---------------------------|----------------|--------------|
|          Location         |       X        |      Y       |
|---------------------------|----------------|--------------|
| 300 Block of WOODSIDE AV  | -122.452194214 | 37.745666504 |
| 400 Block of NATOMA ST    | -122.406684875 | 37.781009674 |
| 300 Block of COLUMBUS AV  | -122.407066345 | 37.798183441 |
| 300 Block of ELLIS ST     | -122.412330627 | 37.784889221 |
| 300 Block of ELLIS ST     | -122.412330627 | 37.784889221 |
| 1900 Block of JENNINGS ST | -122.387695312 | 37.728080750 |
| 1000 Block of SUTTER ST   | -122.416862488 | 37.788208008 |
| 400 Block of TURK ST      | -122.416641235 | 37.782432556 |
| 400 Block of TURK ST      | -122.416641235 | 37.782432556 |
| 1300 Block of NATOMA ST   | -122.418441772 | 37.767608643 |
{: .sql-table}
   

#### Selecting all the columns


Sometimes you just want all the columns in a table. You _could_ do this manually, e.g.

~~~sql
SELECT 
  IncidntNum, Category, Descript, DayOfWeek, Date, Time, PdDistrict, Resolution, Location, X, Y
FROM
  sfpd_incidents
~~~


However, you can use an _asterisk_ as a shorthand for "_all the columns_":

```sql
SELECT * FROM sfpd_incidents
```


### Frequent mistakes

Even today, the most common SQL mistake I make is this:

~~~sql
SELECT IncidentNum, Category, Descript
~~~

The above statement will return an error because I've omitted what table I want to select these columns _from_. In the GUI, just because you've selected a table by clicking on it and you've been querying the same table for the past hour, doesn't mean that the SQL interpreter will automatically assume that you're using the same table.

Also, that above query will throw an error because I've spelled 'IncidntNum' as 'Incid__e__ntNum'; database software won't do the guesswork for you when it comes to typos.

Keep this need for being _explicit_ (and repetitive) in mind. That's typical behavior in programming languages.



### Conclusion

What have we learned here? Not much, just the particular SQL syntax needed to list the contents of our data tables. But get this syntax _grounded_, because our "sentences" will very soon become much more convoluted with different kinds of clauses.


#### Exercises

1. Write the query which produces a result table in which all the columns from the `sfpd_incidents` table, but list them in _alphabetical_ order. Yes, this means typing it out manually.
2. Write the query which produces a result table with a single column which contains the sum of the `X` and `Y` columns from `sfpd_incidents`


##### Solution 1

~~~sql
SELECT 
  Category, Date, Descript, IncidntNum, Location, PdDistrict, Resolution, Time, X, Y
FROM sfpd_incidents
~~~

##### Solution 2

~~~sql
SELECT X + Y
FROM sfpd_incidents
~~~


#### Other resources:

[SQL: The Prequel (Excel vs. Databases)](https://github.com/veltman/learninglunches/tree/master/databases)

[A Gentle Introduction to SQL Using SQLite, Part I](https://github.com/tthibo/SQL-Tutorial/blob/master/tutorial_files/part1.textile)

[Peter Aldhous's SQLite tutorial](http://peteraldhous.com/CAR/Database_SQLite.pdf)
