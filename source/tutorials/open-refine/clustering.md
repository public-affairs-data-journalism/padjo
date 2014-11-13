---
title: Clustering text facets in OpenRefine
date: 2014-11-10
description: "OpenRefine gives point-and-click access to a variety of powerful text clustering algorithms."
---

__Note:__ The dataset for this tutorial will be the Federal Election Commission's list of Iowa individual contributors to the 2008 U.S. Presidential Race, [which you can find as a zipped file here](ftp://ftp.fec.gov/FEC/Presidential_Map/2008/P00000001/P00000001-IA.zip).


Check out the [previous tutorial for an introduction of how to get around OpenRefine](/tutorials/open-refine/introduction-to-open-refine). As we saw with a little exploration, the data on Iowans who contributed to the 2008 presidential elections is riddled with inconsistent labels and typos.

For instance, look at the many ways that [Hy-Vee, a popular grocery chain](http://www.hy-vee.com/), is spelled:

![img](files/tutorials/open-refine/hy-vee-spellings.png)

It's simple enough to clean this up on a company-by-company basis. But we really don't know how many companies there are in this dataset, nevermind the many ways the companies might be misspelled.

This is where Refine truly shines as a tool.


### Duplicating a column

The very first step you should do in every cleaning operation is to __duplicate the data__ that you intend on cleaning. So let's say we want to clean up the `contbr_employer` column with all of its Hy-Vee variations. We want to keep the _original data_ so that we have a reference to what it was compared to the cleaned up version.

In Refine, we can duplicate a column by clicking the dropdown and selecting __Edit column > Add column based on this column...__

This will bring up a pop-up window. We can do lots of fun things here with a little programming knowledge, but for now, let's just type in a __New column name__, such as `cleaned_up_contbr_employer`, and hit __OK__:

![img](files/tutorials/open-refine/cleaned_up_contbr_employer.png)

Refine will let us know how many rows for which it duplicated the values (except for the blanks, in which case, it didn't have to do anything) and we will see a new column next to the original column: 

![img](files/tutorials/open-refine/cleaned-up-note-column.png)


#### Simple clustering

First, do a __Text facet__ of the `cleaned_up_contbr_employer` column. 

##### Troubleshooting too many facets

Note: If you get an error about there being too many facets, in your browser address bar, visit this address:

     http://127.0.0.1:3333/preferences

Then, add a new __property__ with this name:

    ui.browsing.listFacet.limit

And give it a value of __10000__:

![img](files/tutorials/open-refine/refine-preferences-facets.png)

----------------


If the clustering works as intended, in the Iowa data, you should see __2999__ different employers.

Now click the __Cluster__ button to bring up a new pop-up:

![img](files/tutorials/open-refine/fingerprint-cluster-popup.png)


The screen will seem a little overwhelming, but what Refine is doing here is showing how all the terms will be __clustered together__ given the currently selected clustering algorithms.

By default, the first clustering algorithm is the __strictest__: the __key collision__ method named **fingerprint**. And according to Refine, there are __99__ clusters found:

![img](files/tutorials/open-refine/method-key-collision-select.png)


What exactly is a cluster? Take a look at the first one, which should be `ACT, INC`:

- `ACT, INC.` (20 rows)
- `ACT INC.` (14 rows)
- `ACT, INC` (11 rows)
- `ACT INC` (2 rows)

Refine is telling us that all of these terms are pretty much the same, minus punctuation and spelling variations. The "(20 rows)" refers to how many rows have that facet.

There are two options we have per cluster:

- Do we want to __merge__ the cluster?
- And if we do merge the cluster, what should be the value used for all variations of this cluster?

![img](files/tutorials/open-refine/act-cluster.png)

Obviously, if we don't want to merge the cluster, we leave the __Merge?__ option unchecked. However, if we check that box, the default value used will be `ACT, INC.`...it's the default because more rows in this cluster have `ACT, INC.` (20), versus all other variations, such as `ACT INC`, which as 2 rows.

Go ahead and click the Merge checkbox. Then at the bottom of the popup, click the __Merge Selected & Close__ button.

Then, take a look at the __Facet/Filter__ panel. Instead of __2,999__ choices for the `cleaned_up_contbr_employer`, we have __2,996__. In other words, the __4__ variations of `ACT, INC.` were collapsed into a single canonical term.

So in a nutshell, this is how we clean data in Refine: remove as many variations as possible.


### Really elaborate clustering

Refine has six algorithms. Here they are in order, from strictest (i.e. the least number of false positives) to loosest (most false positives, and slowest):

- key collision: fingerprint
- key collision: ngram-fingerprint
- key collision: metaphone3
- key collision: cologne-phonetic 
- nearest neighbor: levenshtein
- nearest neighbor: PPM

Since we just saw how the strictest clustering worked (fingerprint), let's jump right to **nearest neighbor: PPM**. Note. your computer may crash upon trying this:

![img](files/tutorials/open-refine/ppm-initial.png)


It's pretty amazing the kinds of variations PPM will cluster together. Everything from `UNIVERSITY OF NORTHERN IOWA` versus the typo of `UNVIERSITY OR NORTHERN IOWA` to the similarity of `NOT EMPLOYED` and `NO EMPLOYER` &ndash; imagine trying to find that variation using simply a spreadsheet or database query.

On the other hand, there's a lot of possible false positives. For example, is `WESTERN IOWA TECH COMMUNITY COLLEGE` really the same as `IOWA WESTERN COMMUNITY COLLEGE`?


#### Cluster browsing

Refine's interface allows us to browse ambiguous clusters. In this example, I hover over the `WESTERN IOWA TECH COMMUNITY COLLEGE` cluster, which brings up a pop-up action named "__Browse this cluster__". Clicking that brings up what looks like an entirely new instance of the Refine browser, but focused _specifically_ on this single cluster:

![img](files/tutorials/open-refine/western-iowa-college.png)


It looks like the two colleges are indeed different, or at least they employ people from entirely different zip codes. It's not entirely unambiguous, but at least Refine gives us a way to quickly scout the situation before turning to Google.

We can close this cluster-browsing-tab to return to our previous clustering operation.


### Clean and export

Pretend you've done all the clustering and cleaning you need to do. The result is that you should have the original `contbr_employer` column and the cleaned up version side by side. Now you can export it by clicking the __Export__ button in the top right.

Now, you can import into Excel, or a Pivot Table, and group by the cleaned up employer column to get a more accurate total of which company's employees contributed what.



### Clustering algorithms

After you've done some simple fun cleaning in Refine, it's worth examining the _algorithms_ Refine gives us access to, as well as the theory behind those algorithms.

[From the Refine wiki](https://github.com/OpenRefine/OpenRefine/wiki/Clustering-In-Depth):

> In OpenRefine, clustering refers to the operation of "finding groups of different values that might be alternative representations of the same thing". For example, the two strings "New York" and "new york" are very likely to refer to the same concept and just have capitalization differences. Likewise, "Gödel" and "Godel" probably refer to the same person.

The [Refine wiki page](https://github.com/OpenRefine/OpenRefine/wiki/Clustering-In-Depth) has a fuller, more accurate description of the available algorithms, but I'll attempt to summarize them.

There are two classes of clustering methods: [Key collision](https://github.com/OpenRefine/OpenRefine/wiki/Clustering-In-Depth#key-collision-methods) and [Nearest Neighbor](https://github.com/OpenRefine/OpenRefine/wiki/Clustering-In-Depth#nearest-neighbor-methods).

I'll cover the methods in order from strictest to loosest:


##### Key collision: Fingerprint

Consider these three variations of "John F. Kennedy":

- `John   F. Kennedy`
- ` JOHN F. KENNEDY`
- `JOHN   F    Kennedy`
- `Kennedy, John F.`

In a given dataset, these terms might reasonably be considered to refer to the same person. What the __fingerprint__ method does is normalize the "whitespace" and capitalization, order the white-space-separated terms in alphabetically, and remove the punctuation. So the variations all basically look like this:

     f john kennedy

And thus, they are _clustered_ together.



##### Key collision: N-Gram Fingerprint

This is a "looser" version of the fingerprint. Whereas the prior method separated by whitespace, this simply removes all whitespace and then creates n-grams of the word. [The explanation from the Wiki](https://github.com/OpenRefine/OpenRefine/wiki/Clustering-In-Depth#n-gram-fingerprint):

> So, for example, the 2-gram fingerprint of "Paris" is "arispari" and the 1-gram fingerprint is "aiprs".

> Why is this useful? In practice, using big values for n-grams doesn't yield any advantage over the previous fingerprint method, but using 2-grams and 1-grams, while yielding many false positives, can find clusters that the previous method didn't find even with strings that have small differences, with a very small performance price.

> For example "Krzysztof", "Kryzysztof" and "Krzystof" have different lengths and different regular fingerprints, but share the same 1-gram fingerprint because they use the same letters.


In the John F. Kennedy example, these variations would be considered the same when using the ngram fingerprint:

- `John F Kennedy`
- `JohnF Kennedy`
- `John John F Kennedy`



##### Key collision: Phonetic Fingerprint

This fingerprinting method eschews the spelling of a term and attempts to interpret a term _as it is pronounced_. So, the following variations could be clustered together:

- `Jon F Kennedy`
- `Jonn F Kennedy`

However, this being an even _looser_ method, you will get false positives. For example, these are probably not referring to JFK, but might share a similar phonetic fingerprint:

- `Jawn Eff Kennadee`
- `Jawn F Ken A.D.`


##### Nearest neighbor: Levenshtein distance

The "nearest neighbor" methods are more computationally expensive, but unlike fingerprint methods, can find the kind of variations that aren't simple typos or mispellings.

Levenshtein distance is a measure of _how many changes_ you must make to get from one term to another. For example, there is a "distance" of 1 between `John F. Kennedy` and `John H. Kennedy`, because the only change you have to make is converting `F` to `H`. And there is a distance of 3 between `Jan X. Kennedy` and `John F. Kennedy`: (removing `h`, changing `o` to `a`, and changing `F` to `X`). As you can imagine, the possibility of a __false positive__ is very high as you increase the Levenshtein distance.


##### Nearest neighbor: PPM

The math involved here is beyond my explanation, so I'll [direct to the Wiki's explainer](https://github.com/OpenRefine/OpenRefine/wiki/Clustering-In-Depth#ppm):

> The idea is that because text compressors work by estimating the information content of a string, if two strings A and B are identical, compressing A or compressing A+B (concatenating the strings) should yield very little difference (ideally, a single extra bit to indicate the presence of the redundant information). On the other hand, if A and B are very different, compressing A and compressing A+B should yield dramatic differences in length.

PPM will almost seem like magic, and I prefer it Levensthein. The kind of variations a PPM can detect without generating too many false positives includes:

- `John F Kennedy`
- `Jack F Kennedy`
- `John Fitzgerald Kennedy`
- `President John F Kennedy` 

But PPM will cluster together terms that are of no obvious relation. Refine gives you the option of decreasing the __radius__ of the PPM algorithm: I'd advise not going far below 3 or 4.








### Other resources

- [The official screencasts from OpenRefine](https://github.com/OpenRefine/OpenRefine/wiki/Screencasts)
- [Using Google Refine to Clean Messy Data](http://www.propublica.org/nerds/item/using-google-refine-for-data-cleaning) by me, while I was at ProPublica
- [Cleaning Data with Refine](http://schoolofdata.org/handbook/recipes/cleaning-data-with-refine/) by the School of Data
