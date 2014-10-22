---
layout: tutorial
title: Datatypes in SQL databases
description: "The differences between a number, a string, and a date"
date: 2014-10-17
---

As we've seen in previous tutorials, working with SQL databases requires us to be very specific. We have to tell the SQL interpreter what columns to show, for example, and in what order, and if we're joining two tables on the same named-field, we have to specify what seems to be pretty obvious, i.e. `JOIN users ON users.name = people.name`.

So it should be no surprise that we have to specify the _kind_ of data we're working with. Just because a column contains `"Jan. 5, 2009"` doesn't mean that the database will treat it like an actual date. Hell, a database won't even treat _numbers_ like numbers without some nudging.

In this tutorial, we'll get an overview of how to specify data types in SQL databases. This can get most complicated when dealing with __dates__ and with the `NULL` state; in fact, [there's a whole separate tutorial on `NULL` which you'll want to read](/tutorials/databases/sql-null).


--------------

> Note: For this SQL lesson, I will be using MySQL and the Sequel Pro GUI. The queries and concepts should be the same as they are with SQLite. The database we will use consists of five tables:
> 
> 1. `members` - Current U.S. congressmembers as of October 2014
> 2. `terms` - The terms served by the current U.S. congressmembers
> 3. `social_accounts` - social account names for current U.S. congressmembers
> 4. `twitter_profiles` - Twitter profile data for the accounts in `social_accounts`
> 5. `tweets` - The most recent 3,200 tweets of each Twitter profile (about 800,000+ tweets altogether)
> 
> - [MySQL dump of Congress and Twitter data](http://stash.padjo.org/dumps/sql/congress_twitter.sql.zip)
> - [SQLite dump of Congress and Twitter data](http://stash.padjo.org/dumps/sql/congress_twitter.sqlite.zip)

---------------

### Excel auto-conversion

If you've used Excel (or any other modern spreadsheet), you've probably noticed that when you type something that _looks_ like a date:

![img](files/tutorials/databases/excel-date-conversion.png)

It will magically guess that you are specifying a date. And in the above example, where I write `"January 9"`, Excel will helpfully assume that I must mean `January 9, 2014`, and then convert it to the American shorthand for dates: `1/9/14`

![img](files/tutorials/databases/excel-date-conversion-presto.png)

If I really did mean `"January 4, 2014"`, then this is a nice convenience. Because it allows me to use Excel's date-based functions, such as `YEAR`.

However, if I _don't_ mean an exact date, e.g. I'm using that column to specify annual holidays and occasions that happen every year, well, Excel's auto-conversion can be a bit annoying.

An egregious example of this occurs with _numbers_. [New Jersey's zip codes](http://www.state.nj.us/infobank/njzips.htm) are 5-digits, like every other U.S. state. However, they start with `0`, e.g. `08400` for Atlantic City and `07030` for Hoboken. But to Excel, `07030` looks like `7030` with a useless `0`, and it will be happy to make an unsolicited conversion for you:

![img](files/tutorials/databases/nj-zips-excel.png)


In databases, this can result in some possible problems when trying to join different tables in which `07030` is `07030` in one table, and `7030` in another. So when importing data into a new table, we have to be specific about the datatypes of each column.



### The Structure tab for GUIs

Both SQLite Manager and Sequel Pro have a __Structure__ tab which let you edit the __Type__ of data for each column.

Here's what the Structure tab for __SQLite Manager__ looks like for the `tweets` table:

![img](files/tutorials/databases/sqlite-manager-structure-tab.png)

And this is Sequel Pro:

![img](files/tutorials/databases/sequel-pro-structure-tab.png)

### Data types

Both SQLite and MySQL (Sequel Pro) share similar terminology for data types. Here's some of the column definitions for `tweets` in SQLite:

|      Name      |   Type   |
|----------------|----------|
| id             | INTEGER  |
| user_id        | INTEGER  |
| screen_name    | VARCHAR  |
| source         | CHAR     |
| created_at     | DATETIME |
| retweet_count  | INTEGER  |
| favorite_count | INTEGER  |
{: .sql-table}

And in MySQL (Sequel Pro):

|     Field      |   Type   | Length |
|----------------|----------|--------|
| id             | BIGINT   |     16 |
| user_id        | BIGINT   |     16 |
| screen_name    | VARCHAR  |     25 |
| source         | VARCHAR  |    255 |
| created_at     | DATETIME |        |
| retweet_count  | INT      |     11 |
| favorite_count | INT      |     11 |
{: .sql-table}


#### Data type definitions

Covering everything about data types is outside the scope of this tutorial. Check the [MySQL](http://dev.mysql.com/doc/refman/5.7/en/data-type-overview.html) and [SQLite](https://www.sqlite.org/datatype3.html) reference docs for better coverage. But here's the Cliff Notes version:


|          Type          |                                                                                Description                                                                                |             Examples             |
|------------------------|---------------------------------------------------------------------------------------------------------------------------------------------------------------------------|----------------------------------|
| INTEGER or INT         | A whole number                                                                                                                                                            | -2, 128, 99999                   |
| CHAR or VARCHAR        | Strings of characters                                                                                                                                                     | "J.F.K", "John Malkovich", "042" |
| FLOAT or REAL (SQLite) | Numbers with decimal points                                                                                                                                               | 42.2, 90.0, -0.5                 |
| DATETIME or DATE       | Dates/times represented by the [ISO standard](http://www.iso.org/iso/home/standards/iso8601.htm)                                                                          | 2009-11-04, 1999-03-30 16:20:59  |
| TEXT or BLOB           | This seems like it'd be the same as CHAR or VARCHAR. But TEXT fields are reserved for **very large** fields of text. Thousands, millions, or even billions of characters. | [Imagine me pasting the entire works of Shakespeare into this column]                                  |




#### The length of data types

MySQL specifies the _size_ of a column. For a column of type `CHAR` or `VARCHAR`, i.e. text strings, a __length__ of `10` would mean that the column can hold `10` characters.

Why not make the data columns as big (or _long_) as possible? For storage and performance reasons. For most of what we cover in this course, though, that is not a real issue. It _becomes_ an issue if you ever decide to be a full-time data developer, or, more likely, you try to work with _someone else's database_, in which case you might get errors when trying to import data that's too big for a certain field. So file this under the "nice to know, check Google when it causes trouble" folder.


### Dates

Numbers and string fields are pretty straightforward. But dates and timestamps may cause you considerable grief.

Let's start off easy, with the `tweets` table in which `created_at` is conveniently defined for you as a __type__ of `DATETIME`. All the values follow the [ISO 8601 standard](http://www.iso.org/iso/home/standards/iso8601.htm). 

Therefore, a `created_at` value of this:

    2014-10-02 14:40:34

&ndash; is equivalent to: _October 2nd, 2014 at 2:40 P.M._ The ISO standard is used because each country/locale has a different way of specifying the time &ndash; e.g. `7/1/2012` can mean a very different date to an American than to a European, nevermind non-Western cultures.

One nice convenience of the ISO standard is that even if there were no `DATETIME` type, doing a standard sort on ISO-timestamps will sort them chronologically:

|      created_at     |
|---------------------|
| 2010-09-12 12:00:00 |
| 2013-04-13 12:00:00 |
| 2013-04-13 21:00:00 |
{: .sql-table}

Whereas sorting out the dates written out in English will not work, because the database will attempt to do so alphabetically:

|     created_at_in_english     |
|-------------------------------|
| April 13, 2013 at Nine PM     |
| April 13, 2013 at Twelve PM   |
| January 10, 2010 at Twelve PM |
{: .sql-table}



#### Datetime functions in MySQL

The main reason to specify a column as `DATETIME` is to have access to a bunch of useful functions. MySQL's functions are similar to Excel's:


~~~sql
SELECT created_at, 
      YEAR(created_at) AS c_year,
      MONTH(created_at) AS c_month,
      DAY(created_at) AS c_day,
      WEEKDAY(created_at) AS c_weekday,
      HOUR(created_at) AS c_hour
      FROM tweets
      ORDER BY retweet_count DESC
      LIMIT 10

~~~

The aliases aren't necessary, but I provide them as an example. And I `ORDER BY` a totally unrelated field, `retweet_count`, just to get a mix of dates.

|      created_at     | c_year | c_month | c_day | c_weekday | c_hour |
|---------------------|--------|---------|-------|-----------|--------|
| 2014-03-03 03:24:27 |   2014 |       3 |     3 |         0 |      3 |
| 2014-03-03 03:09:54 |   2014 |       3 |     3 |         0 |      3 |
| 2013-04-20 01:20:32 |   2013 |       4 |    20 |         5 |      1 |
| 2013-04-20 01:13:57 |   2013 |       4 |    20 |         5 |      1 |
| 2013-04-20 01:21:37 |   2013 |       4 |    20 |         5 |      1 |
| 2013-04-20 01:16:19 |   2013 |       4 |    20 |         5 |      1 |
| 2013-04-20 01:41:03 |   2013 |       4 |    20 |         5 |      1 |
| 2013-04-20 01:06:50 |   2013 |       4 |    20 |         5 |      1 |
| 2013-04-20 01:01:48 |   2013 |       4 |    20 |         5 |      1 |
| 2014-05-28 14:55:55 |   2014 |       5 |    28 |         2 |     14 |
{: .sql-table}


The `WEEKDAY` function is a little strange at first ([see the documentation here](http://dev.mysql.com/doc/refman/5.5/en/date-and-time-functions.html#function_weekday)). It returns a number from `0` to `6`, where `0` corresponds to __Monday__ and `6` corresponds to __Sunday__

Thus, to get a count of only the tweets that occurred on a weekend:

~~~sql
SELECT COUNT(*) from tweets
  WHERE WEEKDAY(created_at) >= 5
~~~

FYI, in the given `tweets` table, there are roughly 63,000 weekend tweets versus 790,000 weekday tweets. The total number of tweets divided by 7 (days) is about 120,000 tweets, so our Congressmembers do not spend much of their weekends tweeting, apparently.




#### Datetime functions in SQLite

So this is one of the places where SQLite is not quite as convenient as MySQL. Yes, there is a `DATETIME` column type, but we don't have access to the convenient `YEAR`, `HOUR`, etc. functions.

Instead, [we have to master the `strftime` function](https://www.sqlite.org/lang_datefunc.html), which I like to think of as short for "formatting a string from a time value", or, "string from time" . The good news is that `strftime` is a function in many other programming languages, including Ruby, PHP, Python, etc. The bad news is, it involves memorizing a long list of __format strings__. 

You can find a list of format strings in the [SQLite documentation](https://www.sqlite.org/lang_datefunc.html). Here's some of the key ones:

| format string |                        description                        | example |
|---------------|-----------------------------------------------------------|---------|
| '%Y'          | The four-digit year                                       |    2012 |
| '%m'          | The two-digit month                                       |      07 |
| '%d'          | The two-digit day of month                                |      31 |
| '%H'          | The two-digit hour                                        |      15 |
| '%M'          | The two-digit minute                                      |      59 |
| '%S'          | The two-digit second                                      |      05 |
| '%w'          | The day of week, with Sunday starting at 0, Saturday at 6 |       6 |
{: .sql-table}


The way `strftime` works is that you pass in two things:

1. A specified __format__; think of this as telling SQLite, "I want you to show me the month and year"
2. The date string, e.g. a column name like `created_at`, or a literal string like `'2012-03-12 04:12:32 PM'`

So to redo the MySQL example in SQLite:


~~~sql
SELECT created_at, 
      strftime('%Y', created_at) AS c_year,
      strftime('%m', created_at) AS c_month,
      strftime('%d', created_at) AS c_day,
      strftime('%w', created_at) AS c_weekday,
      strftime('%H', created_at) AS c_hour
      FROM tweets
      ORDER BY retweet_count DESC
      LIMIT 10
~~~

There are slight differences from MySQL besides the syntax. For example, `c_month` will return the string `"04"` instead of the number `4` because, well, we're using the `strftime` function, i.e. we're creating a _string_, not a _number_, from a _time_ value.


Another key difference, whereas MySQL's `WEEKDAY()` function designates `0`, i.e. the beginning of the week, as __Monday__, SQLite's `strftime('%w', ...)` has `0` for __Sunday__. Also, again, `strftime` returns a __string__. Therefore, your conditional has to match `'0'`, not the number `0` 


Thus, to count up the tweets that happened on a weekend with SQLite:

~~~sql
SELECT COUNT(*) from tweets
  WHERE strftime('%w', created_at) IN('0', '6')
~~~


#### Importing dates and times

What happens when you try to import a database that _doesn't_ have the datetime strings in ISO format, e.g. "Jan. 3, 2004" and "Monday, Oct. 13, 1980 7:40 PM"? Bad times. You may need to wrangle/alter the data (using a spreadsheet, or other program) _before_ importing the data.

There's a reason why I've made pre-built SQL files for the tutorials. Importing data in the wild can be a soul-crushing affair, which we'll deal with (maybe) in later lessons.


### The NULL state

In both SQLite and MySQL, columns can be defined as "allowing `NULL`". `NULL` is best thought of a __state__, i.e. we don't yet know someone's middle name so we leave it as `NULL`. But if someone doesn't have a middle name, we might put an _empty_ string there. `NULL` is _not equivalent_ to an empty string nor is it equivalent to the number `0`.

This is such an important distinction that we use a different syntax to filter for `NULL` values. Check out [this separate tutorial I've written](/tutorials/databases/sql-null).


















