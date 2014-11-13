---
title: Data Exploration with OpenRefine
date: 2014-11-09
description: "OpenRefine is a power tool for cleaning data. In this tutorial, we learn basic operations for exploring the data in Refine."
---

The [OpenRefine homepage](http://openrefine.org/).

[Download it here](http://openrefine.org/download.html). This tutorial uses the __2.6 beta__, but the mechanics are largely the same as they are in 2.5.

The dataset for this tutorial will be the Federal Election Commission's list of Iowa individual contributors to the 2008 U.S. Presidential Race, [which you can find as a zipped file here](ftp://ftp.fec.gov/FEC/Presidential_Map/2008/P00000001/P00000001-IA.zip).

### About starting the OpenRefine application

One of the nicest things about OpenRefine is that it works from your web browser, which makes it about as intuitive as learning to use Google Spreadsheets. However, it is __not__ an _Internet application_, in the sense that you don't have to be connected to the Internet to use it.

When you open the OpenRefine application, you're starting a background server process (a black Terminal window may pop up for the briefest moment). It won't even seem that anything has been opened because, well, OpenRefine is in the _background_.

However, if everything is working as expected, you should be able to connect your browser to the address `http://127.0.0.1:3333/`

The address of `127.0.0.1` is actually _your own computer_. And that `:3333` specifies that you're connecting to port `3333` of your computer, which is what the OpenRefine app is currently running from.

### Creating a new project

_The dataset for this tutorial will be the Federal Election Commission's list of Iowa individual contributors to the 2008 U.S. Presidential Race, [which you can find as a zipped file here](ftp://ftp.fec.gov/FEC/Presidential_Map/2008/P00000001/P00000001-IA.zip)._

Upon opening Refine, we are presented with a minimal homepage for managing Refine projects. These projects are stored in a local directory on your computer (again, Refine doesn't need to touch the Internet), and every project you create can be re-opened from here. You can also __import__ Refine projects from other computers.

1. Select the __Create Project__
2. At the "Get data from" prompt, choose __This Computer__ 
3. Then click the __Choose Files__ button
   
    ![img](files/tutorials/open-refine/create-project-choose-files-001.png)

4. The next screen will let you preview how Refine will __parse__ the file. If you're using the Iowa FEC contributors CSV file, you everything should be parsed as expected and you can click the __Create Project >>__ button in the __top-right__ of the screen:

    ![img](files/tutorials/open-refine/preview-project-file-002.png)

5. After a bit of processing, you'll be taken to data, ready to explore and clean:

    ![img](files/tutorials/open-refine/initial-data-opening-003.png)




### Exploring the data panel

The screen is divided into two panels. On the left is the __Facet/Filter panel__, which we'll cover in the next section. The wide panel on the right contains a view of the imported data, similar to a spreadsheet:

![img](files/tutorials/open-refine/data-panel.png)

One thing should stick out to you: Only 10 rows at a time are shown. This can be changed to show up to __50__ rows, but you still have to click through the pagination to all the pages. So, in other words, exploring the data in Refine is not as easy or effortless as it is in a spreadsheet.

That may be a disadvantage, but we'll see soon that scrolling through lots of data rows is __not the intended use case__ for Refine (or for the database GUIs we've so far used).


#### Editing cells

Changing the value of a cell is pretty straight-forward. Just hover the mouse over the cell until you see the word __Edit__ pop-up. Click on that, and a new dialog box will appear:

![img](files/tutorials/open-refine/edit-cell.png)

Refine offers us two choices of alteration: Altering just the value of that single cell, or, __Apply to All Identical Cells__. In this case, if we wanted to change `UNITED STATES ARMY` to `U.S. ARMY` and selected __Apply to All Identical Cells__, it would be as if we did a Find and Replace All action for the `UNITED STATES ARMY` value inside the `contrib_employer` column. Handy!

#### Column headers

![img](files/tutorials/open-refine/edit-column.png)

The dropdown menus, which can be accessed by clicking the little down arrow for each column header, is the quickest way to access Refine's most commonly used powerful features. You can also do things such as rename/remove/move columns, but Refine really isn't about rearranging your data columns.

For the purposes of this tutorial (and the next one, about [clustering data](/tutorials/open-refine/clustering)), we care about the __Facet__ submenu and the __Text filter__ command.


### The Facet and Filter panel

Let's now turn our attention to the left-side panel, which I'll refer to as the __Facet/Filter__ panel. Currently it's empty. So in the __data panel__, click on the column dropdown for `contrib_city` and select __Text filter__:

![img](files/tutorials/open-refine/column-dropdown-text-filter.png)

Selecting that will pop open a new subpanel on the Facet/Filter panel:

![img](files/tutorials/open-refine/facet-contrib-city.panel.png)


Start typing in a term, such as `CEDAR`. The __data panel__ will dynamically update. Also, note that in the __top-left__ of the data_panel, the number of active rows will change. The dataset has 28,553 rows. But when you __filter__ the `contrib_city` by `CEDAR`, the data panel will show only __2,010__ matching rows:

![img](files/tutorials/open-refine/matching-cedar-rows.png)


##### Combining text filters

Let's add another __Text Filter__ for the column of `contbr_employer`. Then type in something like `ROCKWELL`. The data panel will now show just __91__ matching rows, in other words, only 91 rows have a city with the word `CEDAR` in it *and* a `contrib_emplyer` with the word `ROCKWELL` in it.


![img](files/tutorials/open-refine/matching-cedar-rockwell-rows.png)

##### Clearing the filter subpanels

If you erase the filter terms, the data panel will update to show the matching rows. You can also click the little X box to remove the filter panels. Removing both panels will result in the data panel showing all 28,553 rows again.

It's important to note that this filtering is __not__ destructive. Rows don't get deleted in Refine unless you explicitly delete them &ndash; and in general, you should never delete data in Refine...it's always better just to hide/show rows as needed, because undeleting things is a painful process.

Text filters in Refine can be thought of as doing a `WHERE` statement in SQL with multiple `AND` conditions, though for small datasets, it's certainly much faster to use Refine's interactive GUI. Sometimes I'll use Refine solely for quick filtering of datasets (note: it will be a bit clunky for datasets of a million rows and larger).


#### Text facet

Text filters is fun, but where Refine _really_ shines is with its __faceting__ capabilities. In the data panel, click the dropdown for `contrib_city`, then select __Facet > Text facet__

![img](files/tutorials/open-refine/refine-text-facet-dropdown.png)

A new subpanel will show up on the left that contains a list of all _unique_ terms that exist in the city column, along with how many occurrences there are. In SQL, this would be like doing the following aggregation query:

~~~sql
SELECT contrib_city, COUNT(*)
FROM contributions
GROUP BY contrib_city
ORDER BY contrib_city
~~~

The panel can be sorted by __count__ of the terms, and it will conveniently display the number of unique choices (617). Already we can see how messy that contributions data is: `43RD ST NE` is probably not the name of a city in Iowa:

![img](files/tutorials/open-refine/facet-contbr-city.png)

Click on any one of the __facets__; the data panel will, as it did with __text filters__, immediately refresh to show all rows that have the selected city. You can also include multiple cities; in effect, this is another way of doing a text filter on multiple cities:

![img](files/tutorials/open-refine/include-multiple-facets.png)


##### Multiple text facets

Click the dropdown for `contbr_employer` and add a __Text facet__. Just as with filters, we can combine numerous text facets. If you didn't reset the facet for `contrib_city`, then the facet count for `contbr_employer` will reflect only the facets that appear in the __matching rows__.

So in the example below, where I've selected `IOWA CITY` and `WEST DES MOINES` as the active city facets, there are  __463__ different employer names:

![img](files/tutorials/open-refine/facets-for-employer-and-city.png)



### Conclusion

There's a lot more to Refine, but at least we know now how to quickly browse and explore the data. In the lesson on [clustering](/tutorials/open-refine/clustering), we'll see how Refine uses powerful text-manipulation algorithms to help us clean up the messiness of hand-entered data.


### Other resources

- [The official screencasts from OpenRefine](https://github.com/OpenRefine/OpenRefine/wiki/Screencasts)
- [Using Google Refine to Clean Messy Data](http://www.propublica.org/nerds/item/using-google-refine-for-data-cleaning) by me, while I was at ProPublica
- [Cleaning Data with Refine](http://schoolofdata.org/handbook/recipes/cleaning-data-with-refine/) by the School of Data
