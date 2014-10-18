---
layout: tutorial
title: The null value
description: "Sometimes nothing can be a real cool value."
date: 2014-10-18
published: false
---

In the [previous tutorial on datatypes](/tutorials/databases/sql-data-types), we learned that there is a difference between _strings_ and _numbers_ and _dates_, that "101" is not quite the same as `101` when it comes to SQL queries and functions.

In this brief tutorial, we learn that there's a difference between what we, in non-programmer-terms, think of as _nothing_ &ndash; e.g. `0` and the empty string of `""` &ndash; and what SQL refers to as `NULL`.


![img](/files/tutorials/databases/cool-hand-luke.jpg)


> "Sometimes nothing is a real cool hand" -- [Luke](http://www.imdb.com/title/tt0061512/)

To use a clumsy cinematic metaphor, _a handful of nothing_ is what Paul Newman holds, colloquially, during a poker game in [_Cool Hand Luke_](http://www.imdb.com/title/tt0061512/). Whereas `NULL` is what you hold when you *are not in the game*. 


For us SQL programmers, there is one immediate syntactical takeaway: know the difference between:

~~~sql
  SELECT * FROM fruits 
    WHERE number_sold = 0
      AND name = ''
~~~

&ndash; and:

~~~sql
  SELECT * FROM fruits 
    WHERE number_sold IS NULL
      AND name IS NULL
~~~




### What is NULL


A tricky concept for non-programmers is the concept of the `NULL` [value](http://en.wikipedia.org/wiki/Null_(SQL)). In other programming languages, it's sometimes referred to as `nil`; in Spanish, as _nada_:

> Our nada who art in nada, nada be thy name thy kingdom nada thy will be nada in nada as it is in nada. Give us this nada our daily nada and nada us our nada as we nada our nadas and nada us not into nada but deliver us from nada; pues nada. Hail nothing full of nothing, nothing is with thee.”
> 
> -- [Ernest Hemingway, A Clean Well Lighted Place](http://www.goodreads.com/quotes/124704-our-nada-who-art-in-nada-nada-be-thy-name)

Though `NULL` has connotations of _nothingness_, it is _not_ the same as a blank value, i.e. an empty string of `""`, and it is most definitely not the same as the number _zero_.

Think of a database of `people` that contains names and _yearly income_:


| first name | middle_name | last_name | suffix | yearly_income |
|------------|-------------|-----------|--------|---------------|
| Sara       | C           | Smith     |        | 75000         |
| Nick       | R           | Johnson   | NULL   | 60000         |
| Laura      | NULL        | Jones     |        | 55000         |
| Zach       | NULL        | Butler    | Jr.    | NULL          |
| Charles    | R.          | Thompson  | III    | 0             |
|            |             |           |        |               |
{: .sql-table}


The clearest illustration of the difference between `NULL` and a value like `0` or `""` can be found in the `yearly_income`. If you wanted to get the _average_ income of the folks in the `people` table, you might want to exclude people who aren't eligible to receive an income, e.g. a child. Technically, such a person "makes" an income equivalent to $0. But how would differentiate between such a person (in the example table above, `Zach Butler Jr.`) and someone else who _is_ expected to have an income but still earned $0? (e.g. `Charles R. Thompson III`)?

If the `yearly_income` field is set to be a numeric-type of column, then we can't just add a `"NONE"` for `Butler Jr.` However, we _can_ add give him an income value of `NULL`.

So a query to find all `people` who earned 0 income would look like this:

~~~sql
SELECT * FROM people
  WHERE yearly_income = 0
~~~

However, the syntax for finding `NULL` values does _not_ use the _equals_ operator. To find all people with a `NULL` income:

~~~sql
  SELECT * FROM people
    WHERE yearly_income IS NULL
~~~

To find the inverse of that, i.e. people who are eligible to make an income:

~~~sql
  SELECT * FROM people
    WHERE yearly_income IS NOT NULL
~~~


### User-defined nothingness

In the example `people` table, look at the possible values for `suffix`:


| first name | middle_name | last_name | suffix | yearly_income |
|------------|-------------|-----------|--------|---------------|
| Sara       | C           | Smith     |        | 75000         |
| Nick       | R           | Johnson   | NULL   | 60000         |
| Zach       | NULL        | Butler    | Jr.    | NULL          |
{: .sql-table}

To reiterate: just as `0` is not equivalent to `NULL` &ndash; an empty string, i.e. `""` &ndash; is also not equivalent to `NULL`.

So here's where confusion often arises in data: what does `NULL` and a blank value mean to the _maintainer_ of the data? In the `yearly_income` case, I posited an explanation: a `NULL` value means that a person is ineligible to receive an income. _However_, that's just speculation: it could be that `NULL` means, "*The collector of this data never got around to finding this value*".

For `suffix`, a `NULL` value could mean just that: "*We haven't asked Nick R. Johnson if he is a Jr. or a Sr.*" And the blank value for Sara C. Smith could mean, "*Sara C. Smith does not have a suffix*". Or I could have the meanings switched up here. The point is, from a semantic standpoint, you might not know the difference between `NULL` and `""` and `0`. And to find the difference, you may have to tab-out of your database GUI and make a phone call or visit to the data's originating office.

If _you_ happen to be a creator of data, being aware of `NULL` and blank values _may_ be important, _especially_ if you're starting data collection from a spreadsheet or text file, and then importing into a database. Sometimes the import process may interpret a blank value as `NULL`; other times, just as an actual blank value or `0`. And spreadsheets typically don't have a native way of designating a `NULL` value.

The [Wikipedia entry on `NULL` in SQL](http://en.wikipedia.org/wiki/Null_(SQL)) has a nice summary of the controversy among programmers:

> Null has been the focus of controversy and a source of debate because of its associated three-valued logic (3VL), special requirements for its use in SQL joins, and the special handling required by aggregate functions and SQL grouping operators...
>
> For people new to the subject, a good way to remember what null means is to remember that in terms of information, "lack of a value" is not the same thing as "a value of zero"; similarly, "lack of an answer" is not the same thing as "an answer of no". For example, consider the question "How many books does Juan own?" The answer may be "zero" (we know that he owns none) or "null" (we do not know how many he owns, or doesn't own). 
> 
> In a database table, the column reporting this answer would start out with a value of null, and it would not be updated with "zero" until we have ascertained that Juan owns no books.





### Conclusion

The main point of this brief lesson was to make you __aware__ of the existence of `NULL` &ndash; some of the datasets I've imported into MySQL via Sequel Pro have treated blank values as blank. And in SQLite, the import process has treated the values as `NULL`.

At left is a table in MySQL/Sequel Pro that came in from a CSV file. Apparently, Sequel Pro considered blank values to be blank. At right, SQLite Manager treated the blank values as `NULL`, which is signified as pink-colored cells:

![img](files/tutorials/databases/null-in-sequel-pro-sqlite.png)

As a result, the following query will _not_ return the same results across the two datasets:

~~~sql
SELECT first_name, middle_name, last_name
  FROM members
  WHERE middle_name != ''
~~~

![img](files/tutorials/databases/empty-is-not-null-query.png)

So, on an immediate, practical level, you will want to know the `NULL` syntax in order to make valid queries, and you may have to check the table structure yourself to see what's going on. And if you are importing datasets on your own, now you have one more data-integrity issue to be mindful of.




