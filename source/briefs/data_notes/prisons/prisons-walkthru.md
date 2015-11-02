Find oldest people in prison:

~~~sql
SELECT *
FROM "texas-inmates"
ORDER BY DOB ASC
limit 5;
~~~

Find youngest:

~~~sql
SELECT *
FROM "texas-inmates"
ORDER BY DOB DESC
limit 5;
~~~

Filter:

~~~sql
SELECT 
  name, dob, gender, race, offense
FROM "texas-inmates"
ORDER BY DOB DESC
limit 5;
~~~


Let's do oldest again:


~~~sql
SELECT 
  name, dob, gender, race, offense
FROM "texas-inmates"
ORDER BY DOB ASC
limit 5;
~~~


Interesting disparity in crimes...

--------

Let's do the math:

~~~sql
SELECT 
  (date("2015-10-30") - DOB) AS age,
  dob, gender, race, offense

FROM "texas-inmates"
ORDER BY DOB ASC
limit 5;
~~~


Let's find the oldest by age when crime was convicted:

~~~sql
SELECT 
  (date("2015-10-30") - DOB) AS age_today,
  ("Offense Date" - DOB) AS age_at_offense,

  dob, "Offense Date", gender, race, offense

FROM "texas-inmates"
ORDER BY DOB ASC
limit 5;
~~~

------------

Let's find people who have been in jail for the least:


~~~sql
SELECT 
  "Offense Date", dob, gender, race, offense
FROM "texas-inmates"
ORDER BY "Offense Date" DESC
limit 5;
~~~


The longest:

~~~sql
SELECT 
  "Offense Date", dob, gender, race, offense
FROM "texas-inmates"
ORDER BY "Offense Date" ASC
limit 5;
~~~


Remove nulls:

people who were young but now are old, i.e. longest in the justice system:

~~~sql
SELECT 
  "Offense Date", dob, gender, race, offense
FROM "texas-inmates"
WHERE "Offense Date" > "1900-01-01"
ORDER BY "Offense Date" ASC
limit 5;
~~~








Number of inmates per year

~~~sql
SELECT strftime('%Y', "Sentence Date")  AS yr, 
   count(*) as inmate_count
FROM "texas-inmates"
GROUP BY yr
~~~


~~~sql
SELECT strftime('%Y', "Maximum Sentence Date")  AS yr, 
   count(*) as inmate_count
FROM "texas-inmates"
GROUP BY yr
ORDER BY yr DESC
~~~


How to find lifers:


~~~sql
SELECT * 
   FROM "texas-inmates"
WHERE strftime('%Y', "Maximum Sentence Date") = "9999"
~~~

List by crime

~~~sql
SELECT Offense, COUNT(*) 
   FROM "texas-inmates"
WHERE strftime('%Y', "Maximum Sentence Date") = "9999"
GROUP BY Offense
ORDER BY ct DES
~~~


Find variations of murder

~~~sql
SELECT UPPER(Offense) AS offense_term, COUNT(*) AS ct
   FROM "texas-inmates"
WHERE offense_term LIKE '%murder%'
GROUP BY offense_term
ORDER BY ct DESC
~~~


Let's just do Murder

~~~sql
SELECT *
FROM "texas-inmates"
WHERE offense = "MURDER"
~~~

Note the `"Offense Code"`: `09990019`

Lots of messiness

~~~sql
SELECT  *
FROM "texas-inmates"
WHERE "offense code" = '09990019' 
~~~


Let's just do murder, and look at sentencing:

~~~sql
SELECT COUNT(*)
FROM "texas-inmates"
WHERE offense = "MURDER" AND "Sentence Years" < 120;
~~~

That doesn't seem right. Let's make our own thing:

~~~sql
SELECT COUNT(*)
FROM "texas-inmates"
WHERE offense = "MURDER" AND 
  ("Maximum Sentence Date" - "Sentence Date") < 120;
~~~

Let's do an average by sex:


~~~sql
SELECT gender, COUNT(*)
FROM "texas-inmates"
WHERE offense = "MURDER" AND 
  ("Maximum Sentence Date" - "Sentence Date") < 120
GROUP BY gender;
~~~


Let's do race:

~~~sql
SELECT race, COUNT(*)
FROM "texas-inmates"
WHERE offense = "MURDER" AND 
  ("Maximum Sentence Date" - "Sentence Date") < 120
GROUP BY race;
~~~

Let's do averages:

~~~sql
SELECT race, COUNT(*), 
  AVG("Maximum Sentence Date" - "Sentence Date") as avg_sentence
FROM "texas-inmates"
WHERE offense = "MURDER" 
  AND ("Maximum Sentence Date" - "Sentence Date") < 120
GROUP BY race;
~~~



----------



Let's group it:


~~~sql
SELECT 
  ("Maximum Sentence Date" - "Sentence Date") AS xsentence_date,
  COUNT(*) as convict_count 
FROM "texas-inmates"
WHERE offense = "MURDER" AND xsentence_date < 120
GROUP BY xsentence_date
ORDER by xsentence_date;
~~~

Let's bucket it


~~~sql
SELECT 
  ("Maximum Sentence Date" - "Sentence Date") AS xsentence_date,
  ("Maximum Sentence Date" - "Sentence Date") / 10.0 AS x1,
ROUND(("Maximum Sentence Date" - "Sentence Date") / 10.0) * 10 AS xsentence_decade,
  COUNT(*) as convict_count 
FROM "texas-inmates"
WHERE offense = "MURDER" AND xsentence_date < 120
GROUP BY xsentence_date
ORDER by xsentence_date;
~~~


Better buckets:

~~~sql
SELECT 
ROUND(("Maximum Sentence Date" - "Sentence Date") / 10.0) * 10 
    AS xsentence_decade,
  COUNT(*) as convict_count 
FROM "texas-inmates"
WHERE offense = "MURDER" AND xsentence_decade < 120
GROUP BY xsentence_decade
ORDER by xsentence_decade;
~~~



Who are the people who get such a low sentence?


~~~sql
SELECT *, ("Maximum Sentence Date" - "Sentence Date") AS sdate
FROM "texas-inmates"
WHERE offense = "MURDER" 
  AND  sdate < 5
ORDER BY sdate ASC;
~~~

http://www.dallasnews.com/news/crime/headlines/20110922-fistfight-escalates-into-fatal-beating-outside-dallas-convenience-store.ece

"Sentence Began"
https://www.texastribune.org/library/data/texas-prisons/inmates/juan-arcos/719656/
