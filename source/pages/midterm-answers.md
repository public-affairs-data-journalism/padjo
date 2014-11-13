---
title: Answers to Fall 2014 Midterm
date: 2014-11-06
description: SQL and more
layout: page
---

The midterm questions are repeated below, but it may be helpful to review its context within the lesson on [October 23, 2014](/2014-10-23)

## Question 1

> Query the database and create a list of every county (with state) that has __acquired at least one mine-resistant armored vehicle__. Then __map that list__ (Fusion Tables will probably be the easiest method). The map but not exactly the same, as the list behind this [NYT interactive map of armored vehicles](http://www.nytimes.com/interactive/2014/08/15/us/surplus-military-equipment-map.html?smid=pl-share).

The first step is to figure out: what exactly is a "mine-resistant armored vehicle", in the parlance of the 1033 database? Assuming that they are among the most expensive things that the Pentagon can distribute, and that the word "mine" appears in its name, we scout the database like so:

~~~sql
SELECT `Item Name`, `Acquisition Cost`  
FROM leso
WHERE `Item Name` LIKE '%mine%'
ORDER BY `Acquisition Cost` DESC
LIMIT 10
~~~


The result:

|------------------------|------------------|
|       Item Name        | Acquisition Cost |
|------------------------|------------------|
| MINE RESISTANT VEHICLE |       1309299.00 |
| MINE RESISTANT VEHICLE |       1084800.00 |
| MINE RESISTANT VEHICLE |        865000.00 |
| MINE RESISTANT VEHICLE |        865000.00 |
| MINE RESISTANT VEHICLE |        865000.00 |
| MINE RESISTANT VEHICLE |        733000.00 |
| MINE RESISTANT VEHICLE |        733000.00 |
| MINE RESISTANT VEHICLE |        733000.00 |
| MINE RESISTANT VEHICLE |        733000.00 |
| MINE RESISTANT VEHICLE |        733000.00 |
|------------------------|------------------|
{: .sql-table}

It looks like `MINE RESISTANT VEHICLE` is our term. One caveat about the query though: this is only showing the ten most _expensive_ MRVs. What if &ndash; *Heavens forbid!* &ndash; there are MRV records in which the `Item Name` spelling is not quite correct?

Unlikely chance, I know, but it's not too hard to adjust our query by adding a `GROUP` clause so that we cluster same-named items together and get the top 10 __distinct__ `Item Name` values. I add a `COUNT(*)` column just as a reference to see how many records fall under each distinct `Item Name`: 

~~~sql
  SELECT `Item Name`, `Acquisition Cost`, SUM(quantity)
    FROM leso
    WHERE `Item Name` LIKE '%mine%'
    GROUP BY `Item Name`
    ORDER BY `Acquisition Cost` DESC
    LIMIT 10    
~~~

|-------------------------------------|------------------|---------------|
|              Item Name              | Acquisition Cost | SUM(quantity) |
|-------------------------------------|------------------|---------------|
| MINE RESISTANT VEHI                 |        610764.00 |             4 |
| MINE RESISTANT VEHICLE              |        610764.00 |           343 |
| MINEFIELD MARKING SET               |          3665.40 |             1 |
| CONTROL,MINE DETECTOR               |          3020.52 |             1 |
| DETECTOR,MINE                       |          2189.89 |           115 |
| DETECTING SET,MINE                  |          1196.00 |           236 |
| DEMINERALIZER,WATER,ION EXCHANGE    |           879.64 |            41 |
| ANTI-PERSONNEL MINE FOOT PROTECTION |           663.57 |            13 |
| DEMINERALIZER,WATER                 |           566.50 |            71 |
| LAMP,ELECTROLUMINESCENT PANEL       |           447.87 |             9 |
|-------------------------------------|------------------|---------------|
{: .sql-table}


In `4` instances of MRV distribution, whoever did the data entry just gave up at `MINE RESISTANT VEHI` &ndash; or, more likely &ndash; one of the computer systems arbitrarily truncated the length of the name. It happens.

In order to map the counties with MRVs, we now add a `JOIN` clause to the `county_boundaries` table. To satisfy my curiosity, I keep the `SUM(quantity)` column and sort by it, because I want to see which counties if any have ordered more than one MRV. This necessitates adding to the `GROUP BY` clause too:

~~~sql
  SELECT  leso.state, leso.county, county_boundaries.geometry, SUM(quantity) AS num_of_mrvs
    FROM leso
    JOIN county_boundaries 
      ON leso.state = county_boundaries.`State Abbr.`
      AND leso.county = county_boundaries.`County Name` 
    WHERE `Item Name` LIKE 'MINE RESISTANT VEHI%'
    GROUP BY leso.state, leso.county, `Item Name`
    ORDER BY num_of_mrvs DESC
~~~

The resulting table will look something like this:

|-------|-------------|-------------------------------------------|-------------|
| state |    county   |                  geometry                 | num_of_mrvs |
|-------|-------------|-------------------------------------------|-------------|
| FL    | MIAMI-DADE  | &lt;Polygon&gt;&lt;outerBoundaryIs&gt;... |           4 |
| FL    | PINELLAS    | &lt;Polygon&gt;&lt;outerBoundaryIs&gt;... |           4 |
| AZ    | MARICOPA    | &lt;Polygon&gt;&lt;outerBoundaryIs&gt;... |           4 |
| CA    | LOS ANGELES | &lt;Polygon&gt;&lt;outerBoundaryIs&gt;... |           3 |
| IL    | COOK        | &lt;Polygon&gt;&lt;outerBoundaryIs&gt;... |           3 |
|-------|-------------|-------------------------------------------|-------------|
{:.sql-table} 

Then it's simply a [matter of exporting into Google Fusion Tables](https://www.google.com/fusiontables/data?docid=1i-5X4Lkf2m-9J42VnQ5LmEGuZ2rEGwJDIAoBqaTk#map:id=3):


![img](/files/pages/midterm/fusion-map-of-mrvs.png)




## Question 2

> Query the database and find the most expensive _single_ item that can be acquired through the 1033 program. Then generate a list of all counties that has so far acquired at least one of these things (you'll likely do two queries to answer this question).

This probably should've been __Question 1__, as it would get you in the groove of doing an initial _exploratory_ query (and an aggregation) as a means to get to the actual answer. Question 1 adds the bit about joining to another table.

The exploratory query simply asks the database: Sort the records by `Acquisition Cost` in descending order and display the first result. It's conceptually no different than opening the dataset in Excel and sorting by a column. We `LIMIT` to 1 because we just care about the most *expensive single* item:

~~~sql
SELECT * from leso 
  ORDER BY `Acquisition Cost` DESC
  LIMIT 1;
~~~

The result: a helicopter

|-------|---------|----------|------------------|-----------------------|----------|------|------------------|------------|
| State |  County | psc_code |       NSN        |       Item Name       | Quantity |  UI  | Acquisition Cost | Ship Date  |
|-------|---------|----------|------------------|-----------------------|----------|------|------------------|------------|
| FL    | BREVARD |     1520 | 1520-DS-HEL-ICOP | AIRCRAFT, ROTARY WING |        1 | Each |      18000000.00 | 2011-03-09 |
|-------|---------|----------|------------------|-----------------------|----------|------|------------------|------------|
{: .sql-table}


Interestingly, if you were to select all records with an `Item Name` of `AIRCRAFT, ROTARY WING` or an `NSN` of `1520-DS-HEL-ICOP`, you would get a few records in which the `Acquisition Cost` is `200000.00` and one that is `6500000.00`. Did the price of helicopters decline from $18 million to $200,000? Or is this another data error? We don't have enough information at hand to know. My question is worded vaguely enough that a `WHERE` clause for `AIRCRAFT, ROTARY WING` would be a satisfactory answer. But the "real" answer should probably involve just the `Acquisition Cost`:

~~~sql
SELECT state, county, SUM(quantity) as num_items 
  FROM leso 
  WHERE `Acquisition Cost` = 18000000
~~~

It turns out only one county has ordered such an expensive item:

|-------|---------|-----------|
| state |  county | num_items |
|-------|---------|-----------|
| FL    | BREVARD |         8 |
|-------|---------|-----------|
{: .sql-table}


Note: As it turns out, it's not as if Brevard County is getting a fleet of nice helicopters. According to a [Florida Today investigation](http://www.floridatoday.com/longform/news/local/2014/08/23/military-devices-used-in-warzones-now-in-brevard/14499225/), the helicopters come in all shapes and sizes and condition:

> The Brevard County Sheriff's Aviation Unit, a five-chopper fleet that rescues stranded individuals and searches for suspects, is made up entirely of military surplus. One of the helicopters was shot down twice in Vietnam, Chief Pilot John Coppola said.

> The most recent addition is a UH-1H Huey chopper that arrived in May 2013 and will be used to help in firefighting and rescue operations. Coppola said it cost $2,000, but it needed some work. Replacing the machine's rotor blades and rotor shaft, as well as other maintenance, cost $12,000, Coppola said. To buy retail, he estimated it would have cost closer to $400,000.




## Question 3

> Query the database to get the __top 10 counties__ ordered by __the total number of guns acquired__ through the 1033 program. Your answer should look [very similar to what NPR found under](http://www.npr.org/2014/09/02/342494225/mraps-and-bayonets-what-we-know-about-the-pentagons-1033-program) the __Total Guns Acquired__ graph (e.g. 3,452 guns for Los Angeles)

This question again requires at least two queries, the first of which has to find out, "What exactly counts as a 'gun'?"

I included the `psc` table as a reference, but it was not necessary to actually _use_ it in a query. I can just glance at it as if it were just a spreadsheet:

![img](files/pages/midterm/psc-codes-for-guns.png)

I didn't specify _small arms_-type of guns, i.e. rifles and handguns, but as it turns out, the Pentagon doesn't distribute artillery, such as 120mm-mortars, so the `psc_code` of `1005` &ndash; `GUNS, THROUGH 30MM` &ndash; should have us covered. I add a couple of `SUM` columns just for easy sorting:

~~~sql
SELECT `Item Name`, `Acquisition Cost`,  
  SUM(quantity) AS totes_items,
  SUM(quantity * `Acquisition Cost`) AS totes_cost 
  FROM leso
  WHERE psc_code = '1005'
  GROUP BY `Item Name`
  ORDER BY totes_cost DESC
~~~


Result: 

|--------------------------------------|------------------|-------------|-------------|
|              Item Name               | Acquisition Cost | totes_items |  totes_cost |
|--------------------------------------|------------------|-------------|-------------|
| RIFLE,5.56 MILLIMETER                |           499.00 |       61530 | 23666673.00 |
| RIFLE,7.62 MILLIMETER                |           138.00 |       17724 |  2558772.00 |
| MAGAZINE,CARTRIDGE                   |             9.51 |      146856 |  1481972.28 |
| PISTOL,CALIBER .45,AUTOMATIC         |            58.71 |        8640 |   506197.61 |
| SUPPRESSOR,SMALL ARMS WEAPON         |           650.00 |         556 |   465808.53 |
| CLEANING KIT,GUN                     |            53.13 |        5979 |   441981.49 |
|                                      |           103.50 |        3778 |   438911.36 |
| ADAPTER RAIL,WEAPON MOUNTED          |            12.03 |        2227 |   437347.91 |
| CONVERSION KIT,5.56 MILLIMETER RIFLE |            60.00 |        1271 |   365674.00 |
| SIGHT,REAR                           |            46.52 |        5424 |   320683.08 |
|--------------------------------------|------------------|-------------|-------------|
{: .sql-table}

So again, we run into some messy naming conventions. Doing a `WHERE...LIKE` for `%RIFLE%` will catch things like `CONVERSION KIT,5.56 MILLIMETER RIFLE` or `SCOPE,SNIPER RIFLE` or `RIFLE,DUMMY`. For complete thoroughness, you'd want to query the database multiple times and keep track of all the valid terms for firearms. Seem like a pain? Welcome to the world of data-cleaning!

If you wanted to fulfill the requirements of the question and get something close to [NPR's results](http://www.npr.org/2014/09/02/342494225/mraps-and-bayonets-what-we-know-about-the-pentagons-1033-program), this would've been _mostly_ accurate:

~~~sql
SELECT county, state,
  SUM(quantity) AS totes_guns
  FROM leso
  WHERE `Item Name` LIKE 'RIFLE,%' 
    OR `Item Name` LIKE 'PISTOL,%'
    OR `Item Name` LIKE 'SHOTGUN,%'
  GROUP BY county, state
  ORDER BY totes_guns DESC
  LIMIT 10
~~~

Result:

|----------------|-------|------------|
|     county     | state | totes_guns |
|----------------|-------|------------|
| LOS ANGELES    | CA    |       3452 |
| LEON           | FL    |       1934 |
| FRANKLIN       | OH    |       1800 |
| FRANKLIN       | KY    |       1401 |
| COOK           | IL    |       1256 |
| RAMSEY         | MN    |       1032 |
| SACRAMENTO     | CA    |        802 |
| PRINCE GEORGES | MD    |        777 |
| HOWARD         | MD    |        739 |
| SANGAMON       | IL    |        670 |
|----------------|-------|------------|
{: .sql-table}


## Question 4 
> Query the database to get the __top 10 counties__ ordered by __number of guns acquired per 1,000 people__ using the Census's __2013 population estimate__. Again, your answers should look similar (but not exact) [to what NPR found](http://www.npr.org/2014/09/02/342494225/mraps-and-bayonets-what-we-know-about-the-pentagons-1033-program), e.g. 28 guns/1,000 people in Franklin, KY.

We build upon the last query, but we join upon the `census_quickfacts` table, which has a column named `PST045213` that indicates ["Population, 2013 estimate"](http://quickfacts.census.gov/qfd/download/DataDict.txt). But there's a problem: `census_quickfacts` only has a FIPS code, and `leso` has state and county names.

So we need to join a third table &ndash; referred to as a "lookup table", in the parlance of our times &ndash; `county_ansi`, which matches `fips` to county and state names:


|------------|-------|-----------------------|
|   county   | state | totes_guns_per_capita |
|------------|-------|-----------------------|
| FRANKLIN   | KY    |               28.2187 |
| HUGHES     | SD    |               17.7633 |
| PETROLEUM  | MT    |               15.8103 |
| NIOBRARA   | WY    |               14.1677 |
| HINSDALE   | CO    |               11.0701 |
| CHAUTAUQUA | KS    |                9.0090 |
| CHEYENNE   | KS    |                8.1663 |
| WHEELER    | OR    |                7.9652 |
| WAHKIAKUM  | WA    |                7.4221 |
| JACKSON    | CO    |                7.3260 |
|------------|-------|-----------------------|
{: .sql-table}


## Question 5
> Create a time-series/[histogram](http://en.wikipedia.org/wiki/Histogram) showing _something you find interesting_ in the 1033 Program data. Examples: Number of gas masks versus night-goggles distributed by year. Monetary value of pants and trousers versus rifles, by year.

(This was an open-ended question, I'll post some of the answers that I liked)



## Question 6
> Find __all of the counties__ that have not acquired a single thing in the `leso` table, __and then map those counties__. If you order your list by population, the top two counties should be Kings County and Bronx County in New York (for reasons that should make sense if you have lived in New York).

This is probably the hardest technical question, as it [requires an understanding of left joins](/tutorials/database-joins/sql-left-joins) and their purpose when it comes to finding out facts.

But the query itself isn't any more complicated than the one in question 5:

~~~sql
SELECT county_ansi.county, county_ansi.state, PST045213 
  FROM county_ansi
  LEFT JOIN 
    leso 
       ON county_ansi.county = leso.county
         AND county_ansi.state = leso.state
   JOIN
     census_quickfacts
       ON
         county_ansi.fips =   census_quickfacts.fips
   WHERE leso.state IS NULL   
   group by county_ansi.state, county_ansi.county
      ORDER BY census_quickfacts.PST045213 DESC, county_ansi.state, county_ansi.county
~~~

The results table should include __614 rows__:

|-------------|-------|-----------|
|    county   | state | PST045213 |
|-------------|-------|-----------|
| KINGS       | NY    |   2592149 |
| BRONX       | NY    |   1418733 |
| RICHMOND    | NY    |    472621 |
| SOMERSET    | NJ    |    330585 |
| NORTHAMPTON | PA    |    299791 |
| ERIE        | PA    |    280294 |
| JACKSON     | OR    |    208545 |
| WASHINGTON  | PA    |    208206 |
| HAWAII      | HI    |    190821 |
| BUTLER      | PA    |    185476 |
| MAUI        | HI    |    160202 |
| CENTRE      | PA    |    155403 |
| SCHENECTADY | NY    |    155333 |
{: .sql-table}


## Question 7
> Find the county that has acquired the most from the 1033 Program in terms of __total acquisition cost__ and generate a list of the items that county has acquired.

This shouldn't be the 7th question in terms of difficulty. Mostly it tests if you've noticed that there's a `Quantity` column to be mindful of:

~~~sql
SELECT state, county, 
    SUM(`Acquisition Cost` * Quantity) as totes_cost
FROM leso 
GROUP BY state, county
ORDER BY totes_cost DESC
LIMIT 1
~~~


|-------|---------|--------------|
| state |  county |  totes_cost  |
|-------|---------|--------------|
| FL    | BREVARD | 210916922.73 |
|-------|---------|--------------|
{: .sql-table}

To get the list of items (with distinct names):

~~~sql
SELECT `Item Name`,
  SUM(Quantity), SUM(`Acquisition Cost` * Quantity) as totes_cost
FROM leso 
WHERE state = 'FL' AND county = 'BREVARD'
GROUP BY `Item Name`  
ORDER BY totes_cost DESC
~~~

Result:

|--------------------------------------------------------|---------------|--------------|
|                       Item Name                        | SUM(Quantity) |  totes_cost  |
|--------------------------------------------------------|---------------|--------------|
| AIRCRAFT, ROTARY WING                                  |             8 | 144000000.00 |
| HELICOPTER,UTILITY                                     |            58 |  53491640.00 |
| AIRCRAFT, FIXED WING                                   |             8 |   7837067.00 |
| GAS TURBINES AND JET ENGINES, AIRCRAFT                 |            12 |   1800000.00 |
| CARRIER,PERSONNEL,FULL TRACKED                         |             3 |    734532.00 |
| MINE RESISTANT VEHICLE                                 |             1 |    658000.00 |
| FORWARD LOOKING INFRARED IMAGING SYSTEM                |             1 |    544482.44 |
| HELICOPTER,OBSERVATION                                 |             4 |    467687.00 |
| RIFLE,5.56 MILLIMETER                                  |           370 |    183114.00 |
| CASE AND VANE ASSEMBLY,FAN,AIRCRAFT GAS TURBINE ENGINE |             6 |    179772.00 |
| TENT                                                   |             4 |    113084.26 |
{: .sql-table}
 
## Question 8
> Write a __300-word story memo__ on an __interesting query (or queries)__ of your own. The memo should include examples/results of a data query and why you think said results are __newsworthy__ or worth further investigation. Your memo, ideally, would involve some additional research to see if anyone else has found anything related to your inquiry. A chart/graphic is optional.
> Example story ideas:
> 
>  - Finding the smallest counties (by population) that have acquired the most heavy equipment despite no obvious need for such equipment. Is that equipment in use, and how? What is the maintenance and training cost of the equipment?
>    - Which counties have acquired a high amount of surplus equipment in earlier years (2006 to 2007) but very little, or none at all, in recent years?
>    - What kinds of equipment have only recently been distributed through the 1033 Program, but are currently in seemingly high demand?
>    - What are the surplus items that have no acquisition cost? And is the lack of cost consistent across _all_ records of those items (and similar items)? Is the lack of cost because of sloppy data entry? Or because of the type of item?


(This was an open-ended question, I'll post some of the answers that I liked)
