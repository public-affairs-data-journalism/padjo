---
layout: tutorial
title: Fuzzy matching in SQL
description: "Finding non-exact terms with LIKE, IN, BETWEEN, and other boolean operators"
date: 2014-10-05
---


In this lesson, we'll learn ways to have more flexible, "fuzzier" filters when querying data. At the very least, knowing these keywords will save you from having to write a tedious number of conditional statements just to get variations of a data value.

<!-- SPLIT_SUMMARY -->


For example, instead of this:

~~~sql
SELECT * from sfpd_incidents
  WHERE Resolution = 'ARREST, BOOKED' OR Resolution = 'ARREST, CITED'
~~~

We have:

~~~sql
SELECT * from sfpd_incidents
  WHERE Resolution LIKE 'ARREST%'
~~~


--------------
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



### More comparison operators

So far, we've only looked at when a data field _is equal_ or _not equal_ to a given value, e.g. to find all incident reports in which the location was likely unknown or improperly geocoded:

~~~sql
SELECT * FROM sfpd_incidents
  WHERE Y = 0
~~~

But we can also look for relative comparisons, e.g. _greater than_, _less than_, and their _or equal to_ variants:



- Find all incidents north (i.e. greater than ) of `Y` coordinate `37.78`:

        SELECT * from sfpd_incidents WHERE Y > 37.78

- Find all incidents south (i.e. less than ) of `Y` coordinate `37.75`:
  
        SELECT * from sfpd_incidents WHERE Y < 37.75

- Find all incidents at or south of `Y` coordinate `37.728080750`:

        SELECT * from sfpd_incidents WHERE Y <= 37.728080750



#### Relative comparisons of string literals

The greater than/less than operators will also work for _string literals_. This will effectively select all records that begin with `"AGGRAVATED ASSAULT"`, including `"AGGRAVATED ASSUALT WITH A KNIFE"`, but not `"BATTERY"`, as `"B"` comes after any term that starts with `"A"`, when you're sorting by alphabetical order:

~~~sql
SELECT * from sfpd_incidents 
  WHERE Descript >= 'AGGRAVATED ASSAULT'
  AND Descript < 'AGGRAVATED ASSAULT ZZZZ' 
~~~


