---
layout: tutorial
title: Grouping in SQL
description: Simple aggregations of results 
date: 2014-10-06
---


At this point, we know how create flexible, fine-tuned filters for our database queries using the `WHERE` clause and `LIKE` operators (among many other operators). But we still can't do some of the basic functions that even a Pivot Table newbie can do, such as: get a __count__ of incident reports by _year_, or, listing all the ways a report of `THREATS TO SCHOOL TEACHERS` is resolved, or, of course, counting all the ways those threats have been resolved, by year, by police district, and so forth.

In this lesson, we learn how to simply _group_ the records. We won't do anything particularly interesting, but as this adds an entirely new clause to our already length SQL queries, it's worth slowing down a bit.


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



### Concept of `GROUP BY`

Before we actually look at the syntax of the `GROUP BY` clause, it's important to understand the concept: it will, well, _group_ together the records that _share_ the same value in a given column.

Let's take a very simple dataset:

|   Fruit    | Season | Is_Profitable |
|------------|--------|---------------|
| Apples     | Fall   | Yes           |
| Oranges    | Fall   | No            |
| Apples     | Winter | No            |
| Oranges    | Winter | No            |
| Apples     | Spring | Yes           |
| Oranges    | Spring | No            |
| Pineapples | Spring | No            |
| Apples     | Summer | No            |
| Oranges    | Summer | Yes           |
| Pineapples | Summer | No            |
|            |        |               |
{: .data-table}

If we were to `GROUP BY` the `Fruit`, and simply show the resulting `Fruit` column, it would look like this, because there are only three values of `Fruit`:

|   Fruit    |
|------------|
| Apples     |
| Oranges    |
| Pineapples |
{: .data-table}


Similarly, if we were to `GROUP BY` the `Season` column, the result would be:


| Season |
|--------|
| Fall   |
| Winter |
| Spring |
| Summer |
{: .data-table}



Now, if we were to `GROUP BY` __two__ columns &ndash; `Fruit` and `Is_Profitable` &ndash; and then show the resulting `Fruit` and `Is_Profitable` columns, the results would give us every combination of `Fruit` and `Is_Profitable` value:


|   Fruit    | Is_Profitable |
|------------|---------------|
| Apples     | Yes           |
| Apples     | No            |
| Oranges    | Yes           |
| Oranges    | No            |
| Pineapples | No            |


Because there is not a row in which the `Fruit` is `'Pineapples'` and the `Is_Profitable` is equal to `'Yes'`, only 5 results out of a possible 6 combinations are shown.


### Syntax of `GROUP BY`

Among the keywords and clauses we've learned so far, `GROUP BY` comes at the very end. To group the `sfpd_incidents` by `PdDistrict` &ndash; _without_ a `WHERE` clause, we write:

~~~sql
SELECT * FROM sfpd_incidents
GROUP BY PdDistrict
~~~

Which results in:

|------------|----------|-----------------------------------------|------------|-------|------------|----------------|----------------------------------|----------------|--------------|
| IncidntNum | Category |                 Descript                |    Date    |  Time | PdDistrict |   Resolution   |             Location             |       X        |      Y       |
|------------|----------|-----------------------------------------|------------|-------|------------|----------------|----------------------------------|----------------|--------------|
|  030000161 | ASSAULT  | AGGRAVATED ASSAULT WITH A DEADLY WEAPON | 2003-01-01 | 00:25 |            | ARREST, BOOKED | UNKNOWN                          |    0.000000000 |  0.000000000 |
|  030204711 | ASSAULT  | INFLICT INJURY ON COHABITEE             | 2003-02-18 | 20:40 | BAYVIEW    | ARREST, BOOKED | 1900 Block of JENNINGS ST        | -122.387695312 | 37.728080750 |
|  030204181 | ASSAULT  | BATTERY                                 | 2003-02-18 | 18:15 | CENTRAL    | ARREST, BOOKED | 300 Block of COLUMBUS AV         | -122.407066345 | 37.798183441 |
|  030205361 | ASSAULT  | BATTERY                                 | 2003-02-19 | 01:20 | INGLESIDE  | ARREST, CITED  | 5200 Block of DIAMOND HEIGHTS BL | -122.437934875 | 37.743717194 |
|  030205117 | ASSAULT  | BATTERY                                 | 2003-02-10 | 21:44 | MISSION    | NONE           | 1300 Block of NATOMA ST          | -122.418441772 | 37.767608643 |
|  030004947 | ASSAULT  | THREATS AGAINST LIFE                    | 2003-01-01 | 20:45 | NORTHERN   | NONE           | 400 Block of IVY ST              | -122.425025940 | 37.777065277 |
|  003032800 | ASSAULT  | BATTERY                                 | 2003-04-10 | 10:16 | PARK       | ARREST, BOOKED | 300 Block of WOODSIDE AV         | -122.452194214 | 37.745666504 |
|  030077950 | ASSAULT  | THREATS AGAINST LIFE                    | 2003-01-19 | 13:30 | RICHMOND   | NONE           | 2700 Block of GEARY BL           | -122.448570251 | 37.782341003 |
|  030206159 | ASSAULT  | BATTERY OF A POLICE OFFICER             | 2003-02-19 | 09:30 | SOUTHERN   | ARREST, BOOKED | 400 Block of NATOMA ST           | -122.406684875 | 37.781009674 |
|  030014645 | ASSAULT  | THREATS AGAINST LIFE                    | 2003-01-04 | 14:40 | TARAVAL    | NONE           | 1200 Block of 48TH AV            | -122.508277893 | 37.763858795 |
|  030204329 | ASSAULT  | BATTERY                                 | 2003-02-18 | 19:00 | TENDERLOIN | ARREST, BOOKED | 300 Block of ELLIS ST            | -122.412330627 | 37.784889221 |
{: .sql-table}

Only __11__ rows are returned: one for each of the __10__ police districts and __1__ row to represent records that have an empty `PdDistrict`.


The first thing to realize is: __none__ of the other columns in this table are relevant. For example, this result row corresponding to the `'Tenderloin'` police district:

|------------|----------|-----------------------------------------|------------|-------|------------|----------------|----------------------------------|----------------|--------------|
| IncidntNum | Category |                 Descript                |    Date    |  Time | PdDistrict |   Resolution   |             Location             |       X        |      Y       |
|------------|----------|-----------------------------------------|------------|-------|------------|----------------|----------------------------------|----------------|--------------|
|  030204329 | ASSAULT  | BATTERY                                 | 2003-02-18 | 19:00 | TENDERLOIN | ARREST, BOOKED | 300 Block of ELLIS ST            | -122.412330627 | 37.784889221 |

&ndash; happens to have an `IncidntNum` of `030204329` and `Resolution` of `'ARREST, BOOKED'` probably because incident number `030204329` is the first incident in our data table that had a `PdDistrict` of `'TENDERLOIN'`.

In other words, you should typically just `SELECT` the columns you're grouping by (and any aggregate calculations you might do, which we'll get to later):

~~~sql
SELECT PdDistrict FROM sfpd_incidents
GROUP BY PdDistrict
~~~


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



#### Grouping by multiple columns

To group by multiple columns, supply a __comma-separated__ list of columns. The following query will return a list of every combination of `Descript` and `Resolution`:

~~~sql
SELECT Descript, Resolution FROM sfpd_incidents
GROUP BY Descript, Resolution
~~~

This will result in __321__ result rows. Note that the order of `Descript` and `Resolution` in the `GROUP BY` clause doesn't matter, just as "`x` _times_ `y`" is _equal to_ "`y` _times_ `x`"



#### With `WHERE`

The `WHERE` clause comes _before_ the `GROUP BY` clause, which means that only rows that are accepted by the filter will end up in the grouping fun.

For example, we previously retrieved a list of all police districts with this query:

~~~sql
SELECT PdDistrict FROM sfpd_incidents
GROUP BY PdDistrict
~~~


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

Now, to get a list of all the police districts that dealt with at least one reported `'BATTERY'` committed _against_ a police officer: 

~~~sql
SELECT PdDistrict, Descript  
  FROM sfpd_incidents
  WHERE Descript = 'BATTERY OF A POLICE OFFICER'
  GROUP BY PdDistrict
