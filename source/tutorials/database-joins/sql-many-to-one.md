---
layout: tutorial
title: Joining on a many-to-one relationship
description: When one record has many child records
date: 2014-10-17
---

In the [previous tutorial](/tutorials/database-joins/sql-many-to-one), we learned the basics of the `JOIN` syntax and how to join one record from a table to one record from another table, e.g. a Congressmember to his/her Twitter account.

Not everything has a one-to-one relationship. For example, a Twitter account, and by extension, a Congressmember, has _many_ tweets. We refer to this as a _many-to-one_ relationship.

The syntax of `JOIN` is no different from before, so this will be more of a refresher on aggregate queries.

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


### Important note about inconsistencies

The next two sub-sections deal with __inconsistencies__ that may exist in the two database files I've provided. If you're getting unexpected results, please read these notes:

#### About case-sensitivity
Depending on your database setup, you may run into issues of _case-sensitivity_. This is a particular problem in this lesson's context, because Twitter screen names are __case-insensitive__. That is, the following URLs will go to the same page:

- [https://twitter.com/AaronSchock](https://twitter.com/AaronSchock)
- [https://twitter.com/aaronschock](https://twitter.com/aaronschock)
- [https://twitter.com/AARONSCHOCK](https://twitter.com/AARONSCHOCK)

The upshot for us is that in the provided database files, the `twitter.screen_name` in `social_accounts` may __be of a different capitalization__ than the ones in `twitter_profiles.screen_name` and `tweets.screen_name` and `tweets.` If your database config happens to be also _case-insensitive_, the following query will bring up results as expected:

~~~sql
SELECT social_accounts.twitter_screen_name, tweets.screen_name, text 
  FROM tweets
  INNER JOIN social_accounts
    ON social_accounts.twitter_screen_name = tweets.screen_name  
  LIMIT 5
~~~

Notice how `social_accounts.twitter_screen_name` is `AaronSchock` and `tweets.screen_name` is `aaronschock`:

|---------------------|-------------|----------------------------------------------------------------------------------------------------------------------------------------------|
| twitter_screen_name | screen_name |                                                                     text                                                                     |
|---------------------|-------------|----------------------------------------------------------------------------------------------------------------------------------------------|
| AaronSchock         | aaronschock | Celebrating the Illinois College Homecoming Day Parade #GoBlueboys http://t.co/AUN8ED4F8J                                                    |
| AaronSchock         | aaronschock | RT @sotexmum: @aaronschock @BruceRauner I am in #Texas. Want to move home #Illinois. Sure hope #Rauner is elected so I can pack my bags! #H… |
| AaronSchock         | aaronschock | Post Gov Debate in Peoria with Illinois' next Governor @BruceRauner  #BringBackIL #stoptheinsanity http://t.co/duuAypi6bs                    |
| AaronSchock         | aaronschock | With Evan Jenkins in West Virginia, David Rouzer and Mark Walker in North Carolina - 3 great soon to… http://t.co/cmihOBI0N6                 |
| AaronSchock         | aaronschock | With my colleague and good friend Dave Joyce in Cleveland, OH and candidate Alex Mooney who's running… http://t.co/xyizMblDe2                |
{: .sql-table}

However, this query will _not_ be the same for SQLite (and MySQL, if it's configured to be **case-sensitive**). 

Sometimes using `LIKE` instead of `=` will be case-insensitive, but again, it [depends on your database configuration](http://stackoverflow.com/questions/15480319/case-sensitive-and-insensitive-like-in-sqlite). To be _absolutely_ sure, you can use either the `LOWER` or `UPPER` [functions to transform text strings](http://stackoverflow.com/questions/341338/sql-changing-a-value-to-upper-or-lower-case) before they are compared:

~~~sql
SELECT social_accounts.twitter_screen_name, tweets.screen_name, text 
  FROM tweets
  INNER JOIN social_accounts
    ON LOWER(social_accounts.twitter_screen_name) = LOWER(tweets.screen_name)  
  LIMIT 5
~~~



To avoid confusion in this tutorial, I will be using the `LOWER` function to explicitly make an apples-to-apples comparison in the example queries.




#### About `NULL` 

In this lesson, I'll be making queries that look for either an _empty_ or `NULL` value:

~~~sql
SELECT *
  FROM tweets
  WHERE retweeted_screen_name IS NULL
  LIMIT 10
~~~

As we've [learned from the tutorial on null values](/tutorials/databases/sql-null), the above query is _not_ the same as this one:

~~~sql
SELECT *
  FROM tweets
  WHERE retweeted_screen_name = ""
  LIMIT 10
~~~

Why do we care? Because I realize that the import process for SQLite Manager and Sequel Pro have handled blank values in different ways, i.e. what's `NULL` in the SQLite version may be an __empty string__ in the SQL version. As in the case-insensitivity caveat above, your queries will have to adjust for this. Nothing too hard, just check the contents of the data to see if blank fields are marked as `NULL` (in Sequel Pro) or highlighted in pink (in SQLite Manager), then you'll use this version of the conditional: 

~~~sql
  WHERE retweeted_screen_name IS NULL
~~~



However, if blank fields are just _blank_, then you will be using this conditional: 

~~~sql
  WHERE retweeted_screen_name = ""
~~~


If you really don't know what to use, you can always be verbose about it:

~~~sql
  WHERE retweeted_screen_name = "" OR retweeted_screen_name IS NULL
~~~


#### Alter and optimize the database (recommended)

(Note: if you've downloaded the databases *after* __Oct. 20, 2014__, your versions may have these alterations already made for you (by me). Lucky you!)

The workarounds mentioned above _work_, but they may be _very_ slow. So instead of running transformation functions like `LOWER` and using broad conditional statements, we can update the contents of the data.

For example, turn all _empty_ `tweets.retweeted_status_id` into `NULL`:

~~~sql
UPDATE tweets
  SET retweeted_status_id = NULL
  WHERE retweeted_status_id = ''
~~~

And lowercase all of the `tweets.screen_name` values:

~~~sql
UPDATE tweets
  SET screen_name = LOWER(screen_name);
~~~


For your convenience, you can copy and run all of these SQL statements to get your data in a more uniform state:

~~~sql
/* normalize social_accounts */
UPDATE social_accounts
  SET twitter_screen_name = LOWER(twitter_screen_name);
UPDATE social_accounts
  SET twitter_screen_name = NULL 
  WHERE twitter_screen_name = '';
UPDATE social_accounts
  SET facebook_id = NULL 
  WHERE facebook_id = '';  
UPDATE social_accounts
  SET youtube_id = NULL 
  WHERE youtube_id = '';  

/* normalize twitter_profiles */
UPDATE twitter_profiles
  SET screen_name = LOWER(screen_name);
/* normalize tweets */
UPDATE tweets
  SET screen_name = LOWER(screen_name),
  retweeted_status_screen_name = LOWER(retweeted_status_screen_name),
  in_reply_to_screen_name = LOWER(in_reply_to_screen_name);
UPDATE tweets
  SET retweeted_status_id = NULL
  WHERE retweeted_status_id = '' OR retweeted_status_id = 0;
UPDATE tweets
  SET retweeted_status_screen_name = NULL, retweeted_status_user_id = NULL
  WHERE retweeted_status_id IS NULL;
UPDATE tweets
  SET in_reply_to_status_id = NULL
  WHERE in_reply_to_status_id = '' OR in_reply_to_status_id = 0; 
UPDATE tweets 
  SET in_reply_to_screen_name = NULL
  WHERE in_reply_to_status_id IS NULL;

/* lower case all kinds of screen_names */

~~~


All of the above data-cleaning work is routine in the real world. And also, if you're wondering why some systems use _numerical identifiers_, hopefully this discussion on case-sensitivity makes clear why such decisions are made.




### The `terms` table

Let's turn our attention from Twitter data tojust the Congressional data. The `terms` table contains the history of appointed/elected positions for every current Congressmember. 

We can join `terms` to `members` via the `bioguide_id` field. For every `member` row in which there's a matching `term` row, the results table will contain a row that smushes the two together:

~~~sql
SELECT members.bioguide_id, members.first_name, members.last_name,        
       terms.role, terms.state, terms.start, terms.end
  FROM members
  INNER JOIN terms
    ON terms.bioguide_id = members.bioguide_id
  ORDER BY members.bioguide_id    
  LIMIT 20
~~~

As you can see, Rep. Robert Aderholt has 9 rows for himself, whereas first-term senator Kelly Ayotte has just one result row:

|-------------|------------|-----------|------|-------|------------|------------|
| bioguide_id | first_name | last_name | role | state |   start    |    end     |
|-------------|------------|-----------|------|-------|------------|------------|
| A000055     | Robert     | Aderholt  | rep  | AL    | 1997-01-07 | 1998-12-19 |
| A000055     | Robert     | Aderholt  | rep  | AL    | 1999-01-06 | 2000-12-15 |
| A000055     | Robert     | Aderholt  | rep  | AL    | 2001-01-03 | 2002-11-22 |
| A000055     | Robert     | Aderholt  | rep  | AL    | 2003-01-07 | 2004-12-09 |
| A000055     | Robert     | Aderholt  | rep  | AL    | 2005-01-04 | 2006-12-09 |
| A000055     | Robert     | Aderholt  | rep  | AL    | 2007-01-04 | 2009-01-03 |
| A000055     | Robert     | Aderholt  | rep  | AL    | 2009-01-06 | 2010-12-22 |
| A000055     | Robert     | Aderholt  | rep  | AL    | 2011-01-05 | 2013-01-03 |
| A000055     | Robert     | Aderholt  | rep  | AL    | 2013-01-03 | 2015-01-03 |
| A000360     | Lamar      | Alexander | sen  | TN    | 2003-01-07 | 2009-01-03 |
| A000360     | Lamar      | Alexander | sen  | TN    | 2009-01-06 | 2015-01-03 |
| A000367     | Justin     | Amash     | rep  | MI    | 2011-01-05 | 2013-01-03 |
| A000367     | Justin     | Amash     | rep  | MI    | 2013-01-03 | 2015-01-03 |
| A000368     | Kelly      | Ayotte    | sen  | NH    | 2011-01-05 | 2017-01-03 |
| A000369     | Mark       | Amodei    | rep  | NV    | 2011-09-13 | 2013-01-03 |
| A000369     | Mark       | Amodei    | rep  | NV    | 2013-01-03 | 2015-01-03 |
| B000013     | Spencer    | Bachus    | rep  | AL    | 1993-01-05 | 1994-12-01 |
| B000013     | Spencer    | Bachus    | rep  | AL    | 1995-01-04 | 1996-10-04 |
| B000013     | Spencer    | Bachus    | rep  | AL    | 1997-01-07 | 1998-12-19 |
| B000013     | Spencer    | Bachus    | rep  | AL    | 1999-01-06 | 2000-12-15 |
{: .sql-table}


To find all Congressmembers currently serving their first term:

~~~sql
SELECT first_name, last_name, terms.role, terms.state, terms.district, 
      COUNT(*) AS term_count
  FROM members
  INNER JOIN terms
    ON terms.bioguide_id = members.bioguide_id 
  GROUP BY terms.bioguide_id
  HAVING term_count = 1; 
~~~

And to find the Congressmembers with the most terms under their belts:
~~~sql
SELECT first_name, last_name, terms.role, terms.state, terms.district, 
      COUNT(*) AS term_count
  FROM members
  INNER JOIN terms
    ON terms.bioguide_id = members.bioguide_id 
  GROUP BY terms.bioguide_id
  ORDER BY term_count DESC
  LIMIT 5
~~~


Result:

|------------|-----------|------|-------|----------|------------|
| first_name | last_name | role | state | district | term_count |
|------------|-----------|------|-------|----------|------------|
| John       | Dingell   | rep  | MI    |       15 |         30 |
| John       | Conyers   | rep  | MI    |        1 |         25 |
| Charles    | Rangel    | rep  | NY    |       18 |         22 |
| Don        | Young     | rep  | AK    |        0 |         21 |
| Edward     | Markey    | rep  | MA    |        7 |         21 |
{: .sql-table}


#### Party-switchers

If you peruse the structure of the `terms` table, you'll see that there's fields for `state`, `district`, `role`, and `party`. For most Congressmembers, these values are constant because they've been in the same elected position throughout their career. In `members`, there are fields for `current_role`, `state`, `district`, and `party`, which reflect their elective status as of October 2014.

So finding all `terms` in which the `party` is __not equal to__ the corresponding `members.party` column will identify all Congressmembers who, at one point, switched parties:

~~~sql
SELECT  members.first_name, members.last_name,  
        members.party AS current_party, terms.party AS former_party,   
        terms.state, terms.start
  FROM members
  INNER JOIN terms
  WHERE 
    members.bioguide_id = terms.bioguide_id 
      AND
    members.party != terms.party
~~~

Result:

|------------|-----------|---------------|--------------|-------|------------|
| first_name | last_name | current_party | former_party | state |   start    |
|------------|-----------|---------------|--------------|-------|------------|
| Ander      | Crenshaw  | Independent   | Republican   | FL    | 2003-01-07 |
| Ander      | Crenshaw  | Independent   | Republican   | FL    | 2005-01-04 |
| Ander      | Crenshaw  | Independent   | Republican   | FL    | 2007-01-04 |
| Ander      | Crenshaw  | Independent   | Republican   | FL    | 2009-01-06 |
| Ander      | Crenshaw  | Independent   | Republican   | FL    | 2011-01-05 |
| Ander      | Crenshaw  | Independent   | Republican   | FL    | 2013-01-03 |
| Ralph      | Hall      | Democrat      | Republican   | TX    | 2003-01-07 |
| Ralph      | Hall      | Democrat      | Republican   | TX    | 2005-01-04 |
| Ralph      | Hall      | Democrat      | Republican   | TX    | 2007-01-04 |
| Ralph      | Hall      | Democrat      | Republican   | TX    | 2009-01-06 |
| Ralph      | Hall      | Democrat      | Republican   | TX    | 2011-01-05 |
| Ralph      | Hall      | Democrat      | Republican   | TX    | 2013-01-03 |
| Richard    | Shelby    | Democrat      | Republican   | AL    | 1993-01-05 |
| Richard    | Shelby    | Democrat      | Republican   | AL    | 1999-01-06 |
| Richard    | Shelby    | Democrat      | Republican   | AL    | 2005-01-04 |
| Richard    | Shelby    | Democrat      | Republican   | AL    | 2011-01-05 |
{: .sql-table}


Another way to think about this is to query for every member who has _at least one_ term in which the `terms.party` is different from `members.party`:


~~~sql
SELECT  members.first_name, members.last_name,  
        members.party AS current_party, COUNT(*) as diff_term_count 
        FROM members
  INNER JOIN terms
  WHERE 
    members.bioguide_id = terms.bioguide_id 
      AND
    members.party != terms.party
  GROUP BY 
    members.bioguide_id
  HAVING diff_term_count >= 1
~~~

Result:

|------------|-----------|---------------|-----------------|
| first_name | last_name | current_party | diff_term_count |
|------------|-----------|---------------|-----------------|
| Ander      | Crenshaw  | Independent   |               6 |
| Ralph      | Hall      | Democrat      |               6 |
| Richard    | Shelby    | Democrat      |               4 |
{: .sql-table}


Similarly, to find all current Congressmembers who are _now_ senators but had been representatives:

~~~sql
SELECT  members.first_name, members.last_name,  
        members.current_role, COUNT(*) as diff_term_count 
        FROM members
  INNER JOIN terms
  WHERE 
    members.bioguide_id = terms.bioguide_id 
      AND
    members.current_role != terms.role
      AND
    members.current_role = 'sen'
  GROUP BY 
    members.bioguide_id
  HAVING diff_term_count >= 1
~~~

And vice versa:

~~~sql
SELECT  members.first_name, members.last_name,  
        members.current_role, COUNT(*) as diff_term_count 
        FROM members
  INNER JOIN terms
  WHERE 
    members.bioguide_id = terms.bioguide_id 
      AND
    members.current_role != terms.role
      AND
    members.current_role = 'rep'
  GROUP BY 
    members.bioguide_id
  HAVING diff_term_count >= 1
~~~

(Apparently, no one who is currently a representative was formerly a senator)




### The tweets data

The Twitter API documentation has a description of the [data fields for tweets](https://dev.twitter.com/rest/reference/get/statuses/user_timeline). The script I use to collect the tweets (and "flatten" their data structure for easy importing) can be found in my [datajanitor/diaries Github repo](https://github.com/datajanitor/diaries/tree/master/congress_twitter).

One important limitation of this database: Twitter's API only allows the retrieval of the __most recent 3,200__ tweets of any given user. For users who have tweeted more than 3,200 times, the `tweets` table will represent only a fraction of their total tweet activity.


### Tweets per Twitter account

Let's ignore the Congress-specific tables and just join `twitter_profiles` to `tweets`. Both tables have a `screen_name` field.

To find all the stored tweets for a single Twitter account:

~~~sql
SELECT name, followers_count, statuses_count, tweets.text, tweets.created_at
  FROM twitter_profiles
  INNER JOIN tweets
    ON twitter_profiles.screen_name = tweets.screen_name
  WHERE
    twitter_profiles.screen_name = 'darrellissa'
  LIMIT 5;
~~~

Results:

|--------------|-----------------|----------------|---------------------------------------------------------------------------------------------------------------------------------------------|---------------------|
|     name     | followers_count | statuses_count |                                                                     text                                                                    |      created_at     |
|--------------|-----------------|----------------|---------------------------------------------------------------------------------------------------------------------------------------------|---------------------|
| Darrell Issa |          173608 |          18725 | Issa, Vitter Investigate Natural Resources Defense Council Influence on EPA Carbon Rule http://t.co/kh6TrvC5aV                              | 2014-10-14 16:34:36 |
| Darrell Issa |          173608 |          18725 | @TriciaEdwards2 Big thanks to your dad for his service! @USNavy                                                                             | 2014-10-13 12:17:34 |
| Darrell Issa |          173608 |          18725 | Since 1775, America’s Navy has answered the call. Happy Birthday to the @USNavy! http://t.co/pj0sHFoiZM                                     | 2014-10-13 12:05:15 |
| Darrell Issa |          173608 |          18725 | Oh hey. Frieda is so excited for the weekend that she's about to jump for joy. HAPPY FRIDAY! #fridaypuppy http://t.co/ybjSQQH6hp            | 2014-10-10 21:56:30 |
| Darrell Issa |          173608 |          18725 | .@GOPoversight request from November 2012 to investigate evidence of inappropriate behavior by the White House team: http://t.co/XX21JkQyyq | 2014-10-09 16:36:06 |
{: .sql-table}


Note: The order of the tables in the `JOIN` doesn't have an impact here. Instead of `SELECT`-ing `FROM` `twitter_profiles` and `JOIN`-ing `tweets`, we could switch it around and the result will be the same:

~~~sql
SELECT name, followers_count, statuses_count, tweets.text, tweets.created_at
  FROM tweets
  INNER JOIN twitter_profiles
    ON twitter_profiles.screen_name = tweets.screen_name
  WHERE
    twitter_profiles.screen_name = 'darrellissa'
  LIMIT 5;
~~~


### Aggregate functions

Once the `JOIN` has been made, for all intents and purposes, we've created a "new" table. And on this new table, the aggregate functions work no differently than they did before.

To get the sum of retweets of one user's tweets:

~~~sql
SELECT name, twitter_profiles.screen_name, SUM(tweets.retweet_count)
  FROM tweets
  INNER JOIN twitter_profiles
    ON twitter_profiles.screen_name = tweets.screen_name
  WHERE
    twitter_profiles.screen_name = 'darrellissa'
~~~


Result:

|--------------|-------------|---------------------------|
|     name     | screen_name | SUM(tweets.retweet_count) |
|--------------|-------------|---------------------------|
| Darrell Issa | DarrellIssa |                    177490 |
|--------------|-------------|---------------------------|
{: .sql-table}


#### Group aggregate

To find out which Congressmember has the most retweets in the `tweets` data, we leave out the `WHERE` clause:

(Warning: this query might take some time)

~~~sql
SELECT name, twitter_profiles.screen_name, 
    SUM(tweets.retweet_count) AS sum_retweets
  FROM tweets
  INNER JOIN twitter_profiles
    ON twitter_profiles.screen_name = tweets.screen_name
  GROUP BY twitter_profiles.screen_name
  ORDER BY sum_retweets DESC
  LIMIT 10;
~~~


Result:

|---------------------|----------------|--------------|
|         name        |  screen_name   | sum_retweets |
|---------------------|----------------|--------------|
| Mark Takano         | RepMarkTakano  |      3498440 |
| Ann McLane Kuster   | RepAnnieKuster |      3385417 |
| Senator Ted Cruz    | SenTedCruz     |      1324676 |
| Senator Rand Paul   | SenRandPaul    |       535365 |
| Nancy Pelosi        | NancyPelosi    |       467228 |
| Ileana Ros-Lehtinen | RosLehtinen    |       436623 |
| Rep. Steve Stockman | SteveWorks4You |       384281 |
| Justin Amash        | repjustinamash |       292893 |
| Janice Hahn         | Rep_JaniceHahn |       277282 |
| Senator Harry Reid  | SenatorReid    |       269700 |
{: .sql-table}

Since more tweeting will conceivably lead to more retweets, let's find the average of retweets per tweet made. I'll throw in a `ROUND` function to make the results easier to read:

~~~sql
SELECT name, twitter_profiles.screen_name, 
    ROUND(AVG(tweets.retweet_count)) AS avg_retweets
  FROM tweets
  INNER JOIN twitter_profiles
    ON twitter_profiles.screen_name = tweets.screen_name
  GROUP BY twitter_profiles.screen_name
  ORDER BY avg_retweets DESC
  LIMIT 10;
~~~


Result:

|-------------------|----------------|--------------|
|        name       |  screen_name   | avg_retweets |
|-------------------|----------------|--------------|
| Mark Takano       | RepMarkTakano  |         3746 |
| Ann McLane Kuster | RepAnnieKuster |         3191 |
| Gary G. Miller    | RepGaryMiller  |          672 |
| Rep. Danny Davis  | RepDannyDavis  |          587 |
| Senator Ted Cruz  | SenTedCruz     |          455 |
| Elizabeth Warren  | SenWarren      |          405 |
| Senator Rand Paul | SenRandPaul    |          203 |
| Nancy Pelosi      | NancyPelosi    |          177 |
| John Barrow       | repjohnbarrow  |          147 |
| Janice Hahn       | Rep_JaniceHahn |          143 |
{: .sql-table}


### Filtering retweets

Hmmm...why is it that Rep. Mark Takano and Rep. Annie Kuster have an average of retweets an order of one magnitude higher than the rest of Congress?

Not all tweets are _original_ retweets. For example, Rep. Takano retweeted this [@BarackObama tweet](https://twitter.com/BarackObama/status/392342632526934016). In the `tweets` table, this counts as tweet activity from Rep. Takano, and so the 12,800+ retweets for @BarackObama's tweets ends up being counted as rewteets for Rep. Takano's "tweet". 

How do we know which tweets are actually __retweets__? We look at the `retweeted_status_id` field; if it has a value &ndash; i.e. the ID of the original tweet &ndash; then it is a __retweet__. So to get Rep. Takano's retweets, we filter for his tweets in which `retweeted_status_id IS NOT NULL` (or `retweeted_status_id = ""`, depending on your version of the data):

~~~sql
SELECT id, text, retweeted_status_screen_name, retweet_count FROM tweets
  WHERE screen_name = 'repmarktakano'
    AND retweeted_status_id IS NOT NULL
  ORDER BY retweet_count DESC
  LIMIT 10
~~~


Note: We could also look at the `retweeted_status_user_id` or `retweeted_status_screen_name` fields.

The result:

|--------------------|----------------------------------------------------------------------------------------------------------------------------------------------|------------------------------|---------------|
|         id         |                                                                     text                                                                     | retweeted_status_screen_name | retweet_count |
|--------------------|----------------------------------------------------------------------------------------------------------------------------------------------|------------------------------|---------------|
| 440323150195462145 | RT @TheEllenShow: If only Bradley's arm was longer. Best photo ever. #oscars http://t.co/C9U5NOtGap                                          | TheEllenShow                 |       3381305 |
| 482195295502336000 | RT @TimHowardGK: I  I believe   I believe that   I believe that we will win  I believe that we will win  I believe that we will win  #LetsD… | TimHowardGK                  |         39429 |
| 410781748717694976 | RT @TIME: Pope Francis is TIME’s Person of the Year for 2013 http://t.co/AXKIlnqqjr #TIMEPOY http://t.co/xO9K2lDxxf                          | TIME                         |         17229 |
| 392342759614730240 | RT @BarackObama: Congrats, New Jersey. #LoveIsLove http://t.co/cqIdeTbZk7                                                                    | BarackObama                  |         12821 |
| 505833279443173376 | RT @MichaelSamNFL: The most worthwhile things in life rarely come easy, this is a lesson I've always known. The journey continues.           | MichaelSamNFL                |          7400 |
| 378545565866668032 | RT @NancyPelosi: Hopefully, when Pres. #Putin says "we must not forget that God created us equal" he includes gays and lesbians in Russia.   | NancyPelosi                  |          2970 |
| 403565034942787584 | RT @SenatorReid: 168 filibusters of nominees in our history. HALF of them have occurred during Obama years! http://t.co/xbQfsftLGm           | SenatorReid                  |          2641 |
| 432256605930127360 | RT @cnnbrk: Attorney general to extend U.S. recognition of same-sex marriages even in 34 states that don't consider it legal. http://t.co/A… | cnnbrk                       |          2501 |
| 461211502079643648 | RT @jasoncollins34: Commissioner of the @NBA just showed us how he drops the hammer on ignorance. #lifetimeban for Donald Sterling. The ult… | jasoncollins34               |          2222 |
| 350279222218072066 | RT @jonesinforjason: A friend just asked me what DOMA stood for. I said, 'nothing'.                                                          | jonesinforjason              |          1722 |
{: .sql-table}


Ah, now we see the reason for `RepMarkTakano`'s high average of retweets. He's [hanging off of the coattails of Academy-nominated movie stars](https://twitter.com/repmarktakano/status/440323150195462145):

![ellen retweet](/files/tutorials/databases/ellen-retweet.jpg)



Let's tweak the query to show the most retweeted tweets that _originated_ from `RepMarkTakano`, rather than being _retweets from_ `RepMarkTakano`

~~~sql
SELECT id, text, retweeted_status_screen_name, retweet_count FROM tweets
  WHERE screen_name = 'repmarktakano'
    AND retweeted_status_id IS NULL
  ORDER BY retweet_count DESC
  LIMIT 5
~~~


Still a respectable number of retweets-per-tweet, but not in the 3+ million range:

|--------------------|--------------------------------------------------------------------------------------------------------------------------------------|------------------------------|---------------|
|         id         |                                                                 text                                                                 | retweeted_status_screen_name | retweet_count |
|--------------------|--------------------------------------------------------------------------------------------------------------------------------------|------------------------------|---------------|
| 364158957771702272 | Happy Birthday, Mr. President! http://t.co/5VjIeFELCP                                                                                |                              |          1817 |
| 382599378940067840 | Ted Cruz, Ima let you finish but... http://t.co/zDSNK8HrAX                                                                           |                              |          1258 |
| 355338868146450433 | I edited a draft letter by GOP members to Boehner that is looking for cosigners. Not signing it. #Immigration http://t.co/xhLYSYi3lx |                              |           991 |
| 483663281643855872 | RT if you believe the male justices would have ruled differently if #HobbyLobby case was about Viagra or Cialis.                     |                              |           612 |
| 483751915013279744 | RT if you believe the male justices would have ruled differently if #HobbyLobby case was about Viagra or Cialis. #SCOTUS             |                              |           409 |
{: .sql-table}



#### Highest average retweeted original tweets

Let's now look again at the entirety of Congress to find the highest average of retweets when filtering for _original_ retweets:

~~~sql
SELECT name, twitter_profiles.screen_name, 
    ROUND(AVG(tweets.retweet_count)) AS avg_retweets
  FROM tweets
  INNER JOIN twitter_profiles
    ON twitter_profiles.screen_name = tweets.screen_name
  WHERE retweeted_status_id IS NULL 
  GROUP BY twitter_profiles.screen_name
  ORDER BY avg_retweets DESC
  LIMIT 10;
~~~

The top original retweeted Twitterers:

|---------------------|-----------------|--------------|
|         name        |   screen_name   | avg_retweets |
|---------------------|-----------------|--------------|
| Senator Ted Cruz    | sentedcruz      |          442 |
| Senator Rand Paul   | senrandpaul     |          215 |
| Nancy Pelosi        | nancypelosi     |          150 |
| Elizabeth Warren    | senwarren       |          149 |
| John Lewis          | repjohnlewis    |          138 |
| Jim Bridenstine     | repjbridenstine |          122 |
| Bernie Sanders      | sensanders      |           84 |
| Senator Harry Reid  | senatorreid     |           79 |
| Ileana Ros-Lehtinen | roslehtinen     |           76 |
| Justin Amash        | repjustinamash  |           66 |
{:sql-info}





#### Retweets by party

In the previous examples, we've only been joining Twitter data: `tweets` and `twitter_profiles`. Let's get partisan again and list the political parties by average retweets and favorites by _original_ tweet. We can ignore the `twitter_profiles` table for now since `social_accounts` has the `twitter_screen_name` field for connecting to `tweets`:


~~~sql
SELECT members.party, AVG(tweets.retweet_count), AVG(tweets.favorite_count)
  FROM members
  JOIN social_accounts
    ON members.bioguide_id = social_accounts.bioguide_id
  JOIN tweets
    ON social_accounts.twitter_screen_name = tweets.screen_name
  WHERE retweeted_status_id IS NULL
  GROUP BY members.party;
~~~

Check out the Internet-savviness of our Independents:

|-------------|---------------------------|----------------------------|
|    party    | AVG(tweets.retweet_count) | AVG(tweets.favorite_count) |
|-------------|---------------------------|----------------------------|
| Democrat    |                    7.7235 |                     3.0442 |
| Independent |                   55.8788 |                    26.5008 |
| Republican  |                   12.2547 |                     4.2624 |
{: .sql-table}





- get number of tweets at night time
- get number of tweets at night time adjusted for utc
- get number of tweets replied to 
- get number of tweets that were replied to or were rewteets
- get users who were retweeted or replied to who are also congressmembers
- get users who were most retweeted or replied to who are not congressmembers
- Find the democrats Congressmembers most retweeted by Republicans
- Find the republicans Congressmembers most retweeted by Republicans
- Find the congressmembers who use the most variety of web/twitter clients
- find the congressmembers with at least 1000 tweets who have been least retweeted
- Find the number of tweets that mention ebola and graph it by week

Homework:

Find the number of times Republicans retweeted or replied to each other, versus the number of times they replied or retweeted Democrats.