This is _not_ the ideal way to do this (we'll soon learn about `LIKE` and wildcards), but it's worth exploring the concept.

#### Dates as (hacky) string literals

This is a more of a technical aside: Because MySQL and SQLite have a significant difference in handling date/time operations, for the purposes of this lesson, I will consider them to be just _string literals_. In other words, we won't be using something like Excel's `YEAR(some_cell)` to extract just the year from `Date`.


However, there is a way around this with string literals. To get all the records in the year `2004`, we can simply define a lower bound, i.e. `"2004"` and an upper bound `"2005"`:

~~~sql
SELECT * from sfpd_incidents
  WHERE Date >= '2004'
    AND Date < '2005'
~~~

__Very important:__ This is kind of a hack for date and time values, so it'll seem awkward and finicky. The most important rule here is: __treat the numbers as string literals__. 

- This is good: `...WHERE Date >= '2012`
- This is bad: `...WHERE Date >= 2012`


To find records __by year and month__, such as April 2008, we can do: 

~~~sql
SELECT * FROM sfpd_incidents
  WHERE Date >= '2008-04'
    AND Date < '2008-05'
~~~


To find records that happened in 2012 from 9PM to before midnight, we'll throw in the time field:


~~~sql
SELECT * FROM sfpd_incidents
  WHERE Date >= '2012' 
    AND Date < '2013'
    AND Time >= '21:00'
    AND Time < '23:59'
~~~


To include the wee hours of the morning, say before 5AM, we can continue with this logic, but it'll start to look ugly:

~~~sql
SELECT * FROM sfpd_incidents
  WHERE Date >= '2012' 
    AND Date < '2013'
    AND( 
      Time >= '21:00' AND Time < '23:59'
    OR
      Time >= '00:00' AND Time < '05:00'
    )
~~~



Treating dates and times as just literal strings is an ugly hack for dealing with dates and times. We lose the ability, for example, to easily extract just the __month__ from a value of `2012-05-12` or the __hour__ from `07:30`. This means finding all crimes that happened in December will be very inconvenient using the technique above.

But it will do for now, as this syntax works on both SQLite and MySQL. We can learn more time/date specific syntax later. For this lesson, let's work with what we know for now, which is _strings_ and comparison operators.



### The `BETWEEN` operator


If you're not a fan of a forest of less-than and greater-than symbols, both SQLite and MySQL support the `BETWEEN` keyword:

So the following two queries are equivalent:

~~~sql
SELECT * FROM sfpd_incidents
  WHERE Y BETWEEN 37.75 AND 37.78
~~~

~~~sql
SELECT * FROM sfpd_incidents
  WHERE Y >= 37.75 AND Y <= 37.78
~~~



### The `IN` operator

Like `BETWEEN`, the `IN` operator can simplify a long series of `OR` statements. The following two queries are equivalent:


~~~sql
SELECT * FROM sfpd_incidents
  WHERE Descript IN( 'BATTERY OF A POLICE OFFICER', 
    'ASSAULT ON A POLICE OFFICER WITH A DEADLY WEAPON', 
    'THREATS TO SCHOOL TEACHERS')
    AND Resolution IN( 'NONE', 'UNFOUNDED')
~~~



~~~sql
SELECT * FROM sfpd_incidents
  WHERE 
      ( Descript = 'BATTERY OF A POLICE OFFICER'
       OR Descript =  'ASSAULT ON A POLICE OFFICER WITH A DEADLY WEAPON'
       OR Descript =  'THREATS TO SCHOOL TEACHERS')
    AND 
      (Resolution = 'NONE' OR Resolution = 'UNFOUNDED')
~~~



### Matching patterns with `LIKE` 


The `IN` operator is nice, but we often won't know all of the possible variations for a value. For example, how many kinds of `'AGGRAVATED ASSAULT'` are there? The `LIKE` operator lets us match by _patterns_.



#### The `%` wildcard

Using `LIKE`, we can create a conditional statement like, "Find me all records in which the description begins with the word 'AGGRAVATED ASSAULT'". With `LIKE`, we can also use the __wildcard__ symbol, `%` (percentage sign), which will match _any_ sequence of characters:

~~~sql
SELECT * FROM sfpd_incidents
WHERE Descript LIKE 'AGGRAVATED ASSAULT%'
~~~

This query will return any row in which `Descript` begins with `AGGRAVATED ASSAULT`, followed by _anything_. This will return __26,858__ records, with __8__ distinct values for `Descript`:

    AGGRAVATED ASSAULT OF POLICE OFFICER, SNIPING
    AGGRAVATED ASSAULT OF POLICE OFFICER,BODILY FORCE
    AGGRAVATED ASSAULT ON POLICE OFFICER WITH A GUN
    AGGRAVATED ASSAULT ON POLICE OFFICER WITH A KNIFE
    AGGRAVATED ASSAULT WITH A DEADLY WEAPON
    AGGRAVATED ASSAULT WITH A GUN
    AGGRAVATED ASSAULT WITH A KNIFE
    AGGRAVATED ASSAULT WITH BODILY FORCE


(Note: You might be wondering, how do you just list the distinct values of a field? We'll find out in a later lesson on the `GROUP BY` clause. For now, I'm listing the distinct `Descript` values for your convenience)

#### Prepending the `%` wildcard

The above query for `'AGGRAVATED ASSAULT%'` will match any record with any variation of words _after_ the string, `'AGGRAVATED ASSAULT'`. We can look for variations of words _before_ a given string by placing the wildcard symbol accordingly.

For example, to find all records in which `Descript` ends with `'A GUN'`:


~~~sql
SELECT * FROM sfpd_incidents
WHERE Descript LIKE '%WITH A GUN'
~~~

The different types of `Descript` in this results set are:

    AGGRAVATED ASSAULT ON POLICE OFFICER WITH A GUN
    AGGRAVATED ASSAULT WITH A GUN
    ATTEMPTED HOMICIDE WITH A GUN
    ATTEMPTED MAYHEM WITH A GUN
    MAYHEM WITH A GUN




#### Surrounded by wildcards

Are there incidents that involved a gun, but that weren't described as "something something WITH A GUN"?

Let's be even more "wild" and use two wildcard symbols:

~~~sql
SELECT * FROM sfpd_incidents
  WHERE Descript LIKE '%GUN%'
~~~

As it turns out, apparently all the assault records (2,507 of them) that have the word `"GUN"` in them, indeed take the form of, `"something something WITH A GUN"`.

What about police officer-involved incidents? The term `POLICE` occurs in the middle of the `Descript` value `'AGGRAVATED ASSAULT ON POLICE OFFICER WITH A GUN'`

Querying for all instances of `'POLICE'`:

~~~sql
SELECT * FROM sfpd_incidents
  WHERE Descript LIKE '%POLICE%'
~~~

&ndash; returns __3,171__ records, with __7__ distinct values for `Descript`:

    AGGRAVATED ASSAULT OF POLICE OFFICER, SNIPING
    AGGRAVATED ASSAULT OF POLICE OFFICER,BODILY FORCE
    AGGRAVATED ASSAULT ON POLICE OFFICER WITH A GUN
    AGGRAVATED ASSAULT ON POLICE OFFICER WITH A KNIFE
    ASSAULT BY POLICE OFFICER
    ASSAULT ON A POLICE OFFICER WITH A DEADLY WEAPON
    BATTERY OF A POLICE OFFICER



For our hacky time and date filtering, this would select all records in which the `Date` took place in May:

~~~sql
SELECT * from sfpd_incidents
  WHERE Date LIKE '%-05-%'
~~~

This would match values such as:

    2012-05-08
    2003-05-30

#### The underscore wildcard

Sometimes we don't need the kind of catch-all power of the `%` wildcard. The __underscore__ character, i.e. `_`, can act as a stand-in for a single character. For example, to catch all records in which the preposition `'OF'` or `'ON'` were used:

~~~sql
SELECT * FROM sfpd_incidents
  WHERE Descript LIKE 'AGGRAVATED ASSAULT O_'
~~~




#### `NOT LIKE`

Just as `=` has its opposite, `!=`, the opposite of `LIKE` can be expressed with `NOT LIKE`:

```sql
SELECT * FROM sfpd_incidents
  WHERE Descript NOT LIKE '%BATTERY%'
```


#### What's not to `LIKE`?

Being able to search for patterns is very powerful. However, as you can imagine, searching for `'BA%'` (e.g. everything that starts with the letters `'BA'`) is going to be more computationally complex than finding an _exact_ match for `'BATTERY'`.

It's beyond the scope of this lesson to get into SQL performance tweaking. But the general rule is, don't be more flexible than you need to be, or else what could've been a half-second query will turn into a 2-hour query as your computer dutifully and unquestioningly carries out your insanely wide-ranged search.



### Conclusion

Fuzzy matching is a powerful feature when working with messily defined data. But nothing is free, and so this more powerful kind of querying will require more time to successfully execute.

#### Exercises

1. Find all records that took place between the year 2003 and before April 2005
2. Retrieve all incident reports from the `"TENDERLOIN"`, `"CENTRAL"`, and `"MISSION"` districts that are not described as `"AGGRAVATED"`


##### Solution 1

Without the `BETWEEN` operator:

~~~sql
SELECT * FROM sfpd_incidents
  WHERE Date >= '2003' AND Date < '2005-04'
~~~

Using the 'BETWEEN' operator:

~~~sql
SELECT * FROM sfpd_incidents
  WHERE Date BETWEEN '2003-01-01' AND '2005-03-31'
~~~


##### Solution 2

~~~sql
SELECT * FROM sfpd_incidents
  WHERE PdDistrict IN('TENDERLOIN', 'MISSION', 'CENTRAL')
    AND Descript NOT LIKE '%AGGRAVATED%'
~~~



#### Other resources

[A Gentle Introduction to SQL Using SQLite, Part II](https://github.com/tthibo/SQL-Tutorial/blob/master/tutorial_files/part2.textile)
