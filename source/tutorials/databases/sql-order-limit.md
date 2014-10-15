---
layout: tutorial
title: Limiting and ordering SQL results 
description: A few keywords to prettify and organize the results of SQL queries
date: 2014-10-11
---

This is the last tutorial on what I would consider "basic" SQL, that is, queries that operate on a single table. The `ORDER` and `LIMIT` functions aren't hard to figure out; they do what they say they do. Their functionality, for our purposes, is largely cosmetic. So this tutorial will mostly be a continuation of the "Let's see how complicated we can make our queries" game.

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


### `LIMIT` the number of results returned

The `LIMIT` clause takes a number and then limits the number of results to that number. For example, to return just the first row in `sfpd_incidents`:


~~~sql
SELECT * FROM sfpd_incidents LIMIT 1
~~~



#### Using `OFFSET`

If you `LIMIT` your results, but want to show, say, the __10th__ result instead of the first, you can use the `OFFSET` keyword:

~~~sql
SELECT * FROM sfpd_incidents 
  LIMIT 1
  OFFSET 9
~~~

Note: I've almost never used `OFFSET` outside of building a web application, in which I'm doing something like paginating results (i.e. showing the fifth page of 100 records, 10 records per page). Likely, you won't need `OFFSET` for doing data queries.


### `ORDER BY`

The `LIMIT` clause is frequently used with `ORDER`, because we generally don't care about the very first record in a dataset, but the first record according to a specified _order_. This is not conceptually different than doing a column sort in a spreadsheet.

The `ORDER BY` clause comes _before_ `LIMIT`; and both clauses will typically be the final pieces of a query.

For example, if we aren't sure that a dataset is chronologically ordered, we can specify that results be sorted by `Date`:

~~~sql
SELECT IncidntNum, Date, Time
  FROM sfpd_incidents
  ORDER BY Date
  LIMIT 5
~~~

Result:

|------------|------------|-------|
| IncidntNum |    Date    |  Time |
|------------|------------|-------|
|  030001448 | 2003-01-01 | 00:45 |
|  030001460 | 2003-01-01 | 08:30 |
|  030001498 | 2003-01-01 | 02:45 |
|  030001642 | 2003-01-01 | 10:00 |
|  030001664 | 2003-01-01 | 09:40 |
{: .sql-table}


The `ORDER BY` clause will take a comma-separated list of column names. In the above result set, to get a true chronological sorting, we need to do a secondary sort on the `Time` field:

~~~sql
SELECT IncidntNum, Date, Time
  FROM sfpd_incidents
  ORDER BY Date, Time
  LIMIT 5
~~~

Result:

+------------+------------+-------+
| IncidntNum | Date       | Time  |
+------------+------------+-------+
| 040507759  | 2003-01-01 | 00:01 |
| 021623770  | 2003-01-01 | 00:01 |
| 030000600  | 2003-01-01 | 00:01 |
| 030320997  | 2003-01-01 | 00:01 |
| 030470586  | 2003-01-01 | 00:01 |
+------------+------------+-------+
{: .sql-table}


Note: Unlike `GROUP BY`, the order of the columns given to `ORDER BY` _does_ matter, with priority given to the columns from left to right. For example, the following query would order results by `Time`, and only order by `Date` in the event of a tie of `Time`:


~~~sql
SELECT IncidntNum, Date, Time
  FROM sfpd_incidents
  WHERE PdDistrict = 'Southern'
  ORDER BY Time, Date
  LIMIT 5
~~~


Result:

|------------|------------|-------|
| IncidntNum |    Date    |  Time |
|------------|------------|-------|
|  030320997 | 2003-01-01 | 00:01 |
|  031421627 | 2003-02-01 | 00:01 |
|  030187004 | 2003-02-14 | 00:01 |
|  030376990 | 2003-03-28 | 00:01 |
|  030437172 | 2003-04-12 | 00:01 |
{: .sql-table}





#### `ASC` and `DESC`

By default, `ORDER BY` will return the results in __ascending__ order, i.e from `A` to `Z` and `01` to `99`. If we want to reverse that sort, we provide the `DESC` keyword (short for __descending__) after the column name.

The following query will return the latest (well, in the year 2013) results in our dataset:

~~~sql
SELECT IncidntNum, Date, Time
  FROM sfpd_incidents
  ORDER BY Date DESC, Time DESC
  LIMIT 5
~~~

The result:

|------------|------------|-------|
| IncidntNum |    Date    |  Time |
|------------|------------|-------|
|  140000037 | 2013-12-31 | 23:57 |
|  140000037 | 2013-12-31 | 23:57 |
|  131099069 | 2013-12-31 | 23:50 |
|  140002083 | 2013-12-31 | 23:50 |
|  140009829 | 2013-12-31 | 23:50 |
{: .sql-table}



### All together now

The `ORDER` and `LIMIT` clauses cap off SQL queries as we now know them:

> `SELECT` 
>   _columns, functions, and aliased columns_
> `FROM`
>   _a table_
> `WHERE`
>   _some conditional statements, including_ `LIKE`
> `GROUP BY` (optional)
>   _columns to group by_
> `HAVING` (optional)
>   _some conditional statements_
> `ORDER`
> `LIMIT` 

Here's an actual example:


~~~sql
SELECT 
    PdDistrict, Descript, 
    COUNT(*) AS report_count
  FROM sfpd_incidents
  WHERE 
    ((Date BETWEEN '2003-01-01' AND '2006-12-31')
   OR Date LIKE '2011%')
    AND Descript LIKE 'AGGRAVATED%'
    AND PdDistrict IN('CENTRAL', 'TENDERLOIN', 'SOUTHERN', 'NORTHERN') 
  GROUP BY
    PdDistrict, Descript
  HAVING 
    report_count > 500
  ORDER BY
    report_count DESC
  LIMIT 5
~~~



### Conclusion

Being able to order and limit the result set is handy when we're trying to find a single answer, such as: "In the year 2008, what was the very first incident report for the Northern district?" or "Show the top 3 districts when it comes to making arresting suspected stalkers"

This concludes our coverage of basic SQL functionality. Make sure you have a good grasp of how to properly construct these queries, because while we won't be learning much more syntax, we will be constructing [the SQL equivalent of Dickensian-length sentences](http://en.wikiquote.org/wiki/A_Tale_of_Two_Cities#Book_I_-_Recalled_to_Life).


#### Exercises

1. Find the final `'AGGRAVATED ASSAULT'` to have been reported to the `'TENDERLOIN'` district in the year 2010.
2. Show the top 3 districts when it comes to making arresting suspected stalkers.



##### Solution 1

~~~sql
SELECT * FROM sfpd_incidents
  WHERE Descript LIKE 'AGGRAVATED ASSAULT%'
    AND PdDistrict = 'TENDERLOIN'
    AND Date LIKE '2010%'
  ORDER BY Date DESC, Time DESC
  LIMIT 1
~~~


##### Solution 2

We only have to group by the `PdDistrict` field if we filter for `"STALKING"` and `"ARREST"`

~~~sql
SELECT PdDistrict, COUNT(1) AS c 
  FROM sfpd_incidents
  WHERE 
    Descript = 'STALKING'
    AND Resolution LIKE 'ARREST%'
  GROUP BY PdDistrict
  ORDER BY c DESC
  LIMIT 3
~~~
