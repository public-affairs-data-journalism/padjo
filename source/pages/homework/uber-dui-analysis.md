---
title: What was Uber's effect on DUIs in San Francisco?
layout: page
---

## Background

This is one possible solution to the homework assigned for [Sept. 25, 2014's lecture](/2014-09-25): "Investigate Uber's purported impact on SF's DUI reports." The homework is an exercise in basic usage of Pivot Tables, and in strategies of examining strange outliers in data, as demonstrated by the [Baltimore Sun's rape statistics coverage in 2010](http://www.baltimoresun.com/news/maryland/crime/blog/bal-city-rape-statistics-archive,0,7495701.special).

Students were given a dataset that included all SFPD incident reports, from 2003 to 2013, that were categorized as either `DRIVING UNDER THE INFLUENCE`, `DRUNKENNESS`, or `KIDNAPPING`.

The purpose of this exercise was to look at the SFPD data to see if it was reliable enough to be a second source of reference for Uber's analysis.


__Note:__ The entire SFPD dataset is more than 1.5 million rows. However, since the class is starting to explore pivot tables using an online spreadsheet, I wanted to keep the number of rows small, hence the filtering of the data to 3 categories. On second thought, though, the kind of filtering I did wasn't ideal and limits our conclusions. 

So we'll save the full analysis of Uber's claims for homework after we learn basic SQL.



### Uber's claim


On May 5, 2014, Uber's [data research found that Uber's entrance in Seattle and San Francisco *caused* a drop in drunk-driving incidents](http://blog.uber.com/duiratesdecline), based on [Seattle's 911 Incident Responses database](https://data.seattle.gov/Public-Safety/Seattle-Police-Department-911-Incident-Response/3k2p-39jp) and San Francisco's [reported incidents](https://data.sfgov.org/Public-Safety/SFPD-Reported-Incidents-2003-to-Present/dyj4-n68b).

Note: [Seattle has its own reported incidents database](https://data.seattle.gov/Public-Safety/Seattle-Police-Department-Police-Report-Incident/7ais-f98f).

> We estimate that the entrance of Uber in Seattle caused the number of arrests for DUI to decrease by more than 10%. These results are robust and statistically significant. The diagram below illustrates the “Uber effect” relative to the baseline of DUIs. We also included the measured impact of legalizing marijuana (see the Details section below for more on this).

> ...In order to begin studying this important but difficult question, we have assembled drunk driving data from the arrest data made available by the police departments of both San Francisco and Seattle.


### The San Francisco data

Uber's used San Francisco's data to provide the following comparison:

> By this approach, Uber is responsible for approximately -.7 DUIs per day, or more than a 10% reduction overall. However, this approach is inherently weakened by the fact that many things could have caused DUI to go down around the time when Uber entered. In order to test the robustness of this estimate, we use San Francisco as a control city in a “differences-in-differences” framework. The result is consistent:

On July 10, 2014, [the Washington Post's Wonkblog revisited the issue](http://www.washingtonpost.com/blogs/wonkblog/wp/2014/07/10/are-uber-and-lyft-responsible-for-reducing-duis/) by looking specifically at the DUI arrests by month in San Francisco. Using the raw SF incidents data, Wonkblog created this chart of DUI incidents, juxtaposed by the entry of ride-sharing services:

TKIMG

Wonkblog noted these caveats:

> Again, caveats are in order. We've simply plotted arrests on a timeline here; we haven't adjusted for changes in the city's population, or bar scene, or the economy. Any number of other things may have changed in the city over the last few years affecting DUI arrests. It's possible police have changed how they conduct DUI stops and arrests, or that public pressure on them to crack down on DUIs has ebbed with time. Other changes in public transit service may have impacted alternative routes that bar-hoppers take home.

> It's also striking that San Francisco and Philadelphia show a steep and parallel rise in DUIs long before these services ever came to town; on both charts, it looks as if DUI numbers may be returning to an older normal as much as they've been falling. Perhaps these services have arrived on the market just in time to ride the benefits of an improving economy? (More theories on this welcome below as well).


Uber [launched on Aug. 12, 2011 in Seattle](http://blog.uber.com/UberSEAisTHREE).

Seattle data:

> select year(formatted_date) as yr, month(formatted_date) as mth, `Event Clearance Description` as description, count(1) as total from `911_incidents`
where `Event Clearance Description` = "DRIVING WHILE UNDER INFLUENCE (DUI)"
group by yr, mth
order by yr, mth


### Why the 2009 spike?




### Did Uber stop kidnappings?



### Insufficient data







