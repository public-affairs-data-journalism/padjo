---
layout: tutorial
title: Basic SQL Inner joins
description: "Combining tables efficiently: where the fun in SQL begins"
date: 2014-10-15
---



Up to now, we've only worked with one data table at a time. Most of the real world's interesting insights are spread across multiple tables. With SQL, we can __join__ tables &ndash; in essence, creating brand new data sets to perform searches and aggregations across.

This is an incredibly powerful ability, even more useful than being able to crunch all the data rows in a massive, but singular data table. It does add a new layer of syntax to our queries &ndash; you'll want to be especially mindful of __column aliasing__ and selection. &ndash; but not much given how much more expansive it makes our data powers.

*This tutorial assumes you've completed all of the [basic SQL tutorials](/tutorials/#databases)*

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
    JOIN social_accounts
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


### Data mash


Let's take this step-by-step.

The `members` table contains `538` rows. The `social_accounts` table contains `535` rows (apparently, some members do *not* have any social media presence).

You can visualize what a `JOIN` does by imagining the two data tables being mashed together, side by side:

![img](/files/lectures/2014-10-16/table-mash-sql-join.png)


But anyone can just smush two spreadsheets together. How does the database know to do it _intelligently_, i.e. so that the entry for *Senator Barbara Boxer* in the `members` table is matched to the corresponding `SenatorBoxer` [Twitter account](https://twitter.com/SenatorBoxer)?

As you've probably noticed by now, the SQL engine doesn't do _anything_ intelligently (at least automatically), from what we can tell. We have to be very explicit with it, even telling it what columns to include via `SELECT`.

### Joining without the `ON` keyword

In the original example, I used the `ON` keyword after the `JOIN` statement:

~~~sql
...
  JOIN social_accounts
    ON social_accounts.bioguide_id = members.bioguide_id
...
~~~

Let's ignore that for now and write a simpler query:


~~~sql
 SELECT social_accounts.twitter_screen_name, members.first_name, members.last_name, members.party
    FROM members
    JOIN social_accounts;
~~~

The result will be **287,830** rows that look like this:
  
|---------------------|------------|-----------|------------|
| twitter_screen_name | first_name | last_name |   party    |
|---------------------|------------|-----------|------------|
| AaronSchock         | Robert     | Aderholt  | Republican |
| AnderCrenshaw       | Robert     | Aderholt  | Republican |
| AskGeorge           | Robert     | Aderholt  | Republican |
| AustinScottGA08     | Robert     | Aderholt  | Republican |
| BachusAL06          | Robert     | Aderholt  | Republican |
| BennieGThompson     | Robert     | Aderholt  | Republican |
| BettyMcCollum04     | Robert     | Aderholt  | Republican |
|                     |            |           |            |
{: .sql-table}


Huh? Why is a random person being associated with a bunch of different twitter handles? Take a look at the result count: __287,830__ rows. What is that the product of?

__538__ `members` multiplied by __535__ `social_accounts`

Apparently, when the `JOIN` statement is given no other instruction, it will just match _every combination_ of the first table with the second table. Hence, the __287,830__ different combinations.



### Joining with the `ON` keyword

The `JOIN` clause is similar to `WHERE` in that it will take a _conditional statement_. If &ndash; when given a row from `table_x` and another row from `table_y` &ndash; that conditional statement is __true__, then the database engine will __join__ the two rows together.

So to be pedantic: if we supply a statement that is _always true_, we will have the same __287,830__-row mashup as we did before:

~~~sql
 SELECT social_accounts.twitter_screen_name, members.first_name, members.last_name, members.party
    FROM members
    JOIN social_accounts
      ON 1 = 1;
~~~


So what conditional statement will give us a usable result?


### A shared field

In both `members` and `social_accounts`, there is a field named `bioguide_id`. Every U.S. congressmember is assigned a unique ID: so whether one table uses "Barb Boxer" and another table uses "Barbara Boxer", we know they both refer to the same senator if they both have the same `bioguide_id` for her: [b000711](http://bioguide.congress.gov/scripts/biodisplay.pl?index=b000711)

So we tell the database to join a row from `members` with a row in `social_accounts` _only if_ they _both have the same_ `bioguide_id`
:

~~~sql
  SELECT social_accounts.twitter_screen_name, members.first_name, members.last_name, members.party
    FROM members
    JOIN social_accounts
      ON social_accounts.bioguide_id = members.bioguide_id
~~~


Here's a crude illustration:

![img](/files/lectures/2014-10-16/table-sql-join-with-on.png)

### Multiple tables

Once we've connected Congressmembers to their Twitter screen names, the next step is to connect the Twitter _profile_ data, so that we can ask these kinds of questions:

- Which Congressmember has the most followers?
- Which Congressmember has been on Twitter the longest?
- Which Congressmember tweets the most frequently?
- (Repeat the above queries, but compare the numbers on a chamber and party level)

Check out the [Twitter dev docs to see the data fields associated with each Twitter profile](https://dev.twitter.com/rest/reference/get/users/show). The `twitter_profiles` table contains a subset of these fields, notably `followers_count`, `created_at`, `utc_offset` (time zone adjustment), `statuses_count` (number of tweets), and `friends_count` (number of users followed).


#### A three-way join

To connect [Senator Barbara Boxer](http://bioguide.congress.gov/scripts/biodisplay.pl?index=b000711) to the [Twitter profile of @SenatorBoxer](https://twitter.com/SenatorBoxer), we maintain the join between `members` and `social_accounts`, and join a _third_ table, `twitter_profiles`.

There is no `bioguide_id` field in `twitter_profiles`, so the join is made between `social_accounts` and `twitter_profiles`, using the respective `twitter_screen_name` and `screen_name` fields.

![img](files/tutorials/database-joins/members-social-accounts-twitter-profiles-joined.png)



~~~sql
  SELECT social_accounts.twitter_screen_name, members.first_name, members.last_name, members.party, twitter_profiles.followers_count, twitter_profiles.statuses_count, twitter_profiles.created_at

    FROM members
  
    JOIN social_accounts
      ON social_accounts.bioguide_id = members.bioguide_id

    JOIN twitter_profiles
      ON twitter_profiles.screen_name = social_accounts.twitter_screen_name
~~~


|---------------------|------------|-----------|-------------|-----------------|----------------|---------------------|
| twitter_screen_name | first_name | last_name |    party    | followers_count | statuses_count |      created_at     |
|---------------------|------------|-----------|-------------|-----------------|----------------|---------------------|
| AaronSchock         | Aaron      | Schock    | Republican  |           23375 |           2439 | 2009-03-12 14:04:15 |
| AnderCrenshaw       | Ander      | Crenshaw  | Independent |            7945 |            742 | 2009-02-06 01:48:11 |
| AskGeorge           | George     | Miller    | Democrat    |           12452 |           2513 | 2007-07-09 22:04:23 |
| AustinScottGA08     | Austin     | Scott     | Republican  |            7079 |           1343 | 2011-01-06 16:01:46 |
| BachusAL06          | Spencer    | Bachus    | Republican  |            8351 |            520 | 2009-09-29 22:15:34 |
| BennieGThompson     | Bennie     | Thompson  | Democrat    |            4250 |            366 | 2009-10-14 20:47:03 |
{: .sql-table}



#### With `WHERE`

The `WHERE` clause comes _after_ the join statements. Its role is still the same: filter out the result set (whether there are joined tables or not) based on conditionals.

This query limits the result set to Republicans in California:

~~~sql
  SELECT social_accounts.twitter_screen_name, members.first_name, members.last_name, members.party, twitter_profiles.followers_count, twitter_profiles.statuses_count, twitter_profiles.created_at

    FROM members
  
    JOIN social_accounts
      ON social_accounts.bioguide_id = members.bioguide_id

    JOIN twitter_profiles
      ON twitter_profiles.screen_name = social_accounts.twitter_screen_name

    WHERE members.party = 'Republican' AND members.state = 'CA'
~~~






### Resolving ambiguous columns

In the previous examples, I've introduced a new convention for specifying fields:

~~~sql
  SELECT social_accounts.twitter_screen_name, members.first_name, members.last_name, members.party, twitter_profiles.followers_count, twitter_profiles.statuses_count, twitter_profiles.created_at
~~~

The form is: `[name of table].[name of field inside table]`

It makes our queries look ungainly, but now that we're dealing with more than one table, there's the distinct possibility that two tables will use the same name for a column. In that situation, the SQL engine needs direction on which column in which table we're referring to.

As it so happens, the previous `SELECT` statement refers to fields that are all distinctly named across the three tables, i.e., only the `twitter_profiles` table contains the `followers_count` field. So this `SELECT` statement would work:

~~~sql
   SELECT twitter_screen_name, first_name, last_name, party, followers_count, statuses_count, created_at
~~~


However, the following query, joining `members` and `social_accounts`, will fail:

~~~sql
  SELECT bioguide_id, first_name, last_name, party
  FROM members
  JOIN social_accounts
    ON members.bioguide_id = social_accounts.bioguide_id
~~~

MySQL will squawk with this error:


> ERROR 1052 (23000): Column 'bioguide_id' in field list is ambiguous


If you're thinking, *Well, who cares if it's ambiguous? The value will be the same across both tables!* &ndash; well, yes. But this won't _always_ be the case, and when there's ambiguity, remember that we have to be _explicit_ and _exact_ as programmers:

The following `SELECT` statements would work:

~~~sql
  SELECT members.bioguide_id, first_name, last_name, party 
  ...
~~~


~~~sql
  SELECT social_accounts.bioguide_id, first_name, last_name, party 
  ...
~~~




### Conclusion

This wraps up the basic syntax for `JOIN` clauses. The keywords `JOIN` and `ON` will be among the last new query keywords that we'll learn. Most everything from here on out [will be involve new logical concepts about our data's relationships](http://en.wikipedia.org/wiki/Join_(SQL)).



#### Exercises

1. Which Congressmember has the most followers?
2. Which Congressmember has been on Twitter the longest?
3. What are the top 5 Texas Congressmembers by tweet count?
4. Which party has the most followers combined?
5. List the state and party averages of number of followers per Congressmember



#### Solutions

1 - 

~~~sql
SELECT state, first_name, last_name, followers_count
  FROM members
  JOIN social_accounts
    ON members.bioguide_id = social_accounts.bioguide_id
  JOIN twitter_profiles
    ON social_accounts.twitter_screen_name = twitter_profiles.screen_name

  ORDER BY followers_count DESC
  LIMIT 1
~~~



2 - 

~~~sql
SELECT state, first_name, last_name, created_at
  FROM members
  JOIN social_accounts
    ON members.bioguide_id = social_accounts.bioguide_id
  JOIN twitter_profiles
    ON social_accounts.twitter_screen_name = twitter_profiles.screen_name

  ORDER BY created_at ASC
  LIMIT 1
~~~


3 - 

~~~sql
SELECT first_name, last_name, statuses_count
  FROM members
  JOIN social_accounts
    ON members.bioguide_id = social_accounts.bioguide_id
  JOIN twitter_profiles
    ON social_accounts.twitter_screen_name = twitter_profiles.screen_name

  WHERE state = 'TX'
  ORDER BY statuses_count DESC
  LIMIT 5
~~~


4 - 

~~~sql
SELECT party, SUM(followers_count) as sum_followers
  FROM members
  JOIN social_accounts
    ON members.bioguide_id = social_accounts.bioguide_id
  JOIN twitter_profiles
    ON social_accounts.twitter_screen_name = twitter_profiles.screen_name

  GROUP BY party
  ORDER BY sum_followers DESC
~~~

5 - 

~~~sql
SELECT state, party, AVG(followers_count) as avgf
  FROM members
  JOIN social_accounts
    ON members.bioguide_id = social_accounts.bioguide_id
  JOIN twitter_profiles
    ON social_accounts.twitter_screen_name = twitter_profiles.screen_name

  GROUP BY state, party
  ORDER BY state, party
~~~



#### Other resources

- [A Gentle Introduction to SQL Using SQLite, Part III](https://github.com/tthibo/SQL-Tutorial/blob/master/tutorial_files/part3.textile)

- [A Visual Explanation of SQL Joins](http://blog.codinghorror.com/a-visual-explanation-of-sql-joins/)
