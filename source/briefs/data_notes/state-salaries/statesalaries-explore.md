
## What years?

~~~sql
SELECT year
FROM ca
ORDER BY year ASC
LIMIT 1;
~~~


~~~sql
SELECT year
FROM ca
ORDER BY year DESC
LIMIT 1;
~~~

## How many by year?



---------
~~~sql
SELECT year
FROM ca
GROUP BY year;
~~~



~~~sql
SELECT year
FROM ca
GROUP BY year;
~~~







## Overall aggregates


~~~sql
SELECT Position
From ca
GROUP BY Position;
~~~


~~~sql
SELECT Position,  
  MIN("Total Wages"),
  MAX("Total Wages"), 
  AVG("Total Wages")
FROM ca
GROUP BY Position;
~~~

~~~sql
SELECT "Entity Name", Position, 
  COUNT(*), 
  MIN("Total Wages"),
  MAX("Total Wages"), 
  AVG("Total Wages") as avgwages
FROM ca
GROUP BY "Entity Name", Position
ORDER BY avgwages DESC;
~~~

(note how to include groupings, notice how non specific the names are)

### Specific groups


~~~sql
SELECT "Entity Name", Position, 
  COUNT(*), 
  MIN("Total Wages"),
  MAX("Total Wages"), 
  AVG("Total Wages") as avgwages
FROM ca
GROUP BY "Entity Name", Position
ORDER BY avgwages DESC;
~~~


----


### Looking for a specific job




~~~sql
SELECT Position, 
  AVG("Total Wages") as avgwages
FROM ca
WHERE Position LIKE 'Attorney%'
GROUP BY Position

ORDER BY avgwages DESC;
~~~




-----------



## Rates of change

~~~sql
SELECT 

~~~

