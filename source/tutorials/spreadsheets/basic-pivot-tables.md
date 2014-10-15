---
title: Basic Aggregation with Pivot Tables
date: 2014-09-30
layout: tutorial
description: Pivot tables are an effective tool for quickly summarizing the facts from a mass of records
---

Welcome to this quick introduction to using pivot tables for data analysis, in which we'll learn how to use Google Spreadsheets to quickly summarize a large, granular dataset.

Download the dataset for this lesson: [SFPD Incident Reports Categorized as DUIs, Drunkenness, or Kidnappings, from 2003 to 2013](https://docs.google.com/a/stanford.edu/spreadsheets/d/1H2vQAZTG8eihyw_yzsI_sJfQBgxRn1fE1dOTV5E_W9M/edit?usp=drive_web).

The above dataset was extracted from [data.sfgov.org](https://data.sfgov.org/Public-Safety/SFPD-Reported-Incidents-2003-to-Present/dyj4-n68b).

This dataset contains more than 15,000 records: it consists of all the San Francisco Police Department crime reports that have a `category` field of:

- `DRIVING UNDER THE INFLUENCE`
- `DRUNKENNESS`
- and for good measure, `KIDNAPPING`

Here's a screenshot of what it looks like:

![img](/files/tutorials/pivot-tables/sfpd-duis-drunkenness-kidnappings-schemas.png)


15,000 records is good and all, but with the raw data, we aren't able to know some basic characteristics of the data...for example, how many of these 15,000 records involved, say, just `KIDNAPPING`? And have the number of kidnappings gone down over the years? To know that, we need a way to count these records by `category` and by year.

__This is where Pivot Tables comes in__. It provides an easy point-and-click interface to quickly summarize and explore your very granular data.

-----------------------

### Summarize by category

So first question: How many crime reports are in each category? This is a __summarization__ of the data, specifically, a __counting__ of records based on their `category` value.

Here are the steps to follow:

1. Click on __Data -> Pivot table report...__. This creates a new sheet, and you switch back and forth between it and your original data sheet.
  
     <video id="video1" class="video-js vjs-default-skin" controls preload="auto" width="100%"> <source src="/files/videos/pivot-table-open-001.mp4" type='video/mp4' /> <p class="vjs-no-js">To view this video please enable JavaScript, and consider upgrading to a web browser that <a href="http://videojs.com/html5-video-support/" target="_blank">supports HTML5 video</a></p></video>







2. In the __Report Editor__, click __Add field__ in the __Rows__ section. Choose `category`; this will _group your records_ by the `category` field. 

    The effect of this is that the pivot table will have __one row__ for _each_ value &ndash; e.g. "`KIDNAPPING`" &ndash; that exists in `category`. 
  
    As we expect, there are only three categories, hence, 3 rows.

    <video id="video2" class="video-js vjs-default-skin" controls preload="auto" width="100%"> <source src="/files/videos/pivot-table-rows-002.mp4" type='video/mp4' /> <p class="vjs-no-js">To view this video please enable JavaScript, and consider upgrading to a web browser that <a href="http://videojs.com/html5-video-support/" target="_blank">supports HTML5 video</a></p></video>

3. Now we want to `COUNT` number of crime reports, i.e. the number of rows in our dataset, per `category`. In the Report Editor, click __Add field__ in the __Values__ section. For our current purpose, it doesn't matter which field you choose (I'll pick `incidntnum` to keep it simple). By default, Google Spreadsheets will assume you're trying to SUM the values. But we want to _count_ the values So choose `COUNT` or `COUNTA`.

     <video id="video3" class="video-js vjs-default-skin" controls preload="auto" width="100%"> <source src="/files/videos/pivot-table-values-003.mp4" type='video/mp4' /></video>

4. When the data is in this straightforward format, we can easily visualizing it. We don't want to graph the totals, so uncheck the __Show Totals__ box. Then in the menubar, select __Insert->Chart__ and browse the visualization types. You can hit __Cancel__ rather than actually inserting a chart for now.

    <video id="video4" class="video-js vjs-default-skin" controls preload="auto" width="100%"> <source src="/files/videos/pivot-table-basic-chart-004.mp4" type='video/mp4' /></video>



------------------------

#### Breakdowns

Pivot tables makes it easy to group data, and then _sub_-group it as needed.

For example, if we go back to the original table, we see that there are subcategories, i.e. the `descript` field...

In our existing pivot table, we can get a count of each `descript` within each `category` by adding another field to the Rows: `descript`

We can keep adding new fields to subgroup by, such as `resolution`, which gives us a breakdown of how each report was handled (e.g. an arrest was made, or it was unfounded).

Here's a video demonstration:

<video id="pivot-table-more-rows-005" class="video-js vjs-default-skin" controls preload="auto" width="100%"> <source src="/files/videos/pivot-table-more-rows-005.mp4" type='video/mp4' /></video>

-------------------------------------------

#### Cross tabulations

As you can see, as we add more fields to group as __Rows__, the table becomes increasingly cluttered.

![img](/files/tutorials/pivot-tables/multiple-rows-pivoting.png)

There's nothing wrong with scouting out the data in this cluttered format, even if it won't be useful for chart-making. Another way to arrange the Pivot Table is to have grouped values for the _headers_.

We can do this in the __Columns__ section of the __Report Editor__.

1. Clear up the Report Editor by removing the existing fields in __Rows__ and __Values__ (i.e. start over)
2. Then add `resolution` as a field to the __Rows__ section.
3. Add a field to __Values__; again, it can be any of the columns, but switch the summarizing function to `COUNTA`
4. In the __Columns__ section, add the `descript` field

The step-by-step video:

<video id="pivot-table-cross-tabs-006.mp4" class="video-js vjs-default-skin" controls preload="auto" width="100%"> <source src="/files/videos/pivot-table-cross-tabs-006.mp4" type='video/mp4' /></video>



Now we have a straightforward table that lets us, at a glance, see how the various subcategories (i.e. `descript`) of crime incidents are resolved.

![img](/files/tutorials/pivot-tables/resolution-descript-cross-tab.png)


### All together now

What we're really interested in are the chronological trends in the data: for example, are DUIs/kidnappings/etc going down or up over the _years_?

In the original data sheet, we have a `date` field. In order to pivot _by year_, we __create a new column__ (let's call it `year` to keep it simple) and then derive the year from the `date` field with a formula:

    =YEAR(D2)


Here's a quick video snippet:


<video id="pivot-table-creating-year-duis-007" class="video-js vjs-default-skin" controls preload="auto" width="100%"> <source src="/files/videos/pivot-table-creating-year-duis-007.mp4" type='video/mp4' /></video>





##### Pivot by year

Now make a new Pivot Table and:

1. Group by `year`  for the __Rows__
2. Group by `category` for the __Columns__
3. Choose any column for `Values` and do a `COUNTA`
4. Make a chart

Here's a video of the entire process:

<video id="pivot-table-year-category-008" class="video-js vjs-default-skin" controls preload="auto" width="100%"> <source src="/files/videos/pivot-table-year-category-008.mp4" type='video/mp4' /></video>



And here's a chart that can be produced from that pivot table:

![img](/files/tutorials/pivot-tables/dui-drunkenness-kidnapping-year-trends.png)


------------

### Conclusion

Generally, we love it when datasets contain very detailed, granular records; e.g. _every_ crime report for every year, rather than a _total number of reports_ by year. 

However, when we need to know totals by year (or by month, or by hour, etc.), Pivot Tables are among the fastest ways to produce those summaries and get a high-level overview of what a large dataset actually contains.
