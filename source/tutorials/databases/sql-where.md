---
layout: tutorial
title: Conditional filtering with WHERE
description: Starting up a SQL database and finding data
date: 2014-10-04
---

The `WHERE` clause is where SQL starts to become very interesting for searching large datasets. With `WHERE`, we can now _filter_ the results according to conditions we explicitly set, such as, "Show all incident reports __where__ the `Date` is before 2009 and the `Category` is listed as `'ASSAULT'`"

<!-- SPLIT_SUMMARY -->

The query for that looks like this:

~~~sql
SELECT * FROM sfpd_incidents
WHERE Category = 'ASSAULT'
AND Date > '2009'
~~~


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


---------------





### `WHERE` structure

The `WHERE` clause occurs in conjunction with `SELECT` and `FROM`:

~~~sql
SELECT `column_1`, `column_2`
FROM `some table`
WHERE `a conditional statement that evaluates to true or false`
~~~

The SQL query will operate on  all rows in which the `WHERE` clause evaluates to __true__.


### Simple conditionals

The simplest example of `WHERE` using our `sfpd_incidents` table looks like this:

~~~sql
SELECT * FROM sfpd_incidents
WHERE 1 = 1
~~~

Try it out. The results should look _exactly_ as they would if you _omitted_ the `WHERE` clause. Why is that? Because the statement, _"is the number 1 equal to the number 1"_ is _always_ __true__. So the `SELECT` statement operates across all rows in the `sfpd_incidents`


Now give the `WHERE` clause a statement that is _always_ __false__:

~~~sql
SELECT * FROM sfpd_incidents
WHERE 1 = 2
~~~

The result set should be __empty__, as the number 1 is _never_ equal to the number 2.


### Conditional filtering

