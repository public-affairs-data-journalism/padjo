---
layout: tutorial
title: Aggregate functions in SQL
description: "How to count our grouped results."
date: 2014-10-07
---

In the [previous tutorial](/tutorials/databases/sql-group), we learned about `GROUP BY`, a clause that seems terribly benign until you use the aggregate functions we'll learn about in this tutorial. 

With `COUNT`, `SUM`, `AVERAGE`, and other functions, SQL will be able to provide _most_ of the analytical functionality we have with Pivot Tables, with considerably more speed and flexibility.


----------
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

----------




### The `COUNT`

Let's review a basic use of `GROUP BY`; the following query will list all the police districts that show up in the `sfpd_incidents` set:

~~~sql
SELECT PdDistrict
  FROM sfpd_incidents
  GROUP BY PdDistrict
~~~

Which results in this:

|------------|
| PdDistrict |
|------------|
|            |
| BAYVIEW    |
| CENTRAL    |
| INGLESIDE  |
| MISSION    |
| NORTHERN   |
| PARK       |
| RICHMOND   |
| SOUTHERN   |
| TARAVAL    |
| TENDERLOIN |
{: .sql-table}


If we want to find __the number of incidents per district__, then we use the __aggregate function__ `COUNT`, which we specify in the query as if it were another column to `SELECT`:


~~~sql
SELECT PdDistrict, COUNT(*)
  FROM sfpd_incidents
  GROUP BY PdDistrict
~~~

Which results in:

|------------|----------|
| PdDistrict | COUNT(*) |
|------------|----------|
|            |      833 |
| BAYVIEW    |    16094 |
| CENTRAL    |    11749 |
| INGLESIDE  |    14711 |
| MISSION    |    18650 |
| NORTHERN   |    14096 |
| PARK       |     5906 |
| RICHMOND   |     5504 |
| SOUTHERN   |    20329 |
| TARAVAL    |     9172 |
| TENDERLOIN |    13053 |
{: .sql-table}

