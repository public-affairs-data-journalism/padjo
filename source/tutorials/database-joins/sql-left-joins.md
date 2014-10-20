---
layout: tutorial
title: SQL Left Joins
description: Finding things that are in one table but not the other
date: 2014-10-19
---


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



~~~sql
SELECT COUNT(*) FROM members
   JOIN social_accounts
  ON members.bioguide_id = social_accounts.bioguide_id
  WHERE social_accounts.twitter_screen_name IS NULL
~~~





### Basic left-join

~~~sql
SELECT COUNT(*) FROM members
  LEFT JOIN social_accounts
  ON members.bioguide_id = social_accounts.bioguide_id
  WHERE social_accounts.twitter_screen_name IS NULL
~~~

### Left join `WHERE` there's `NULL`

~~~sql
SELECT COUNT(*) FROM members
  LEFT JOIN social_accounts
  ON members.bioguide_id = social_accounts.bioguide_id
  WHERE social_accounts.bioguide_id IS NULL
~~~





#### Most retweeted non-Congressmembers

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