Generally, we're interested in conditional statements that aren't [tautologies](http://en.wikipedia.org/wiki/Tautology_(rhetoric)). For example, in our dataset, we know that the assault reports contain a `Descript` field which specifies the subcategories of assaults, such as `"BATTERY"` or `"MAYHEM WITH A KNIFE`

A common form of conditional statement will look like this:

~~~sql
... WHERE column_name = 'SOME VALUE'
~~~


To retrieve only the assault reports that were described as being `STALKING`:

~~~sql
SELECT * FROM sfpd_incidents
  WHERE Descript = 'STALKING'
~~~


#### A quick note about string literals

The _value_ we want to filter for is enclosed in __single-quotes__. Double quotes will also work but single quotes are preferred. The technical description here is that single quotes denote a __string literal__. 

In programming languages, a __string__ refers to a sequence of text characters, whether it be `'a'`, `'hello world'`, or `'one plus 2'`. 

When we refer to `STALKING` as `'STALKING'`, we are telling the query interpreter that _we are interested in the string, 'STALKING', literally, as it exists in our dataset_. Compare this to the keywords `WHERE`, `SELECT`, and `FROM`...we are not interested in those as _literal_ values. Those happen to be __keywords__ integral to the SQL language.

And the column name of `Descript` is _not_ a string literal. It is a word that points to the name of a column.

So to summarize: quote marks are important, pay attention to their usage very carefully, as omitting them will likely be the most frequent source of errors at this point. And if you're new to programming, the concept of a _string literal_ will be strange. Here's an analogous example in English:

- __Alice told me my name is "Bob"__ &ndash; i.e. __My name is "Bob"__, according to someone named Alice.
- __Alice told me, "My name is 'Bob'"__ &ndash; i.e. Alice told me __that her name is actually "Bob"__

In the second example, quotation marks are used to denote the string literal of _"My name is 'Bob'"_, because I'm _quoting_ a phrase as it was spoken, literally. In the first example, the words "my name is 'Bob'" are an assertion of my identity, rather than what "James" _literally_ told me.

Confused? After writing many more queries (some of them with errors), it'll make more sense.

Read more technical notes [on string literals in SQLite's documentation](https://www.sqlite.org/lang_keywords.html.


#### A quicker note about numbers

In the given `sfpd_incidents` datafiles, the `X` and `Y` fields (longitude and latitude, respectively), are designated as __numbers__ (floating point numbers, to be kind of exact). Unlike literal strings, literal numerical values __do not need__ quote marks. In fact, setting off literal numerical values in quotes will probably return an erroneous result.

This is good:

~~~sql
SELECT X, Y 
  FROM sfpd_incidents
  WHERE X = 0
~~~

As is this:

~~~sql
SELECT X, Y 
  FROM sfpd_incidents
  WHERE X = 0.0
~~~



But this is __not good__. It might actually work, but it depends on your database configuration:

~~~sql
SELECT X, Y 
  FROM sfpd_incidents
  WHERE X = '0'
~~~

We'll cover data types, i.e. the difference between strings, numbers, dates, etc., in a different lesson. If you follow the tutorial with the provided dataset, you should be able to continue in blissful ignorance...for now.



### Negative conditions

To create a filter in which something is _not_ equal to a given value, we prefix the equals sign with an __exclamation mark__.

To retrieve all the non-`STALKING` reports:

~~~sql
SELECT * FROM  sfpd_incidents
  WHERE Descript != 'STALKING'
~~~


The result:

|------------|----------|-----------------------------------------|------------|-------|------------|----------------|---------------------------|----------------|--------------|
| IncidntNum | Category |                 Descript                |    Date    |  Time | PdDistrict |   Resolution   |          Location         |       X        |      Y       |
|------------|----------|-----------------------------------------|------------|-------|------------|----------------|---------------------------|----------------|--------------|
|  003032800 | ASSAULT  | BATTERY                                 | 2003-04-10 | 10:16 | PARK       | ARREST, BOOKED | 300 Block of WOODSIDE AV  | -122.452194214 | 37.745666504 |
|  030206159 | ASSAULT  | BATTERY OF A POLICE OFFICER             | 2003-02-19 | 09:30 | SOUTHERN   | ARREST, BOOKED | 400 Block of NATOMA ST    | -122.406684875 | 37.781009674 |
|  030204181 | ASSAULT  | BATTERY                                 | 2003-02-18 | 18:15 | CENTRAL    | ARREST, BOOKED | 300 Block of COLUMBUS AV  | -122.407066345 | 37.798183441 |
|  030204329 | ASSAULT  | BATTERY                                 | 2003-02-18 | 19:00 | TENDERLOIN | ARREST, BOOKED | 300 Block of ELLIS ST     | -122.412330627 | 37.784889221 |
|  030204329 | ASSAULT  | THREATS AGAINST LIFE                    | 2003-02-18 | 19:00 | TENDERLOIN | ARREST, BOOKED | 300 Block of ELLIS ST     | -122.412330627 | 37.784889221 |
|  030204711 | ASSAULT  | INFLICT INJURY ON COHABITEE             | 2003-02-18 | 20:40 | BAYVIEW    | ARREST, BOOKED | 1900 Block of JENNINGS ST | -122.387695312 | 37.728080750 |
{: .sql-table}



### The `AND` operator

Using the `AND` operator, we can specify multiple conditions to filter upon:

~~~sql
SELECT * FROM sfpd_incidents
  WHERE Descript = 'STALKING'
  AND Resolution = 'UNFOUNDED'
~~~


Note how `AND` is used to join multiple conditional statements, whereas with `SELECT`, we used commas to refer to multiple columns:

~~~sql
SELECT Date, Time, Location
FROM  sfpd_incidents
  WHERE Descript = 'STALKING'
  AND Resolution = 'UNFOUNDED'
~~~

The resulting dataset includes the date, time, and location of all assault reports described as `STALKING` and were considered to be `UNFOUNDED`:


|    Date    |  Time |                Location                |
|------------|-------|----------------------------------------|
| 2003-09-12 | 18:00 | 700 Block of POST ST                   |
| 2004-01-30 | 17:00 | 0 Block of SACRAMENTO ST               |
| 2006-02-06 | 08:40 | 24TH ST / BRYANT ST                    |
| 2006-12-16 | 20:50 | 2600.0 Block of MISSION ST             |
| 2007-01-19 | 09:00 | 600.0 Block of MONTGOMERY ST           |
| 2009-04-09 | 09:00 | 24TH ST / MISSION ST                   |
| 2010-01-22 | 12:00 | 100.0 Block of WOOD ST                 |
| 2010-04-05 | 07:45 | 20TH ST / CAPP ST                      |
| 2010-11-09 | 19:15 | 500.0 Block of THE EMBARCADERONORTH ST |
| 2011-03-13 | 08:39 | 1200.0 Block of STANYAN ST             |
| 2011-09-06 | 12:00 | 200.0 Block of MCALLISTER ST           |
| 2011-12-01 | 00:01 | 300.0 Block of BAY SHORE BL            |
| 2012-12-20 | 09:35 | 800.0 Block of HAMPSHIRE ST            |
{: .sql-table}


To find all `STALKING` reports which were _not_ `UNFOUNDED`:


~~~sql
SELECT Date, Time, Location
FROM  sfpd_incidents
  WHERE Descript = 'STALKING'
  AND Resolution != 'UNFOUNDED'
~~~


#### Mutually-exclusive `AND` statements

If a query includes a series of `AND` statements, then _all_ of them must be true. The following query, for example, would return an empty set:

~~~sql
SELECT * FROM sfpd_incidents
  WHERE 1 = 1 
    AND 2 = 2 
    AND 1 = 2
~~~


In the context of our current dataset, this set of `AND` statements would also be mutually exclusive:

~~~sql
SELECT * FROM sfpd_incidents
  WHERE Descript =  "THREATS AGAINST LIFE" 
    AND Descript = "STALKING"
~~~

This will return no results because each row in `sfpd_incidents` has only one type of `Descript` value. In other words, no incident report will be described as _both_ `THREATS AGAINST LIFE` _and_ `STALKING`.

### The `OR` operator

If we do want reports that have _either_ this _or_ that, we use the `OR` operator:

~~~sql
SELECT * FROM sfpd_incidents
  WHERE Descript =  "THREATS AGAINST LIFE" 
    OR Descript = "STALKING"
~~~


The following query will return all of the dataset rows even though the first `OR` statement will always be false and the second one will be true only sometimes. The third `OR` statement will _always_ be true, thus, the entire conditional test will be __true__ for every row:


~~~sql
  SELECT * FROM sfpd_incidents
  WHERE 1 = 2
    OR Descript = "STALKING"
    OR 1 = 1
~~~



### Precedence of `OR` and `AND`

A common mistake is to combine `OR` and `AND` operators in such a way that you get more or less than you actually wanted:

~~~sql
 SELECT * from sfpd_incidents
    WHERE Resolution = "UNFOUNDED" 
      AND Descript = "STALKING" OR Descript = "THREATS AGAINST LIFE"
~~~

Presumably, the author of the above query is thinking this:

> I want all records that involved an `UNFOUNDED` report of either `STALKING` __or__ `THREATS AGAINST LIFE`

However, the query interpreter reads this as:

> The user wants all records that are either:
> 
> 1. an `UNFOUNDED` report of `STALKING` 
> 2. a report of `THREATS AGAINST LIFE`


This is because `AND` has _precedence_ over the `OR` operator. 


This is not dissimilar to _order of operations_ in arithmetic:

- `10 + 20 * 2 + 10     = 60`
- `(10 + 20) * 2 + 10   = 70`
- `(10 + 20) * (2 + 10) = 360`


Thus, the original query looks like this to the interpreter:

~~~sql
 SELECT * from sfpd_incidents
    WHERE (Resolution = "UNFOUNDED" AND Descript = "STALKING") 
      OR Descript = "THREATS AGAINST LIFE"
~~~

If you run this on the 2003 to 2013 dataset, you'll end up with __27,311 rows__.




When in doubt, don't be afraid to use parentheses to be more explicit about how you want the logic to flow. To fix the original query, one pair of parentheses will do:

~~~sql
 SELECT * from sfpd_incidents
    WHERE Resolution = "UNFOUNDED" 
      AND (Descript = "STALKING" OR Descript = "THREATS AGAINST LIFE")
~~~


The result will now only have __185 rows__. In other words, there were relatively few cases of reported stalking or death threats in which the police deemed the complaint to be unfounded.

### Frequent mistakes

- Yes, even I'll muck up the order of the clauses, like: 

    ~~~sql
    SELECT Descript, Time, Date 
      WHERE Descript = "BATTERY" 
      FROM sfpd_incidents
    ~~~

- Not using quotation marks to denote literal strings:

    ~~~sql
    SELECT Descript, Time, Date 
      FROM sfpd_incidents
      WHERE Descript = BATTERY
    ~~~

- Using quote marks to incorrectly denote things as literal strings:

    ~~~sql
    SELECT Descript, Time, Date
      FROM sfpd_incidents
      WHERE 'Descript' = 'BATTERY'
      AND 'Resolution = NONE'
    ~~~

  
    Along the same lines, remember that literal numerical values _should not be set off by quote marks_. This is not recommended (though it still might work):

    ~~~sql
    SELECT Descript, Time, Date
      FROM sfpd_incidents
      WHERE X = '0'
    ~~~

    This is fine:
    ~~~sql
    SELECT Descript, Time, Date
      FROM sfpd_incidents
      WHERE X = 0
    ~~~

    (we'll cover numerical and date datatypes in a later tutorial)

- Even though SQL syntax is __case-insensitive__, when referring to a literal string value, this is not always the case with __string literals__ that you're trying to match:

   The following would work as intended:

   ~~~sql
   select descript, time, date
     from sfpd_incidents
     where descript = 'STALKING'
   ~~~

   Since all `Descript` values are uppercase in the dataset, the following _might not work_ depending on your database configuration:

   ~~~sql
   select descript, time, date
     from sfpd_incidents
     where descript = 'stalking'
   ~~~


- Creating logically exclusive (or too-inclusive) statements because you've mussed up how your `AND` and `OR` statements should be evaluated:

  This would return no results:
  ~~~sql
  SELECT * FROM sfpd_incidents
  WHERE descript = 'STALKING' 
    AND descript = 'THREATS AGAINST LIFE' 
  ~~~

  This would return more results than you likely intended, if you only cared about `UNFOUNDED` reports:

  ~~~sql
  SELECT * FROM sfpd_incidents
  WHERE Resolution = 'UNFOUNDED'
    AND Descript = 'THREATS AGAINST LIFE'
    OR Descript = 'BATTERY'
  ~~~


- Misplaced parentheses. This is OK:
  
  ~~~sql
  SELECT * FROM sfpd_incidents
    WHERE (Resolution = 'UNFOUNDED' OR Resolution = 'NONE')
      AND Descript = 'BATTERY'
  ~~~

  This will result in an error:

  ~~~sql
  SELECT * FROM sfpd_incidents
    (WHERE Resolution = 'UNFOUNDED' OR Resolution = 'NONE')
      AND Descript = 'BATTERY'
  ~~~



### Conclusion

Now we're starting to see a little of the power of SQL. What we've learned is not much different than the kind of filtering you can do in a spreadsheet. But in the next lesson, we'll learn how to do even more flexible filtering with fuzzy matching operators.


### Exercises

1. Produce a list of reports described as `"ATTEMPTED SIMPLE ASSAULT"` that were either resolved as `"ARREST, BOOKED"` or `"ARREST, CITED"`
2. Modify the previous query to restrict the results to incidents in the `SOUTHERN` police district.
3. Produce a list of reports with only the columns `Date`, `Time`, `PdDistrict`, `Descript`, `Resolution`, that _either_: 
  
    1. Took place in the `"NORTHERN"` police district that were resolved as `"UNFOUNDED"` but _not_ described as `"BATTERY"` 
    2. _Or_ took place in either the `"BAYVIEW"` or `"RICHMOND"` districts that _were_ described as `"BATTERY"` but in which the resolution was `"PSYCHOPATHIC CASE"`

    (The result should be __71 rows__, in the 2003 to 2013 dataset)

4. Simplify the following query:
    
          SELECT Date, Time, Descript, Resolution
          FROM sfpd_incidents
          WHERE (Descript = 'AGGRAVATED ASSAULT WITH A GUN'
                  OR Descript = 'THREATS AGAINST LIFE')
          AND (Descript != 'AGGRAVATED ASSAULT WITH A GUN' AND Resolution = 'NONE') 






<!-- ooh you know how to read HTML comments. Here's the answers:

4.  SELECT Date, Time, PdDistrict, Descript, Resolution 
  FROM `sfpd_incidents`
  WHERE 
    PdDistrict = "NORTHERN" 
      AND Resolution = 'UNFOUNDED' AND Descript != 'BATTERY'
  OR
    (PdDistrict = "BAYVIEW" OR PdDistrict = "RICHMOND")
    AND Descript = 'BATTERY' AND Resolution = 'PSYCHOPATHIC CASE'

    ___


  4.  SELECT Date, Time, Descript, Resolution
      FROM sfpd_incidents
      WHERE Descript = 'THREATS AGAINST LIFE'  AND Resolution = 'NONE'

-->
