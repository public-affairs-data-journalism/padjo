---
layout: tutorial
title: Updating, deleting, and creating new data
description: Statements for modifying our databases
date: 2014-10-15
---


So far we've focused exclusively on the `SELECT` statement, since all we've cared about was searching through a database, not modifying it. But if we do want to modify our data, we have access to `UPDATE`, `DELETE`,  and `INSERT`.


<!-- SPLIT_SUMMARY -->

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


__Somewhat obvious note:__ if you modify the database in this lesson, you should delete the database and reimport it for the other lessons that use it. If you don't want to go through that hassle, you can __duplicate__ the tables via the GUI, e.g. right-click on a table name and select __Duplicate table__ (Sequel Pro) or __Copy table__ (SQLite Manager). Be sure to select the option that also copies the _data_ and not just the structure.

![img](files/tutorials/databases/right-click-copy-table-sqlite.png)



### `UPDATE`

The structure for an `UPDATE` statement is similar to `SELECT`, but simpler:

~~~sql
UPDATE some_table
  SET some_field = some_value, 
    some_other_field = some_other_value
  /* optional */
  WHERE some_condition_is_true
~~~


In the `members` table, the values for `current_role` are either `"rep"` (for "Representative") or `"sen"` (for "Senator"). To change those to `"REP"` and `"SEN"`, respectively, we can execute two `UPDATE` statements:

~~~sql
UPDATE members
  SET current_role = 'REP'
  WHERE current_role = 'rep'
~~~



~~~sql
UPDATE members
  SET current_role = 'SEN'
  WHERE current_role = 'sen';
~~~


What results do these queries return? None. But for the first query (on `"rep"`) MySQL should tell you something like, `No errors; 438 rows affected`:

![no rows](/files/tutorials/databases/update-no-rows-returned.jpg)





### `DELETE`


### `INSERT INTO`



#### Exercises

1. Alter the `members` database by creating a new column with `first_start_date` and fill it with the value of each member's earliest start date from `terms`
2. 
