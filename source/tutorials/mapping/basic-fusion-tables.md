---
title: Introduction to Data Mapping with Fusion Tables
date: 2014-10-01
layout: tutorial
description: Google's handy tool for publishing interactive maps from large datasets.
published: true
---

In this tutorial, we cover Google Fusion Tables, a database service that can handle significantly larger datasets than Google Spreadsheets and be used to power data-heavy web applications.

However, we only care about FT's ready-to-go interactive mapping functionality: FT is not the best database software nor the best mapping software, _but what it lacks in flexibility it makes up for convenience_, especially if you need to quickly produce an interactive map and publish it to the Web.

Fusion Tables is very much like a spreadsheet, though not really designed for quick data entry or fixes. In other words, you want to do most of your data-wrangling and editing in a spreadsheet __before__ you import it into Fusion Tables.

__Download this dataset as a CSV__: [SFPD crime incident reports from January to March 2014](https://docs.google.com/a/stanford.edu/spreadsheets/d/1tSc2ivROr9Gj6h27wU5THgPmiA3VrcfSPNVD_ravLqE/)


### Importing data

Go to [Fusion Tables in your Google Drive](https://www.google.com/fusiontables/data?dsrcid=implicit) (you may first have to Connect it as an App).

In the __Import New Table__ dialog, __Choose File__ from your computer. Select the [CSV that you just downloaded](https://docs.google.com/a/stanford.edu/spreadsheets/d/1tSc2ivROr9Gj6h27wU5THgPmiA3VrcfSPNVD_ravLqE/) then hit the __Next__ button. The next dialog box you'll see is a preview of the table. If it looks fine, hit __Next__ again. And you can hit __Finish__ on the next dialog after customizing your table info.


##### Video

<video id="fusion-tables-importing-001" class="video-js vjs-default-skin" controls preload="auto" width="100%"> <source src="/files/videos/mapping/fusion-tables-importing-001.mp4" type='video/mp4' /></video>



It'll take a minute or so to load, and then it will look like this:

![img](/files/tutorials/fusion-tables/sf-crimes-imported.png)


### Mapping the data


I'll skip over the table-functionality for now, let's get right to making a map.

The first thing we have to do is tell Fusion Tables which __column__ to use. If we give it a column that contains text, such as "100 Broadway, San Francisco CA", Fusion Tables will __geocode__ that address and place a marker on the map.

The SFPD data already has geocoordinates in the `x` and `y` columns. So we just need to tell Fusion Tables to use those columns.

Go to __Edit > Change Column__

Select the `y` column and set its __Type__ to __Location__

Then click the __Two column location__ and set __Latitude__ to `y` and __Longitude__ to `x`

Then click the __Save__ button.

It'll take a few moments for Fusion Tables to update the schema, i.e. "interpret" the `x` and `y` columns as geocoordinates.

##### Video

<video id="fusion-tables-location-002" class="video-js vjs-default-skin" controls preload="auto" width="100%"> <source src="/files/videos/mapping/fusion-tables-location-002.mp4" type='video/mp4' /></video>




#### Add a Map tab

Mapping the data is now as easy as creating a __Map__ view, which will show up in the FT interface as a tab. Click the __red `+` sign__ on the menubar and select __Add map__.

In the __Configure map__ sidemenu, select `y` as the column for __Location__

##### Video

<video id="fusion-tables-map-made-003" class="video-js vjs-default-skin" controls preload="auto" width="100%"> <source src="/files/videos/mapping/fusion-tables-map-made-003.mp4" type='video/mp4' /></video>


When you're done, the map of San Francisco will be covered in red dots, each one representing a crime report.

![img](/files/tutorials/fusion-tables/sf-crimes-map-first-010.png)




### Basic filtering

As in every kind of storytelling, getting to the point is important in map making. There's far too many dots on this map, so let's __filter__ out the less important ones using FT's built-in filtering capability.

1. In the __Map__ tab, click on the blue __Filter__ button. This will bring up a dropdown menu. Choose the `category` field.
2. A sidebar will appear on the left side. Check the boxes of crime categories you'd like to see on the map. You can see the map dynamically update with each choice. In my example, I choose the `ASSAULT` category, which still leaves 2,437 points on the map.
3. Click the __Filter__ button again and choose the `descript` field: this will allow you to filter by subcategories of crime. 
4. Clicking the little 3-bar icon in each panel's titlebar will reveal another dropdown, allowing you to filter, well, the filtering choices. For example, selecting"__Values match pattern with % wildcards__" and then doing a __Find__ for "`AGGR%`" will quickly filter the reports to just the __aggravated assaults__. You don't even have to manually check each of those boxes. This filters the list of assaults to 596. 

![img](/files/tutorials/fusion-tables/sf-aggro-assaults.png)


##### Video

<video id="fusion-tables-filtering-004" class="video-js vjs-default-skin" controls preload="auto" width="100%"> <source src="/files/videos/mapping/fusion-tables-filtering-004.mp4" type='video/mp4' /></video>    



### Formulaic work

![img](files/tutorials/fusion-tables/sf-assaults-red-yellow-map.png)


I mentioned earlier that you'll want to do all of your data cleaning and manipulation in a spreadsheet _before_ you move it to Fusion Tables, because FT simply is less suited for such work.

It _is_ inconvenient to import/export data back and forth. But as I've said before, there's just no do-it-all data tool. With Fusion Tables, we get some quick-and-easy interactive maps, and the price we pay is less flexibility.

In this section, we'll go through the motions, which are necessary to create a map with differentiated icons.

#### Making something notable

The problem with our aggravated assaults map, which we've filtered to 596 records, is that every dot looks the same. But we might believe that some incidents are more..._notable_...than others, and it's worth highlighting them in the map.

The most direct way to do this is to specify _different icons_ for certain records. But first things first, what constitutes a more _notable_ aggravated assault? Look at the data again. There's a `resolution` field, which mentions what the police _found or did_ in response to the call, including making an arrest. 

While we're in the Map view with the filters menu open, let's just add the `resolution` field as another filter so we can get a quick fix of the various ways aggravated assaults were resolved:

![img](/files/tutorials/fusion-tables/sf-agg-assault-resolution-filter.png)

It looks like the possible resolutions are split between `ARREST, BOOKED` (244 cases) and `NONE` (325 cases), with a smattering of other resolutions (e.g. `COMPLAINANT REFUSES TO PROSECUTE` and `PSYCHOPATHIC CASE`).

So let's divide up the map markers into two things: `NONE`, and everything else (most of which involve arrests), with the opinion that _no_ resolution implies a possible unsettling scenario, such as a stabbing suspect who hasn't been apprehended.

#### Specifying different map markers

1. To customize the map markers, we need to __Change map__, an action that can be found by clicking the dropdown arrow of the __Map__ tab. This pop opens the panel titled, __Configure map__
2. In that panel, click __Change feature styles__. This will open a new popup window titled, __Change map feature styles__. In the side-list of actions, click __Points > Marker icon__.
3. By default, the map is set to the __Fixed__ option, which allows you to choose just one icon for all of the points. Click the __Column__ tab, which reveals the option to __Use icon specified in a column__

![img](/files/tutorials/fusion-tables/change-icon-column-submenu.png)

Problem is, we don't have a column in the way that Fusion Tables wants it. Yes, we know we want to ultimately differentiate icons by `resolution`, but [FT wants a column in which the values are things](https://support.google.com/fusiontables/answer/2679986?hl=en) like `large_red` or `f_blue`.

In other words, we need to create a __new column__ dedicated to naming the icon we want to use.

##### IF only we had a column for icons

This is where we need to import/export from FT to Spreadsheets and back to FT again:


1. While in the __Map__ view with the filtered aggravated assaults, select __File > Download__ from the menubar. Choose the options __Filtered rows__ and __CSV__ &ndash; in other words, we don't want to export all the 32,000 original rows, just the 600 assaults we've filtered for.
2. Open __Google Spreadsheets__ and re-import the newly downloaded CSV.
3. Create a new column named `icon`. 
4. We will now build a semi-complicated logical formula. First, let's think about what we __want__: We want a `icon` column that, when the corresponding `resolution` value is `NONE`, has a name of one type of icon, e.g. `small_red`. And for all other `resolution` values, they should have an `icon` value of `small_yellow`

5. Now think about this in terms of basic computer functionality: 

    > __If__ the value in the `resolution` column __equals__ the text string of  `NONE`, __then__ insert the text string of `small_red` into the `icon` column. __Else__, insert `small_yellow`.


6. This calls for the logical `IF` function. Here's its documentation:

        IF(logical_expression, value_if_true, value_if_false)

        Example:
        IF(A2 = "foo", "A2 is foo", "A2 is not foo")

    
    And this is what we want for our scenario:

          =IF(F2 = "NONE", "small_red", "small_yellow")

    ![img](files/tutorials/fusion-tables/spreadsheet-match-for-none.png)
 


7. We have what we need to make differentiated icons on our Fusion Tables map. So now __export__ the data out of Spreadsheets and __import__ back into Fusion Tables (it's probably easier to create a brand new table). Yes, you'll have to redo that step of specifying the `x` and `y` columns as being of the __Location__ type. This is why it's better to this data transformation before you ever go into Fusion Tables, but now you've had a hands-on experience with the more pedantic work in data visualization.


8. Finally, follow the steps previously outlined above in the **Specifying different map markers** section. Here's the __video__ of those steps, once the re-importing has been done:

    <video id="fusion-tables-icon-column-005" class="video-js vjs-default-skin" controls preload="auto" width="100%"> <source src="/files/videos/mapping/fusion-tables-icon-column-005.mp4" type='video/mp4' /></video>    




### Publishing to the web

Have you created a __Github Pages repository__ yet? [If not, follow this tutorial and get back here](/github/pages-setup).

One of Fusion Tables's most convenient features is that your work not only lives on the web (inside of the FT app hosted on Google), but it can be easily embedded as an interactive into your a webpage of your choice.


1. If you're still looking at your Fusion Tables assaults map, select __Tools > Publish__ from the menubar.
2. The first thing to do is make the table __publicly viewable__. FT will prompt you to __Change visibility__. Click on that link and set your table's visibility settings so that anyone on the Web can view your table.
3. Back in the __Publish__ dialog box, customize the __width__ and __height__ of the map to your liking. 
4. Select the __Get HTML and JavaScript__ dropdown, then select all the code and __Copy__ it to your clipboard.
5. Go to your __Github Pages repository__, e.g. 

    `https://github.com/USERNAME/USERNAME.github.io`

6. __Create a new file__, name it something like `assaults-map.html`, and then __Paste__ your clipboard into the file. If you know a little HTML, you can edit the file as you like (between the `<body>` tags at the very bottom of the pasted code). 
7. __Commit__ the file.
8. Visit the page at: `http://USERNAME.github.io/assaults-map`

##### Video

<video id="fusion-tables-publish-006" class="video-js vjs-default-skin" controls preload="auto" width="100%"> <source src="/files/videos/mapping/fusion-tables-publish-006.mp4" type='video/mp4' /></video>




### Conclusion

TK



##### More info

- [Create with Fusion Tables tutorial](https://support.google.com/fusiontables/answer/184641)
- [Intro to Data Mashing and Mapping with Google Fusion Tables](http://www.smalldatajournalism.com/projects/one-offs/mapping-with-fusion-tables/)




