---
title: Fusion Tables Intensity Maps with Custom Shapes
date: 2014-10-03
layout: tutorial
description: Use geographic shape data to fill in political and physical boundaries
---


In the [previous Fusion Tables tutorial](/tutorials/mapping/basic-fusion-tables), we saw how to add data points to a map, using latitude and longitude coordinates.

In this tutorial, we'll be adding __polygons__ to a map. We'll also use a few other of Fusion Tables's mapping options, which let us use "buckets" of numerical data to determine the color of a shape (you can use buckets for points too, to determine which icon is used).

We'll also be practicing a bit of data-organization using Spreadsheets. Unlike [the previous tutorial](/tutorials/mapping/basic-fusion-tables), we'll be doing this _before_ we go into Fusion Tables.

At the end of this tutorial, we'll [create a map of the United States showing the results](https://www.google.com/fusiontables/DataSource?docid=1MdfSp2JWg2mQ6PfsBN991P5xTzExDfBC0P9xLemu#map:id=5) of the 2012 presidential election:

<iframe width="750" height="400" scrolling="no" frameborder="no" src="https://www.google.com/fusiontables/embedviz?q=select+col2+from+1MdfSp2JWg2mQ6PfsBN991P5xTzExDfBC0P9xLemu&amp;viz=MAP&amp;h=false&amp;lat=38.65334037888649&amp;lng=-96.92932299999995&amp;t=1&amp;z=4&amp;l=col2&amp;y=4&amp;tmplt=5&amp;hml=KML"></iframe>


### About KML

https://support.google.com/fusiontables/answer/171181?hl=en#kml


KML stands for __Keyhole Markup Language__ and is one of the shapefile formats that Fusion Tables understands. It contains a series of latitude and longitude coordinate pairs, each representing a part of the overall shape or boundary.

Here's what the KML for Washington DC looks like:

~~~xml
<Polygon>
  <outerBoundaryIs>
    <LinearRing>
      <coordinates>
        -77.007931,38.966667,0.0 
        -76.910905,38.8901,0.0 
        -77.045147,38.788234,0.0 
        -77.034947,38.814029,0.0 
        -77.044888,38.829478,0.0 
        -77.040104,38.838526,0.0 
        -77.038777,38.862543,0.0 
        -77.067586,38.886213,0.0 
        -77.078649,38.915711,0.0 
        -77.122328,38.932171,0.0 
        -77.042088,38.993541,0.0 
        -77.007931,38.966667,0.0
      </coordinates>
    </LinearRing>
  </outerBoundaryIs>
</Polygon>
~~~


If you're wondering, _how do I make such shapes myself?_ The answer is: it's kind of complicated. The shape data can come from any number of official sources (such as the U.S. Census). Then it's a bit of work to get it into a KML file, nevermind into a simplified spreadsheet. For our purposes, this KML data is just stuffed into a field called "`Geometry`". We leave it to Fusion Tables to parse that data and draw it on an interactive map.

