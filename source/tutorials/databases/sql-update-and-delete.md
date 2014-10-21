---
layout: tutorial
title: Updating, deleting, and creating new data
description: Statements for modifying our databases
date: 2014-10-20
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

Or, to do both upper-casing updates in one query, use the `UPPER` function:

~~~sql
UPDATE members
  SET current_role = UPPER(current_role)
~~~



What results do these queries return? None. But for the first query (on `"rep"`) MySQL should tell you something like, `No errors; 438 rows affected`:

![no rows](/files/tutorials/databases/update-no-rows-returned.jpg)


#### Updating `NULL` states

If a column is filled with `NULL` states, the `WHERE` syntax is the same as it was in `SELECT`:

~~~sql
  UPDATE members
    SET middle_name = ''
    WHERE middle_name IS NULL
~~~

And to change empty/blank values into `NULL`:

~~~sql
  UPDATE members
    SET middle_name = NULL
    WHERE middle_name = ''
~~~

Note the syntax difference: you `SET` a field _equal_ to `NULL`, versus looking for `WHERE` a field `IS NULL`


#### Updating multiple fields

To update more than one column at a time, you provide a comma-separated list:

~~~sql
  UPDATE members
    SET 
      gender = UPPER(GENDER),
      current_role = UPPER(current_role)
~~~


#### Creating and populating a new column

I won't go into this in detail, but you can __add__ a new column to an existing table via your database GUI. Or, for both MySQL and SQLite, you can add a string column (that holds up to 255 characters) named `full_name` to `members` with this statement:

~~~sql
ALTER TABLE members 
  ADD COLUMN full_name VARCHAR(255)
~~~


This new column will be empty. Let's update it with a derived value: `full_name` should be equal to `first_name` + `middle_name` + `last_name` + `suffix`.

The command to __concatenate__ strings varies between MySQL and SQLite.

For MySQL ([check the official documentation here](http://dev.mysql.com/doc/refman/4.1/en/string-functions.html#function_concat)), we can use `CONCAT`, or even better, `CONCAT_WS` (_concatenate with separator_). The first value we pass to `CONCAT_WS` is what we want to _separate_ each subsequent value by...in this case, a __space character__:

~~~sql
UPDATE members
  SET full_name = CONCAT_WS(' ', first_name, middle_name, last_name, suffix)  
~~~

In SQLite, there is no `CONCAT` function. Instead, values are concatenated via the double-pipe operator: `||`

There is also no `CONCAT_WS` function, meaning we have to specify the space characters manually:

~~~sql
UPDATE members
  SET full_name = first_name || ' ' || middle_name || ' ' || 
    last_name || ' ' || ' ' || suffix
~~~


Unfortunately, this will lead to members who have no `middle_name` having a double-space between `first_name` and `last_name`. And those without a `suffix` will have a _trailing_ space character. However, we can use SQLite's `REPLACE` functionality to replace double-spaces with a single space, and then `TRIM` to remove any whitespace surrounding a value. 

The order of operations would be:

1. Concatenate the name fields together
2. `REPLACE` double-spaces with single-spaces
3. `TRIM` the result

Here's the convoluted statement:

~~~sql
UPDATE members
  SET full_name = TRIM(REPLACE(first_name || ' ' || middle_name || ' ' || 
    last_name || ' ' || ' ' || suffix, '  ', ' '))
~~~


#### Updating across joins



In MySQL, joining two tables and then updating values based on the joined conditions is possible, though not a frequent operation. This operation is __not possible__ [in SQLite](http://sqlite.org/lang_update.html).


__An example in MySQL:__ assuming you've created the `full_name` column on `members`, here's how to set that column based on a Twitter screen_name in `social_accounts`:


~~~sql
UPDATE members
  JOIN social_accounts
    ON social_accounts.bioguide_id = members.bioguide_id
  SET 
    members.full_name = social_accounts.twitter_screen_name
  WHERE social_accounts.twitter_screen_name IS NOT NULL;
~~~


### `DELETE`

Note: Use `DELETE` very sparingly, as there is no "undo" in database work. The better strategy is to _add a new column_ named something like, `should_be_deleted`, and then mark it `true` or `false`, and then use `WHERE` clauses to ignore or filter against `should_be_deleted`


But if you truly want to delete rows in a table, the syntax is similar to `SELECT` except you don't have to specify any fields...because you're deleting entire rows, not columns.

The following query would delete __all__ rows from the `members` table:

~~~sql
  DELETE FROM members
~~~

You can use `WHERE` to delete only certain rows:

~~~sql
  DELETE FROM members
    WHERE first_name = 'Dan'
~~~



### `INSERT INTO`

For our purposes, if you're using a GUI, you're better off figuring out how to add rows via button-clicking. It's not as nice as a spreadsheet, but for bulk data entry, you may have bigger needs than what can be done solely with just the GUI or even queries.

But for reference sake, here's the basic syntax to insert one row:

~~~sql
INSERT INTO some_table
  (column_a, column_b)
  VALUES('Hello', 'World');
~~~

For our `members` table:

~~~sql
INSERT INTO members
  (first_name, last_name, nickname, gender)
  VALUES('Milhouse', 'Van Houten', 'Thrillhouse', 'M')
~~~