~~~

Note that we only `GROUP BY` the `PdDistrict` column because there will only be one `Descript` value to group against anyway.


The result is __11__ rows (so, apparently all of them):

+------------+-----------------------------+
| PdDistrict | Descript                    |
+------------+-----------------------------+
|            | BATTERY OF A POLICE OFFICER |
| BAYVIEW    | BATTERY OF A POLICE OFFICER |
| CENTRAL    | BATTERY OF A POLICE OFFICER |
| INGLESIDE  | BATTERY OF A POLICE OFFICER |
| MISSION    | BATTERY OF A POLICE OFFICER |
| NORTHERN   | BATTERY OF A POLICE OFFICER |
| PARK       | BATTERY OF A POLICE OFFICER |
| RICHMOND   | BATTERY OF A POLICE OFFICER |
| SOUTHERN   | BATTERY OF A POLICE OFFICER |
| TARAVAL    | BATTERY OF A POLICE OFFICER |
| TENDERLOIN | BATTERY OF A POLICE OFFICER |
{: .sql-table}


`'BATTERY OF A POLICE OFFICER'` is only one possible police-officer-involved `Descript` value. Let's use a wildcard to catch all the variations and `GROUP BY` two fields: `PdDistrict` and `Descript`:

~~~sql
SELECT PdDistrict, Descript  
  FROM sfpd_incidents
  WHERE Descript LIKE '%POLICE OFFICER%'
  GROUP BY PdDistrict, Descript
~~~


Result:


| PdDistrict |                      Descript                     |
|------------|---------------------------------------------------|
|            | AGGRAVATED ASSAULT OF POLICE OFFICER,BODILY FORCE |
|            | ASSAULT ON A POLICE OFFICER WITH A DEADLY WEAPON  |
|            | BATTERY OF A POLICE OFFICER                       |
| BAYVIEW    | AGGRAVATED ASSAULT OF POLICE OFFICER, SNIPING     |
| BAYVIEW    | AGGRAVATED ASSAULT OF POLICE OFFICER,BODILY FORCE |
| BAYVIEW    | AGGRAVATED ASSAULT ON POLICE OFFICER WITH A GUN   |
| BAYVIEW    | AGGRAVATED ASSAULT ON POLICE OFFICER WITH A KNIFE |
| BAYVIEW    | ASSAULT ON A POLICE OFFICER WITH A DEADLY WEAPON  |
| BAYVIEW    | BATTERY OF A POLICE OFFICER                       |
| CENTRAL    | AGGRAVATED ASSAULT OF POLICE OFFICER,BODILY FORCE |
| CENTRAL    | AGGRAVATED ASSAULT ON POLICE OFFICER WITH A GUN   |
| CENTRAL    | AGGRAVATED ASSAULT ON POLICE OFFICER WITH A KNIFE |
| CENTRAL    | ASSAULT BY POLICE OFFICER                         |
| CENTRAL    | ASSAULT ON A POLICE OFFICER WITH A DEADLY WEAPON  |
| CENTRAL    | BATTERY OF A POLICE OFFICER                       |
| INGLESIDE  | AGGRAVATED ASSAULT OF POLICE OFFICER,BODILY FORCE |
| INGLESIDE  | AGGRAVATED ASSAULT ON POLICE OFFICER WITH A GUN   |
| INGLESIDE  | AGGRAVATED ASSAULT ON POLICE OFFICER WITH A KNIFE |
| INGLESIDE  | ASSAULT BY POLICE OFFICER                         |
| INGLESIDE  | ASSAULT ON A POLICE OFFICER WITH A DEADLY WEAPON  |
| INGLESIDE  | BATTERY OF A POLICE OFFICER                       |
| MISSION    | AGGRAVATED ASSAULT OF POLICE OFFICER, SNIPING     |
| MISSION    | AGGRAVATED ASSAULT OF POLICE OFFICER,BODILY FORCE |
| MISSION    | AGGRAVATED ASSAULT ON POLICE OFFICER WITH A GUN   |
| MISSION    | AGGRAVATED ASSAULT ON POLICE OFFICER WITH A KNIFE |
| MISSION    | ASSAULT ON A POLICE OFFICER WITH A DEADLY WEAPON  |
| MISSION    | BATTERY OF A POLICE OFFICER                       |
| NORTHERN   | AGGRAVATED ASSAULT OF POLICE OFFICER,BODILY FORCE |
| NORTHERN   | AGGRAVATED ASSAULT ON POLICE OFFICER WITH A GUN   |
| NORTHERN   | AGGRAVATED ASSAULT ON POLICE OFFICER WITH A KNIFE |
| NORTHERN   | ASSAULT BY POLICE OFFICER                         |
| NORTHERN   | ASSAULT ON A POLICE OFFICER WITH A DEADLY WEAPON  |
| NORTHERN   | BATTERY OF A POLICE OFFICER                       |
| PARK       | AGGRAVATED ASSAULT OF POLICE OFFICER,BODILY FORCE |
| PARK       | AGGRAVATED ASSAULT ON POLICE OFFICER WITH A KNIFE |
| PARK       | ASSAULT ON A POLICE OFFICER WITH A DEADLY WEAPON  |
| PARK       | BATTERY OF A POLICE OFFICER                       |
| RICHMOND   | AGGRAVATED ASSAULT OF POLICE OFFICER,BODILY FORCE |
| RICHMOND   | AGGRAVATED ASSAULT ON POLICE OFFICER WITH A KNIFE |
| RICHMOND   | ASSAULT ON A POLICE OFFICER WITH A DEADLY WEAPON  |
| RICHMOND   | BATTERY OF A POLICE OFFICER                       |
| SOUTHERN   | AGGRAVATED ASSAULT OF POLICE OFFICER,BODILY FORCE |
| SOUTHERN   | AGGRAVATED ASSAULT ON POLICE OFFICER WITH A GUN   |
| SOUTHERN   | AGGRAVATED ASSAULT ON POLICE OFFICER WITH A KNIFE |
| SOUTHERN   | ASSAULT BY POLICE OFFICER                         |
| SOUTHERN   | ASSAULT ON A POLICE OFFICER WITH A DEADLY WEAPON  |
| SOUTHERN   | BATTERY OF A POLICE OFFICER                       |
| TARAVAL    | AGGRAVATED ASSAULT OF POLICE OFFICER,BODILY FORCE |
| TARAVAL    | AGGRAVATED ASSAULT ON POLICE OFFICER WITH A GUN   |
| TARAVAL    | AGGRAVATED ASSAULT ON POLICE OFFICER WITH A KNIFE |
| TARAVAL    | ASSAULT ON A POLICE OFFICER WITH A DEADLY WEAPON  |
| TARAVAL    | BATTERY OF A POLICE OFFICER                       |
| TENDERLOIN | AGGRAVATED ASSAULT OF POLICE OFFICER,BODILY FORCE |
| TENDERLOIN | AGGRAVATED ASSAULT ON POLICE OFFICER WITH A GUN   |
| TENDERLOIN | AGGRAVATED ASSAULT ON POLICE OFFICER WITH A KNIFE |
| TENDERLOIN | ASSAULT ON A POLICE OFFICER WITH A DEADLY WEAPON  |
| TENDERLOIN | BATTERY OF A POLICE OFFICER                       |
{: .sql-table}


If we wanted to find the number of police districts that had at least one `POLICE OFFICER` incident in the year 2006, we just add to the `WHERE` conditions:

~~~sql
SELECT PdDistrict, Descript  
  FROM sfpd_incidents
  WHERE 
    Descript LIKE '%POLICE OFFICER%'
    AND Date LIKE '2006%'
  GROUP BY PdDistrict, Descript
~~~


Note that again, we don't have to group by (or `SELECT`) the `Date` field because the `WHERE` filter should limit all records to those that happened in `2006`.


### Conclusion

That's it. If you're wondering, _Hey, I don't want to know just if a police district had a certain kind of report. I want to know the count of those reports per district_ &ndash; good idea! We'll cover that in the next lesson on __aggregate functions__.
