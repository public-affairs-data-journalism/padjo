---
layout: tutorial
title: SQL Joins on many-to-one relationship
description: Whe
date: 2014-10-17
published: false
---

In the [previous tutorial](/tutorials/database-joins/sql-many-to-one), we learned the basics of the `JOIN` syntax and how to join one record from a table to one record from another table, e.g. a Congressmember to his/her Twitter account.

Not everything has a one-to-one relationship. For example, a Twitter account, and by extension, a Congressmember, has _many_ tweets. We refer to this as a _many-to-one_ relationship.

The syntax of `JOIN` is no different from before, so this will be more of a refresher on aggregate queries.

*This tutorial assumes you've completed all of the [basic SQL tutorials](/tutorials/#databases)*

--------------

> Note: For this SQL lesson, I will be using MySQL and the Sequel Pro GUI. The queries and concepts should be the same as they are with SQLite.
> 
> - [MySQL dump of Congress and Twitter data](http://stash.padjo.org/dumps/sql/congress_twitter.sql.zip)
> - [SQLite dump of Congress and Twitter data](http://stash.padjo.org/dumps/sql/congress_twitter.sqlite.zip)

---------------


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
    twitter_profiles.screen_name = 'DarrellIssa'
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
    twitter_profiles.screen_name = 'DarrellIssa'
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
    twitter_profiles.screen_name = 'DarrellIssa'
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

How do we know which tweets are actually __retweets__? We look at the `retweeted_status_id` field; if it has a value &ndash; i.e. the ID of the original tweet &ndash; then it is a __retweet__. So to get Rep. Takano's retweets, we filter for his tweets in which `retweeted_status_id IS NOT NULL`:

~~~sql
SELECT id, text, re FROM tweets
  WHERE screen_name = 'RepMarkTakano'
    AND retweeted_status_id IS NOT NULL
  ORDER BY retweet_count
  LIMIT 10
~~~

TKTK----
Note: We could also look at the `retweeted_status_user_id` or `retweeted_status_screen_name` fields.




Let's redo the query for average `retweet_count` and filter for _original_ tweets by the users:


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





- get average number of retweets and times favorited
- get same number, but only original tweets
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

