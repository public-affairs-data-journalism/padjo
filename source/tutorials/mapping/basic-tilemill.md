---
title: Introduction to Data Mapping with TileMill
date: 2014-10-03
layout: tutorial
description: An open-source tool for combining maps with data layers
---

[TileMill](https://www.mapbox.com/tilemill/) is a free, open-source program developed by the [MapBox cartography service](https://www.mapbox.com/). It's substantially more flexible and powerful than [Google Fusion Tables](/tutorials/mapping/basic-fusion-tables) in terms of developing and designing maps. The tradeoff is that there's a few more steps and services involved in publishing an interactive map online. 

In this tutorial, we'll learn how to setup TileMill and create a styled map of earthquakes. In fact, it will pretty much be a [step-by-step ripoff of the crash course guides](https://www.mapbox.com/tilemill/docs/crashcourse/introduction/) found on the MapBox site itself:

- [Importing data](https://www.mapbox.com/tilemill/docs/crashcourse/point-data)
- [Styling data](https://www.mapbox.com/tilemill/docs/crashcourse/styling)


### Setup a project

Check out the [official installation docs from Mapbox](https://www.mapbox.com/tilemill/docs/install/). Installing TileMill should be as easy as downloading an installer and running it.

Opening TileMill takes you to the __Projects__ screen. Click __+ New Project__ and name your project. 

By default, TileMill will initialize the project with a layer of __countries__, i.e. the borders of the world's countries.


##### Video

Watch me create a new TileMill project:

<video id="tilemill-new-project-001" class="video-js vjs-default-skin" controls preload="auto" width="100%"> <source src="/files/videos/mapping/tilemill-new-project-001.mp4" type='video/mp4' /></video>


### Importing data and creating a new layer

![img](files/tutorials/tilemill/earthquakes-layer.png)

TileMill can import CSV to create a new __layer__ of data. In order for this data to show up as points on a map, there must be __latitude__ and __longitude__ coordinates, i.e. having just a column of addresses won't work, you'll need to geocode them.

For this exercise, we'll be using a dataset that comes with geo-coordinates: a list of earthquakes [as detected by the U.S. Geological Survey](http://earthquake.usgs.gov/earthquakes/feed/v1.0/). You can build your own dataset via the [USGS's archive search](http://earthquake.usgs.gov/earthquakes/search/). Or you can use the [CSV I've generated](/tutorials/tilemill/earthquakes-7.0.csv) from a query that includes all earthquakes since 1950 that had a magnitude of 7.0 or greater.

Here's what that CSV looks like as a spreadsheet:

![img](files/tutorials/tilemill/earthquakes-csv-preview.png)


1. Download [the CSV here](/files/tutorials/tilemill/earthquakes-7.0.csv).
2. Click the __Layers icon__ at the bottom left. You'll see that a **#countries** layer already exists. Click **+ Add layer**.
3. In the __Add layer__ dialog, select the __Browse__ button by the __Datasource__ field
4. Find the earthquakes-related [CSV that you've downloaded](/files/tutorials/tilemill/earthquakes-7.0.csv).
5. Click the __Save & Style__ button
6. You'll see two changes:
    1. The world map is now full of red dots, one for each earthquake event.
    2. The `style.mss` sheet now contains some code for the `#earthquakes7` element. We'll be dealing with this in the next section.

##### Video

Watch me add the layer of earthquakes data:

<video id="tilemill-earthquake-layer-002" class="video-js vjs-default-skin" controls preload="auto" width="100%"> <source src="/files/videos/mapping/tilemill-earthquake-layer-002.mp4" type='video/mp4' /></video>



### Styling the map

![img](files/tutorials/tilemill/pink-orange-map.png)

How much you enjoy this next section will vary upon your previous experience with [CSS, the styling language for webpages](https://developer.mozilla.org/en-US/docs/Web/Guide/CSS/Getting_started).

TileMill uses its [own kind of style language called CartoCSS](https://www.mapbox.com/tilemill/docs/manual/carto/), which looks like CSS but contains features specific to TileMill-generated maps.

We can play around with these styles by editing the code found in the right-side panel, which shows the contents of the `style.mss` file. Let's muck about with the default styles to get a feel for what we can change.

1. Let's change the color of the countries' boundaries to __blue__. In the `#countries ::outline` selector, change the value of the `line-color` property to `blue`. If you alter the default code, it will look like this: 
   
          #countries {
            ::outline {
             line-color: blue;
             line-width: 2;
             line-join: round;
           }
           polygon-fill: #fff;
          }

2. Hit the `Save` button.
3. Try making these changes:
   
   1. Change the fill color of the countries by changing the value of `polygon-fill`
   2. Change the color of the non-country shapes (i.e. the bodies of water) to `pink`; this value is found in the `Map` element and its `background-color` value. 
   3. Since some of the earthquake events happened on top of each other, let's make their color transparent by adding a `marker-fill-opacity` property and setting it to `0.1` (i.e. 10%).

          Map {
            background-color: pink;
          }

          #countries {
            ::outline {
              line-color: blue;
              line-width: 2;
              line-join: round;
            }
            polygon-fill: orange;
          }

          #earthquakes7 {
            marker-width:6;
            marker-fill:#f45;
            marker-line-color:#813;
            marker-allow-overlap:true;
            marker-fill-opacity: 0.1;
          }
    

  
##### Video

Watch me make these style changes to the map:


<video id="tilemill-color-styling-003" class="video-js vjs-default-skin" controls preload="auto" width="100%"> <source src="/files/videos/mapping/tilemill-color-styling-003.mp4" type='video/mp4' /></video>



Check out Mapbox's [online reference for all the different parameters we can use in CartoCSS](https://github.com/mapbox/carto/blob/master/docs/latest.md).


### Creating conditional styles based on data

![img](files/tutorials/tilemill/earthquakes-conditional-markers.png)


CartoCSS becomes even more fun when we use it to make _styles_ __based on the data__. For example, it'd be nice if these dots corresponded to the _magnitude_ of the earthquakes, e.g. the `mag` field in our original CSV.

This example is based on the [official tutorial, in the section named Conditional Styles](https://www.mapbox.com/tilemill/docs/crashcourse/styling/#conditional-styles)

1. Review the structure of the dataset by going to the __Layers__ submenu and clicking the __Features icon__ (it looks kind of like a spreadsheet) next to the `earthquakes7` layer.
2. Scroll to the right of our wide CSV file (if you're on a Mac and the scrollbars aren't showing, just use the __arrow keys__). Note the name of the field, `mag`, and its range: from `7` to `9.1`
3. In the `styles.mss` sheet, we can customize the size of the marker by using the `marker-width` property and using this kind of boolean notation _inside_ of the `#earthquakes7` element:
    
        #earthquakes7 {
          [mag >= 7]{ marker-width: 4}
          [mag >= 8]{ marker-width: 20}
          [mag >= 9]{ marker-width: 100}
        }
    
##### Video

Watch me type in these conditional styles to customize the size of the dots.


<video id="tilemill-conditional-styling-004" class="video-js vjs-default-skin" controls preload="auto" width="100%"> <source src="/files/videos/mapping/tilemill-conditional-styling-004.mp4" type='video/mp4' /></video>



### Conclusion

We'll save other TileMill features, such as adding popups and publishing an interactive map, for another tutorial. Or, [you can check out the official crash course guide at Mapbox](https://www.mapbox.com/tilemill/docs/crashcourse/introduction/).

For now, there's no shame in just exporting the map as a PNG, or even taking a screenshot of the map, and including it as a static image file on a webpage.

#### Other resources

- [Mapbox's Crash Course Guide to TileMill](https://www.mapbox.com/tilemill/docs/crashcourse/introduction/)

- [The Insanely Illustrated Guide to Your First Data-Driven TileMill Map](http://dataforradicals.com/the-insanely-illustrated-guide-to-your-first-tile-mill-map/)

- [CartoCSS reference](https://github.com/mapbox/carto/blob/master/docs/latest.md)

- [So you want to make a map](https://github.com/veltman/learninglunches/tree/master/maps)

- [Making maps with Leaflet: A starter guide](https://github.com/veltman/learninglunches/tree/master/leaflet) (Leaflet is another kind of mapping framework for the web).
