---
layout: tutorial
title: SQL Inner joins
description: Where the fun in SQL begins
date: 2014-10-15
---

Up to now, we've only worked with one data table at a time. Most of the real world's interesting insights are spread across multiple tables. With SQL, we can __join__ tables &ndash; in essence, creating brand new data sets to perform searches and aggregations across.

This is an incredibly powerful ability, even more useful than being able to crunch all the data rows in a massive, but singular data table. It does add a new layer of syntax to our queries &ndash; you'll want to be especially mindful of __column aliasing__ and selection. &ndash; but not much given how much more expansive it makes our data powers.



--------------
> Note: For this SQL lesson, I will be using MySQL and the Sequel Pro GUI. The queries and concepts should be the same as they are with SQLite.
> 
> - [http://stash.padjo.org/dumps/sql/congress_twitter.sql.zip](MySQL dump of Congress and Twitter data)
> - [http://stash.padjo.org/dumps/sql/congress_twitter.sqlite.zip](SQLite dump of Congress and Twitter data)
---------------


### Multiple tables

![img](files/lectures/2014-10-16/congress-db-opening.png)

After creating a database and importing the dump of Congress-Twitter data, we notice that there are __five__ tables to work with:

- `members` - all the sitting members of Congress, as of Oct. 16, 2014, via the [github/unitedstates repo](https://github.com/unitedstates/congress)
- `social_accounts` - the _known_ social media accounts for Congressmembers, as of Oct. 16, 2014, also from the [github/unitedstates repo](https://github.com/unitedstates/congress). For the purposes of this tutorial, we care about their Twitter accounts.
- `terms` - Each term for each of the current Congressmembers, i.e. every time they've served in Congress. Some members may have moved districts or chambers (House to Senate) over their careers
- `twitter_profiles` - The twitter profile data for each of the Twitter accounts in the `social accounts` table. The data fields come from the [official Twitter API for users/show](https://dev.twitter.com/rest/reference/get/users/show).
- `tweets` - The past 3,200 tweets for each of the `twitter_profiles`. The data fields come from [the official Twitter API for statuses/user_timeline](https://dev.twitter.com/rest/reference/get/statuses/user_timeline) 



### Structure of a join

~~~sql

SELECT [columns from table_x, columns from table_y]
FROM table_x
JOIN table_y
 ON table_x.some_id_field = table_y.some_id_field
WHERE [some conditions]

~~~

The `ON` keyword specifies what criteria to use to decide that a row in `table_x` should be joined with a corresponding row in `table_y`:


~~~sql
  SELECT social_accounts.twitter_screen_name, members.first_name, members.last_name, members.party
    FROM members
    INNER JOIN social_accounts
      ON social_accounts.bioguide_id = members.bioguide_id
    WHERE members.state = 'CA' AND members.gender = 'F'
    ORDER BY members.last_name
~~~


Result:

|---------------------|------------|----------------|----------|
| twitter_screen_name | first_name |   last_name    |  party   |
|---------------------|------------|----------------|----------|
| RepKarenBass        | Karen      | Bass           | Democrat |
| SenatorBoxer        | Barbara    | Boxer          | Democrat |
| JuliaBrownley26     | Julia      | Brownley       | Democrat |
| RepLoisCapps        | Lois       | Capps          | Democrat |
| RepJudyChu          | Judy       | Chu            | Democrat |
| RepSusanDavis       | Susan      | Davis          | Democrat |
| RepAnnaEshoo        | Anna       | Eshoo          | Democrat |
| SenFeinstein        | Dianne     | Feinstein      | Democrat |
| Rep_JaniceHahn      | Janice     | Hahn           | Democrat |
| RepBarbaraLee       | Barbara    | Lee            | Democrat |
| RepZoeLofgren       | Zoe        | Lofgren        | Democrat |
| DorisMatsui         | Doris      | Matsui         | Democrat |
| GraceNapolitano     | Grace      | Napolitano     | Democrat |
| RepMcLeod           | Gloria     | Negrete McLeod | Democrat |
| NancyPelosi         | Nancy      | Pelosi         | Democrat |
| RepRoybalAllard     | Lucille    | Roybal-Allard  | Democrat |
| LorettaSanchez      | Loretta    | Sanchez        | Democrat |
| RepLindaSanchez     | Linda      | Sánchez        | Democrat |
| RepSpeier           | Jackie     | Speier         | Democrat |
| MaxineWaters        | Maxine     | Waters         | Democrat |
{: .sql-table}




#### Other resources

- [A Gentle Introduction to SQL Using SQLite, Part III](https://github.com/tthibo/SQL-Tutorial/blob/master/tutorial_files/part3.textile)

- [A Visual Explanation of SQL Joins](http://blog.codinghorror.com/a-visual-explanation-of-sql-joins/)