I [downloaded the KML data from this public Fusion Table](https://www.google.com/fusiontables/DataSource?docid=1kQadVj5Dapm_Ypas_xczzQ32DwcFCRGD-r8406GC#rows:id=1), though I had to vastly simplify the coordinates of Alaska to make it compatible with Google Spreadsheets (there is a limit to how many characters you can stuff into a single cell: 50,000 characters).


So this is not a lesson about finding geodata, it's merely a demonstration of how to incorporate it into Fusion Tables.


## Gathering and cleaning via spreadsheet

The first steps involve working inside of the spreadsheet to prepare the data for Fusion Tables.


### Election results data

I gathered the [2012 U.S. Presidential Election](http://en.wikipedia.org/wiki/United_States_presidential_election,_2012) data by simply copying and pasting the [table of electoral college votes from Wikipedia](http://en.wikipedia.org/wiki/United_States_presidential_election,_2012#Votes_by_Electoral_College) into a spreadsheet.

![img](files/tutorials/fusion-tables/wikipedia-election-data.png)


Since we only care about Obama and Romney, we can cut out all the third-party candidate columns. We can also remove the __Electoral method__ column and subsequently, all rows that _aren't_ "Winner Take All (WTA)". If we sort by state name, we can basically align this table with the [KML table found here](https://www.google.com/fusiontables/DataSource?docid=1kQadVj5Dapm_Ypas_xczzQ32DwcFCRGD-r8406GC#rows:id=1).

Rather than making you go through that copy-and-paste operation, you can just [copy the resulting spreadsheet here](https://docs.google.com/a/stanford.edu/spreadsheets/d/18YaI4CDDOnhBHtX1vykmhwukfMeYqN9qdDggcnSfHFo/edit#gid=764026114).


### Deriving color columns

If you recall from the [previous Fusion Tables tutorial](/tutorials/mapping/basic-fusion-tables), FT let us define icons for every point using a designated column. For shapes, we can designate a column to be used for the border and fill color.

Let's just do that now [while we're working with the spreadsheet](https://docs.google.com/a/stanford.edu/spreadsheets/d/18YaI4CDDOnhBHtX1vykmhwukfMeYqN9qdDggcnSfHFo/edit#gid=764026114):

1. We are interested in the __difference__ between Obama's percentage of the vote and Romney's percentage of the vote. So create a column named `diff pct` and fill it with the formula `=E3-H3` (if `E` contains Obama's vote pct and Romney's vote pct respectively). Some of the columns will have a _negative_ percentage, and that corresponds to states in which Romney beat out Obama:
  
      ![img](files/tutorials/fusion-tables/diff-pct-column.png)


2. Let's create a second column derived from this `diff pct` and name it simply `victory_color`. If `diff pct` is positive, then `victory_color` will have a value of `#0000FF` (blue). Else, the value is `#FF0000` (red). 

    This is the formula: `=IF(J2 > 0, "#0000FF", "#FF0000")`

    ![img](files/tutorials/fusion-tables/victory_color_column.png)


OK, we're done with working in this spreadsheet. Go ahead and export it as CSV so that you can re-import it into a new Fusion Table. The takeaway here is that we're _preparing_ the data, i.e. _reshaping_ it, so that it meets FT's requirements for mapping and coloring.


## Mapping shapes with Fusion Tables

If you've skipped all the steps above and just want to see the Fusion Table, [here it is](https://www.google.com/fusiontables/DataSource?docid=1MdfSp2JWg2mQ6PfsBN991P5xTzExDfBC0P9xLemu#rows:id=1)

FT will use the `Polygon` column, in which we've stored the KML data, as the default column to map.

We will now be working inside the __Change map feature styles__ menu. In the [previous tutorial](/tutorials/mapping/basic-fusion-tables)), we configured the __Points > Marker icon__ setting. Now, we will work with __Lines__ and __Polygons__.


### Coloring borders

![img](files/tutorials/fusion-tables/borders-colored.png)

1. Click on the __Map 1__ tab. You should see the shapes and borders of the states drawn already.
2. Click the dropdown menu of the tab and select __Change Map__, which should open up the __Configure map__ left-panel if it isn't already open.
3. Under __Feature map__, click the __Change feature styles...__
4. Select __Lines > Line color__
5. Select the __Column__ tab and the __Use color specified in a column__
6. In that dropdown menu, select `victory_color` (or whatever you named the column)
7. Hit __Save__

The borders of each state should now be colored according to the candidate who received the most votes. If your state shapes are all _filled_ in with red, you can go back to the __Change map feature styles__ and, under __Polygons > Fill color__, change the fill color to gray to make the borders more evident.

##### Video

Watch me make the borders colorful:

<video id="fusion-tables-shapes-borders-001" class="video-js vjs-default-skin" controls preload="auto" width="100%"> <source src="/files/videos/mapping/fusion-tables-shapes-borders-001.mp4" type='video/mp4' /></video>


### Using buckets

Changing the __fill__ of the state shapes can be done as easily as we changed the lines. However, this time, we'll use the __Buckets__ tab. This allows us to define color based on the _numerical_ value of a column.

1. Re-open the __Change map feature styles__ menu
2. Select __Polygons > Fill color__
3. Select the __Buckets__ tab
4. Select __Divide into Custom buckets__
5. Change the data column to `diff pct` (or whatever you named it). This should give you the range of values (`-0.48 - 0.836`). Select `use this range`
6. Configure a couple buckets, making __negative__ numbers correspond to __red__, and __positive__ numbers correspond to __blue__:

    ![img](files/tutorials/fusion-tables/two-color-buckets.png)

7. Hit __Save__ and check out the map:

    ![img](files/tutorials/fusion-tables/two-color-gradient.png)


##### Video

Watch me make the states red and blue:

<video id="fusion-tables-shapes-two-color-gradient-0015" class="video-js vjs-default-skin" controls preload="auto" width="100%"> <source src="/files/videos/mapping/fusion-tables-shapes-two-color-gradient-0015.mp4" type='video/mp4' /></video>


#### Thinking about bucket size

There's a certain art and methodology to defining the "buckets". In the example above, we defined only two buckets: red for Romney states and blue for Obama states.

But our `diff pct` column contains more than just a binary value, it contains _margin of victory_. And by adding more buckets, our map can illustrate the _intensity_ of the popular vote victories by state.

Here's a sample configuration for five color buckets:

![img](files/tutorials/fusion-tables/five-color-buckets.png)


Here's the resulting map:

![img](files/tutorials/fusion-tables/five-color-gradient.png)


##### Video

Watch me refine the political-color map by adding more buckets:

<video id="fusion-tables-shapes-fills-002" class="video-js vjs-default-skin" controls preload="auto" width="100%"> <source src="/files/videos/mapping/fusion-tables-shapes-fills-002.mp4" type='video/mp4' /></video>


#### Bucket judgment

Play around with the values. Add more buckets, change the ranges, etc. One thing that is hopefully evident is how easy it is to change the message of the map by altering the bucket size and intensity of the color. Note how the map is subtly different if you decide that `+/-10%` margin of victory is the cutoff between pink/red and light-blue/darkblue, versus changing that cutoff to `+/-20` margin of victory.

In the __Change map feature styles__ menu, you can also define the intensity by using the __Gradient__ option, which will vary the color proportionate to the numerical values, using a smooth gradient for the __continuous__ scale of values, rather than you __defining__ the buckets by hand.

This is more "scientific", perhaps, but not always "better." In a given race, a 10% margin may be quite significant and worth highlighting, depending on how tight that race was believed to be. In the 2012 election data we have at hand, the margin of Obama victory goes up to __83%__, which skews the continuum, but that margin of victory only occurs in the District of Columbia.

This concept of thresholds is a nuanced one. Read [Steven Romalewski's critique of a heat map related to NYC's stop-and-frisks](http://spatialityblog.com/2012/07/27/nyc-stop-frisk-cartographic-observations/) to see how changing the thresholds (i.e. the buckets) can drastically impact the message of a map.




### Other resources

- [Penn Libraries guide to intensity maps with Fusion Tables](http://guides.library.upenn.edu/intensitymaps)

- [Official FT docs: Create an intensity map with custom boundaries](https://support.google.com/fusiontables/answer/1032332?hl=en)