__Note:__ For many variants of SQL, the syntax `COUNT(1)` [is no different](http://stackoverflow.com/questions/1221559/count-vs-count1) than `COUNT(*)`. I use both interchangeably.


When used with `GROUP BY`, the `COUNT` function will provide the number of records that belong to each grouping. Try querying to find the count of incidents per district by _subcategory_ (of assault):


~~~sql
SELECT PdDistrict, Descript, COUNT(1)
  FROM sfpd_incidents
  GROUP BY PdDistrict, Descript
~~~


An excerpt of the results:

| PdDistrict |                      Descript                     | COUNT(1) |
|------------|---------------------------------------------------|----------|
| BAYVIEW    | AGGRAVATED ASSAULT OF POLICE OFFICER, SNIPING     |        1 |
| BAYVIEW    | AGGRAVATED ASSAULT OF POLICE OFFICER,BODILY FORCE |       35 |
| BAYVIEW    | AGGRAVATED ASSAULT ON POLICE OFFICER WITH A GUN   |        1 |
| BAYVIEW    | AGGRAVATED ASSAULT ON POLICE OFFICER WITH A KNIFE |        3 |
| BAYVIEW    | AGGRAVATED ASSAULT WITH A DEADLY WEAPON           |     1276 |
| MISSION    | THREATS TO SCHOOL TEACHERS                        |       43 |
| MISSION    | UNLAWFUL DISSUADING/THREATENING OF A WITNESS      |       25 |
| MISSION    | WILLFUL CRUELTY TO CHILD                          |       36 |
| NORTHERN   | AGGRAVATED ASSAULT OF POLICE OFFICER,BODILY FORCE |       29 |
| NORTHERN   | AGGRAVATED ASSAULT ON POLICE OFFICER WITH A GUN   |        2 |
| NORTHERN   | AGGRAVATED ASSAULT ON POLICE OFFICER WITH A KNIFE |        5 |
{: .sql-table}


#### Counting without grouping

A quick aside: if `COUNT` is something that can be _selected_ as a result column, what happens if we use it without `GROUP BY`?

The value returned by `COUNT` will be the number of result rows. Here is its simplest form:

~~~sql
SELECT COUNT(*)
~~~

|----------|
| COUNT(*) |
|----------|
|        1 |
{: .sql-table}


To find the total number of rows in a given table:

~~~sql
SELECT COUNT(*) FROM sfpd_incidents
~~~

|----------|
| COUNT(*) |
|----------|
|   130097 |
{: .sql-table}


And if we filter the table with `WHERE`, we can expect the count of results to change:

~~~sql
SELECT COUNT(*) FROM sfpd_incidents WHERE PdDistrict='CENTRAL';
~~~

|----------|
| COUNT(*) |
|----------|
|    11749 |
{: .sql-table}







#### SQL vs Pivot Tables

This should look familiar to what you've done with pivot tables: creating rows with a grouping by `PdDistrict` and `Descript`, and showing the `COUNT` values of the grouping. 

What SQL does not do very well is create a _matrix_, e.g. `PdDistrict` as rows, and `Descript` as headers. To see something like that, you're better off exporting from SQL and into a spreadsheet.


#### `MAX`, `MIN`, `AVG`, and `SUM`

Standard SQL includes functions to find the maximum, minimum, average, and summation of numerical columns. In the `sfpd_incidents` dataset, we don't have much use for these functions as we don't have many numerical columns to aggregate upon. But they would be handy in a dataset like schools and yearly test scores, for example.

These functions take the same form as `COUNT`, though you will want to provide the name of a column to find the max/min/average/sum _of_.

The query below will find the average, max, min of each police district's `X` and `Y` coordinates (where neither `X` nor `Y` are set to `0`) in their respective incident reports:

~~~sql
SELECT PdDistrict, 
    MAX(X), AVG(X), MIN(X), 
    MAX(Y), AVG(Y), MIN(Y)
  FROM sfpd_incidents
  WHERE X != 0 AND Y != 0
  GROUP BY PdDistrict
~~~

The result:

| PdDistrict |     MAX(X)     |       AVG(X)       |     MIN(X)     |    MAX(Y)    |      AVG(Y)      |    MIN(Y)    |
|------------|----------------|--------------------|----------------|--------------|------------------|--------------|
| BAYVIEW    | -122.365951538 | -122.3922285986806 | -122.485420227 | 37.800144196 | 37.7350376174197 | 37.708492279 |
| CENTRAL    | -122.393981934 | -122.4096411388966 | -122.434051514 | 37.808952332 | 37.7952143830767 | 37.719173431 |
| INGLESIDE  | -122.386100769 | -122.4270778636550 | -122.478347778 | 37.779884338 | 37.7247807953804 | 37.708183289 |
| MISSION    | -122.387229919 | -122.4188448716233 | -122.449745178 | 37.784496307 | 37.7592959154963 | 37.718086243 |
| NORTHERN   | -122.409019470 | -122.4261278250174 | -122.483802795 | 37.806621552 | 37.7852240473527 | 37.713249207 |
| PARK       | -122.374259949 | -122.4449593595356 | -122.507118225 | 37.784175873 | 37.7697759331827 | 37.726829529 |
| RICHMOND   | -122.371070862 | -122.4715122776177 | -122.513023376 | 37.818073273 | 37.7800756528654 | 37.762172699 |
| SOUTHERN   | -122.370742798 | -122.4057653624662 | -122.466064453 | 37.817047119 | 37.7801176826130 | 37.735931396 |
| TARAVAL    | -122.419609070 | -122.4767648852449 | -122.510337830 | 37.766033173 | 37.7374282305385 | 37.708015442 |
| TENDERLOIN | -122.395103455 | -122.4128075461490 | -122.471748352 | 37.794548035 | 37.7836961495576 | 37.730335236 |
{: .sql-table}


### Column aliases with `AS`

You may have noticed that the column headers in a result set reflect what we've supplied to the `SELECT` statement. For example:

~~~sql
SELECT PdDistrict, COUNT(*)
  FROM sfpd_incidents
  GROUP BY PdDistrict
~~~

&ndash; produces a results table with these headers:

|------------|----------|
| PdDistrict | COUNT(*) |
|------------|----------|
|            |      833 |
| BAYVIEW    |    16094 |
| CENTRAL    |    11749 |
{: .sql-table}


When exporting SQL results to a different program, it's convenient to format the headers to our liking. Most commonly, this means using more human-readable names, or __aliases__. In SQL, we do this with the `AS` keyword after the column/value we wish to alias:

~~~sql
SELECT 
    PdDistrict AS 'Police District', 
    COUNT(*) AS count_of_incidents
  FROM sfpd_incidents
  GROUP BY PdDistrict
~~~

The resulting headers:

+-----------------+--------------------+
| Police District | count_of_incidents |
+-----------------+--------------------+
|                 |                833 |
| BAYVIEW         |              16094 |
| CENTRAL         |              11749 |
| INGLESIDE       |              14711 |
| MISSION         |              18650 |
{: .sql-table}




Besides being a nice way to clean up our data results, aliasing will become very important as we deal with joining data from multiple tables, or if joining a table to _itself_. Aliases become a way to clarify _which_ thing we're referring to in dependent clauses, such as `HAVING`.

### HAVING

We know how to create a query that will return the number of rows as grouped by district and by subcategory of assault: 

~~~sql
SELECT PdDistrict, Descript, COUNT(1)
  FROM sfpd_incidents
  GROUP BY PdDistrict, Descript
~~~


What if we want to _filter_ the result set so that _only_ the groups with __more than 2,000 records__ are returned? Of course, we could do this by executing the query above, exporting to a spreadsheet, and then sorting and manually deleting rows.

But sometimes it's necessary to do this inside of SQL. For that, we have the `HAVING` clause, which works similar to the `WHERE` clause:

~~~sql
SELECT PdDistrict, Descript, COUNT(1) AS count_of_incidents
  FROM sfpd_incidents
  GROUP BY PdDistrict, Descript
  HAVING count_of_incidents > 2000
~~~

Note how I __aliased__ the `COUNT(1)` function as `count_of_incidents` and used that same alias in the `HAVING` clause. The result of this query:

| PdDistrict |           Descript          | count_of_incidents |
|------------|-----------------------------|--------------------|
| BAYVIEW    | BATTERY                     |               4693 |
| BAYVIEW    | INFLICT INJURY ON COHABITEE |               2240 |
| BAYVIEW    | THREATS AGAINST LIFE        |               4044 |
| CENTRAL    | BATTERY                     |               5462 |
| CENTRAL    | THREATS AGAINST LIFE        |               2227 |
| INGLESIDE  | BATTERY                     |               4512 |
| INGLESIDE  | INFLICT INJURY ON COHABITEE |               2319 |
| INGLESIDE  | THREATS AGAINST LIFE        |               3387 |
| MISSION    | BATTERY                     |               7226 |
| MISSION    | THREATS AGAINST LIFE        |               3502 |
| NORTHERN   | BATTERY                     |               5703 |
| NORTHERN   | THREATS AGAINST LIFE        |               3007 |
| PARK       | BATTERY                     |               2553 |
| RICHMOND   | BATTERY                     |               2196 |
| SOUTHERN   | BATTERY                     |               9196 |
| SOUTHERN   | THREATS AGAINST LIFE        |               3741 |
| TARAVAL    | BATTERY                     |               3248 |
| TARAVAL    | THREATS AGAINST LIFE        |               2282 |
| TENDERLOIN | BATTERY                     |               5248 |
| TENDERLOIN | THREATS AGAINST LIFE        |               2476 |
{: .sql-table}


#### Why not `WHERE`?

So, the first question we might have is: if `HAVING` works similar to `WHERE`, then why have `HAVING` when we could just use `WHERE`? For example:

~~~sql
SELECT PdDistrict, Descript, COUNT(1) AS count_of_incidents
  FROM sfpd_incidents
  WHERE count_of_incidents > 2000
  GROUP BY PdDistrict, Descript  
~~~

In MySQL, you'll receive this error:

    ERROR 1054 (42S22): Unknown column 'count_of_incidents' in 'where clause'

Apparently, column aliases aren't yet resolved by the time the `WHERE` clause does its business, so thus an alias will be "unknown" in the `WHERE` clause.

OK, no problem. `count_of_incidents` is merely `COUNT(1)`, so let's not even use the alias:

~~~sql
SELECT PdDistrict, Descript, COUNT(1)
  FROM sfpd_incidents
  WHERE COUNT(1) > 2000
  GROUP BY PdDistrict, Descript  
~~~


This will return an even more opaque error message:

    ERROR 1111 (HY000): Invalid use of group function

To make sense of this error message, think of where `WHERE` occurs in the query. It happens _before_ the `GROUP BY` clause. Without knowing the exact internals of the SQL engine, we might speculate that the `COUNT(1)` function doesn't get computed until the `GROUP BY` clause. And so `WHERE` just can't make sense of the `COUNT(1)` function.

Also, remember that `WHERE` is used to filter down a dataset based on columnar values, for example, to retrieve just the records from the `CENTRAL` and `MISSION` districts:

~~~sql
SELECT PdDistrict, Descript, COUNT(1) AS count_of_incidents
  FROM sfpd_incidents
  WHERE PdDistrict IN('CENTRAL', 'MISSION')
  GROUP BY PdDistrict, Descript  
~~~

Presumably, we want the `COUNT` aggregate of this filtered set, so it makes sense that we have another way to do a conditional statement &ndash; i.e. `HAVING` &ndash; and that it should appear _after_ the `GROUP BY`:

~~~sql
SELECT PdDistrict, Descript, COUNT(1) AS count_of_incidents
  FROM sfpd_incidents
  WHERE PdDistrict IN('CENTRAL', 'MISSION')
  GROUP BY PdDistrict, Descript
  HAVING count_of_incidents > 1000
~~~


Note: We could place the conditional statements in `HAVING` and not even have the `WHERE` clause:

~~~sql
SELECT PdDistrict, Descript, COUNT(1) AS count_of_incidents
  FROM sfpd_incidents
  GROUP BY PdDistrict, Descript
  HAVING count_of_incidents > 1000 
    AND PdDistrict IN('CENTRAL', 'MISSION') 
~~~

This technically returns the same result set. There are reasons (some of them related to performance) _not_ to do this, though I'm not an expert on how different flavors of SQL react to it. But please, let `HAVING` have just the aggregate and aliased values, and leave the rest to `WHERE`.


### Conclusion

With aggregate functions, we've reached roughly the same ability to summarize a dataset as we did with spreadsheets and pivot tables. But the syntax we've covered is non-trivial, to say the least. Keep practicing, and mind where you have put your `WHERE` and `HAVING ` clauses.
