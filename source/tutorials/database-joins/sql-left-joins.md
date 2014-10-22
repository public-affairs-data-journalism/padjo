---
layout: tutorial
title: SQL Left Joins
description: "Sometimes what's absent is more interesting than what's there."
date: 2014-10-19
---


The concept of the `LEFT JOIN` is similar to the [join clause we've studied previously](/tutorials/sql-inner-join). The standard join we've done is an "inner join", combining rows from the two tables in which there is a matching field. We can think of an inner join as including only the rows that are __inside__ the `JOIN` requirement.

A `LEFT JOIN` includes all of the results from an _inner_ join. However, it also includes rows from the "left"-side table that have _no match_ to the other (or "right"-side) table. So a `LEFT JOIN` will always have _at least_ as many results as an inner join.

The upshot? With the left join, we can quickly find out which rows exist in the "left" table that don't have a corresponding row in another table. Sometimes what's absent is more interesting than what's there.


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



## The `LEFT JOIN` versus an `INNER JOIN`

For MySQL and SQLite, the use of the `JOIN` clause is equivalent to what's known as an __inner join__. So these two statements are equivalent:

~~~sql
SELECT * FROM table_a
   JOIN table_b
   ...
~~~

~~~sql
SELECT * FROM table_a
   INNER JOIN table_b
   ...
~~~


Quick note: Another name for a `LEFT JOIN` is `LEFT OUTER JOIN`, which may help reiterate the difference between a `INNER JOIN` and `LEFT JOIN`. However, the keyword `OUTER` is _optional_, so I will always refer to it just as a `LEFT JOIN`.

### An inner join of movie stars

The cast of [Adaptation](http://www.imdb.com/title/tt0268126/)

|                           Name                           | Birthyear |
|----------------------------------------------------------|-----------|
| [Nicolas Cage](http://www.imdb.com/name/nm0000115/)      |      1964 |
| [Chris Cooper](http://www.imdb.com/name/nm0177933/)      |      1951 |
| [Brian Cox](http://www.imdb.com/name/nm0004051/)         |      1946 |
| [Maggie Gyllenhaal](http://www.imdb.com/name/nm0350454/) |      1977 |
| [Meryl Streep](http://www.imdb.com/name/nm0000658/)      |      1949 |
| [Tilda Swinton](http://www.imdb.com/name/nm0842770/)     |      1960 |
{: .sql-table}

Academy Awards:

|      Category      | Status | Year |        Name       |        Movie         |
|--------------------|--------|------|-------------------|----------------------|
| Actor              | Nom    | 2003 | Nicolas Cage      | Adaptation           |
| Actor              | Won    | 1996 | Nicolas Cage      | Leaving Las Vegas    |
| Supporting Actor   | Won    | 2003 | Chris Cooper      | Adaptation           |
| Supporting Actress | Nom    | 2010 | Maggie Gyllenhall | Crazy Heart          |
| Actor              | Won    | 2008 | Philip S. Hoffman | Capote               |
| Supporting Actor   | Nom    | 1994 | John Malkovich    | In the Line of Fire  |
| Supporting Actress | Nom    | 2000 | Catherine Keener  | Being John Malkovich |
| Actress            | Won    | 1983 | Meryl Streep      | Sophie's Choice      |
| Actress            | Nom    | 2003 | Meryl Streep      | Adaptation           |
| Supporting Actress | Won    | 2008 | Tilda Swinton     | Michael Clayton      |
{: .sql-table}

An `INNER JOIN` on the `Name` field returns rows in which the same name, e.g. `Nicolas Cage`, `Meryl Streep` show up in _both_ tables. 

~~~sql
  SELECT actors.name, actors.birthyear, awards.status, awards.year
      (awards.year - actors.birthyear) AS oscar_age
    FROM actors
    JOIN awards 
      ON awards.name = actors.name
~~~

The result of this query will effectively show all _Adaptation_ cast members who have been nominated for or won at least one Academy award:

|    actors.name    | actors.birthyear | awards.status | awards.year | oscar_age |
|-------------------|------------------|---------------|-------------|-----------|
| Nicolas Cage      |             1964 | Nom           |        2003 |        39 |
| Nicolas Cage      |             1964 | Won           |        1996 |        32 |
| Chris Cooper      |             1951 | Won           |        2003 |        52 |
| Maggie Gyllenhall |             1977 | Nom           |        2010 |        33 |
| Meryl Streep      |             1949 | Won           |        1983 |        34 |
| Meryl Streep      |             1949 | Nom           |        2003 |        54 |
| Tilda Swinton     |             1960 | Won           |        2008 |        48 |
{: .sql-table}


### A left join of movie stars

A `LEFT JOIN` contains everything than a standard `JOIN` (i.e. an `INNER JOIN`) contains _and in addition, includes_ the entries from the "left" table &ndash; in our case, the `actors` table &ndash; that have _no corresponding entry_ in the "right" table &ndash; the `awards` table:


~~~sql
  SELECT actors.name, actors.birthyear, awards.status, awards.year
      (awards.year - actors.birthyear) AS oscar_age    
    FROM actors
    LEFT JOIN awards 
      ON awards.name = actors.name
~~~

This result set has one additional row for `Brian Cox`, who has not yet made it to the Oscars. The `LEFT JOIN` allows him to make one appearance in the results table, though all of the fields relating to `awards` will be `NULL`

|    actors.name    | actors.birthyear | awards.status | awards.year | oscar_age |
|-------------------|------------------|---------------|-------------|-----------|
| Nicolas Cage      |             1964 | Nom           | 2003        | 39        |
| Nicolas Cage      |             1964 | Won           | 1996        | 32        |
| Chris Cooper      |             1951 | Won           | 2003        | 52        |
| Brian Cox         |             1946 | NULL          | NULL        | NULL      |
| Maggie Gyllenhall |             1977 | Nom           | 2010        | 33        |
| Meryl Streep      |             1949 | Won           | 1983        | 34        |
| Meryl Streep      |             1949 | Nom           | 2003        | 54        |
| Tilda Swinton     |             1960 | Won           | 2008        | 48        |
{: .sql-table}

### A left join with `NULL`

The nature of the `LEFT JOIN` makes it easy to figure out who is in the left-side table _but not in the right-side table_; because the left-side "orphans" will have `NULL` states for fields that originate from the right-side.

In our example, `Brian Cox` from the `actors` table will have `NULL`
 for `awards.status`, `awards.year`, and `oscar_age`. Now we just need to filter for these `NULL` states. 

In the following query, I check the state of `awards.name`, because it should _never_ be `NULL` if a successful join was made. I'll include `awards.name` in the `SELECT` statement just to make it obvious (though it's not necessary):


~~~sql
  SELECT actors.name, actors.birthyear, awards.name, awards.status, awards.year
      (awards.year - actors.birthyear) AS oscar_age    
    FROM actors
    LEFT JOIN awards 
      ON awards.name = actors.name
    WHERE
      awards.name IS NULL;
~~~

As expected, only one row in `actors` meets the `WHERE` condition:

| actors.name | actors.birthyear | awards.name | awards.status | awards.year | oscar_age |
|-------------|------------------|-------------|---------------|-------------|-----------|
| Brian Cox   |             1946 | NULL        | NULL          | NULL        | NULL      |
|             |                  |             |               |             |           |
{: .sql-table}



__Easy brainteaser__: What do you expect to see if we changed the above example queries so that, instead of selecting __from__ `actors` and left-joining it to `awards`, we selected from `awards` and left-joined it to `actors`?



### Basic left join with Congress twitter accounts

Back to Twitter and Congress. Not all Congressmembers have Twitter accounts. So to find the number of Congressmembers with no Twitter presence seems pretty straightforward with a standard _inner_ join:

~~~sql
SELECT members.first_name, members.last_name, social_accounts.*
  FROM members
  JOIN social_accounts
  ON members.bioguide_id = social_accounts.bioguide_id
  WHERE social_accounts.twitter_screen_name IS NULL
~~~

The result is __20__ members (note, some of these legislators do have _campaign_ Twitter accounts, but `social_accounts` [only includes their official legislative accounts](https://github.com/unitedstates/congress-legislators/edit/master/legislators-social-media.yaml):


|------------|-----------|-------------|---------------------|-----------------|--------------------------|
| first_name | last_name | bioguide_id | twitter_screen_name |   facebook_id   |        youtube_id        |
|------------|-----------|-------------|---------------------|-----------------|--------------------------|
| Kelly      | Ayotte    | A000368     | NULL                | 123436097729198 | UCe_jD6bQuBwAo4CxwUm_ztw |
| Madeleine  | Bordallo  | B001245     | NULL                | 161729837225622 | NULL                     |
| Michael    | Capuano   | C001037     | NULL                | 151168844937573 | UCvzAdbimlJksgZjEMQn0kuw |
| Wm.        | Clay      | C001049     | NULL                | 109135405838588 | UCB3yVQzlxhx3brOwaWtiXoQ |
| Bill       | Cassidy   | C001075     | NULL                | NULL            | UCUhHeN54q6CtSpOO1AlYHTA |
| Charles    | Dent      | D000604     | NULL                | 69862092533     | UCoC_r0R2M_74UVrH4A44awQ |
| Alan       | Franken   | F000457     | NULL                | NULL            | UCMFNp5ybWmz6IlSXmPacTOw |
{: .sql-table}


However, can we be _sure_ this is all of the non-political Twitterers? There are __538__ rows in `members` but only __535__ rows in `social_accounts`, which means that _[not every member has a corresponding entry for their social accounts](https://github.com/unitedstates/congress-legislators/edit/master/legislators-social-media.yaml)_. This could mean that a member has _no_ accounts whatsoever on record.

To find out who falls under this condition, we need to use a `LEFT JOIN`:

~~~sql
SELECT members.first_name, members.last_name, social_accounts.*
  FROM members
  LEFT JOIN social_accounts
  ON members.bioguide_id = social_accounts.bioguide_id
  WHERE social_accounts.twitter_screen_name IS NULL
~~~

The above query returns __24__ rows in which a Congressmember has no entry for `social_accounts.twitter_screen_name`.

#### Looking for a different `NULL`

Who are these non-sociable politicians? Our previous query includes anyone without a `social_accounts.twitter_screen_name` entry, which means it will include Congressmembers who _do_ have either a Facebook or Youtube account. 

So we need to alter our `WHERE` clause to look for `NULL` where it will _only_ be `NULL` if there isn't a corresponding entry on the right-side table (i.e. `social_accounts`).

That would be `social_accounts.bioguide_id`. Think about it; in a successful _inner_ join, `members.bioguide_id` and `social_accounts.bioguide_id` will be one and the same. In a `LEFT JOIN` though, we _also_ include `members` that have a `bioguide_id`, but have _no entry at all_ in `social_accounts`. In such an case, `social_accounts.bioguide_id` will not exist, i.e. will be `NULL`:

~~~sql
SELECT members.first_name, members.last_name, social_accounts.*
  FROM members
  LEFT JOIN social_accounts
  ON members.bioguide_id = social_accounts.bioguide_id
  WHERE social_accounts.bioguide_id IS NULL
~~~


The result:

|------------|-------------|-------------|---------------------|-------------|------------|
| first_name |  last_name  | bioguide_id | twitter_screen_name | facebook_id | youtube_id |
|------------|-------------|-------------|---------------------|-------------|------------|
| Curtis     | Clawson     | NULL        | NULL                | NULL        | NULL       |
| Ed         | Pastor      | NULL        | NULL                | NULL        | NULL       |
| Collin     | Peterson    | NULL        | NULL                | NULL        | NULL       |
| Dana       | Rohrabacher | NULL        | NULL                | NULL        | NULL       |
{: .sql-table}




### Most retweeted non-Congressmembers

We know Congress folks like to talk to and about each other. But which Twitter accounts owned by non-Congressmembers do Congressmembers like to retweet and reply to?


To get just the list of most retweeted screen_names:

~~~sql
SELECT retweeted_status_screen_name, COUNT(*) AS rts 
  FROM tweets    
  WHERE retweeted_status_screen_name IS NOT NULL
  GROUP BY retweeted_status_screen_name
  ORDER BY rts DESC
~~~

Result:

|------------------------------|------|
| retweeted_status_screen_name | rts  |
|------------------------------|------|
| speakerboehner               | 2936 |
| housecommerce                | 1737 |
| gopleader                    | 1288 |
| gopconference                |  882 |
| whitehouse                   |  882 |
| waysandmeansgop              |  807 |
| nancypelosi                  |  694 |
| houseappropsgop              |  693 |
| gopwhip                      |  640 |
| whiphoyer                    |  549 |
| [35008 total results...]     |      |
{: .sql-table}


To see which of these retweeted accounts are also Congressmembers, we do a standard join with `social_accounts` &ndash; we can skip `members` since everyone listed in `social_accounts` is a Congressmember and we don't care about any field in the `members` table.

The following query will return __502__ rows (meaning there's only 502 `social_accounts` with a `twitter_screen_name` and who have been retweeted at least once):

~~~sql
SELECT retweeted_status_screen_name, COUNT(*) AS rts 
  FROM tweets
  JOIN social_accounts ON
    retweeted_status_screen_name = social_accounts.twitter_screen_name 
  WHERE retweeted_status_screen_name IS NOT NULL
  GROUP BY retweeted_status_screen_name
  ORDER BY rts DESC
~~~


Making that `JOIN` into a `LEFT` join will return __35,008__ rows, i.e. every retweet, whether or not it has a corresponding `members.twitter_screen_name`:

~~~sql
SELECT retweeted_status_screen_name, COUNT(*) AS rts 
  FROM tweets
  LEFT JOIN social_accounts ON
    retweeted_status_screen_name = social_accounts.twitter_screen_name 
  WHERE retweeted_status_screen_name IS NOT NULL
  GROUP BY retweeted_status_screen_name
  ORDER BY rts DESC
~~~

To find __non-Congressmembers__, we add an additional condition to the `WHERE` clause:

~~~sql
SELECT retweeted_status_screen_name, COUNT(*) AS rts 
  FROM tweets
  LEFT JOIN social_accounts ON
    retweeted_status_screen_name = social_accounts.twitter_screen_name 
  WHERE retweeted_status_screen_name IS NOT NULL
    AND social_accounts.twitter_screen_name IS NULL
  GROUP BY retweeted_status_screen_name
  ORDER BY rts DESC
~~~

Nearly all of the top-retweeted accounts are related to the U.S. government, such as `WhiteHouse` or Congressional committees. Among the top 20, only [@politico](//twitter.com/politico) is not part of the U.S. government:

|------------------------------|------|
| retweeted_status_screen_name | rts  |
|------------------------------|------|
| housecommerce                | 1737 |
| whitehouse                   |  882 |
| gopconference                |  882 |
| waysandmeansgop              |  807 |
| houseappropsgop              |  693 |
| natresources                 |  521 |
| waysmeanscmte                |  519 |
| smallbizgop                  |  507 |
| housedemocrats               |  493 |
| financialcmte                |  487 |
| oversightdems                |  480 |
| housegop                     |  474 |
| edworkforce                  |  398 |
| republicanstudy              |  380 |
| gopoversight                 |  378 |
| househomeland                |  378 |
| edworkforcedems              |  330 |
| transport                    |  326 |
| politico                     |  308 |
| officialcbc                  |  299 |
{: .sql-table}



### Conclusion

As we've seen in the previous tutorials on *inner* joins, the logic and SQL syntax needed to put together multiple datasets can look quite intimidating, which can be enough to hinder most casual data explorers from seeing how two datasets are related. With just a little more syntax, `LEFT JOIN` let's us discover the instances where there are _missing_ relationships between tables, which is a whole new alley of investigative inquiry.



#### Other resources

- [A Gentle Introduction to SQL Using SQLite, Part III](https://github.com/tthibo/SQL-Tutorial/blob/master/tutorial_files/part3.textile)

- [A Visual Explanation of SQL Joins](http://blog.codinghorror.com/a-visual-explanation-of-sql-joins/)
