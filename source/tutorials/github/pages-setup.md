---
layout: tutorial
title: Setting up Github Pages
description: A guide to setting up Github as a webserver using only a web browser
date: 2014-09-29
---

__Quick note:__ *This guide really isn't for everyone. In my class, students have a variety of OS setups, not all of them that meet the minimum requirements for the Github desktop client. If that's not a problem with you, [then that's what you should be using](https://help.github.com/articles/what-are-github-pages). This approach works via just the web browser, but without all the conveniences of the command-line or the desktop client.*

This is a simple step-by-step walkthrough on how to create a new Github repo &ndash; referred to as the [Github Pages](https://help.github.com/categories/20/articles) feature &ndash; that can specifically be used to host and publish custom web pages, including testing out interactive web features (such as maps) or even creating your portfolio.

By the end of this walkthrough, you'll have a repo that, when you submit files to it, they'll immediately be served on the Web. You *technically* are already doing this with pretty much any Github repo you make, but Github Pages lets you basically publish any kind of webpage (not just things hosted in Github's template).

__Fair warning:__ Everything you commit to this repo will be accessible to the entire Web. So don't post any dummy text you wouldn't want the world to see.


### Create a new repo

In the screenshots and video clips, I'll be using an account named __danksnguyen__. Anytime you see that name, just substitute __your own Github username__.

1. Click the **+ New repository** button
2. You must give this new repo a very specific __name__:
  
        username.github.io
  
   Or in my example:

        danksnguyen.github.io

3. Go ahead and __Initialize this repository with a README__ and leave it set as __Public__.
4. Click the __Create repository__ button.


##### Video

Watch me create a Github Pages repo:

<video id="github-pages-create-repo-001" class="video-js vjs-default-skin" controls preload="auto" width="100%"> <source src="/files/videos/github/github-pages-create-repo-001.mp4" type='video/mp4' /></video>


### Edit your README.md

This step is entirely optional and just meant as a proof-of-concept, i.e. the further confirmation that a "Markdown file" is just a text file and not really **HTML** for the web browser...unless you have a site like Github.com doing some behind-the-scenes magic. We'll see what happens when that magic *doesn't* exist.

1. Click on the `README.md` file
2. Click on the little __pencil__ icon (which stands for __Edit file__)
3. Write some stuff in Markdown. Here's [a cheat sheet](http://assemble.io/docs/Cheatsheet-Markdown.html).
4. Hit the __Commit Changes__ button.


##### Video

<video id="github-pages-create-readme-002" class="video-js vjs-default-skin" controls preload="auto" width="100%"> <source src="/files/videos/github/github-pages-create-readme-002.mp4" type='video/mp4' /></video>


This `README.md` file is actually already published to the web. In fact, you can visit it __directly__ at this URL:

    http://username.github.io/README.md

And it will look like this:

![img](/files/tutorials/github/readme.md.plaintext.png)


#### Check out that new subdomain

Hey, *that's just raw text*, what gives? The difference is that under the domain of: 

<pre><strong>http://username.github.io/</strong>README.md</pre>

&ndash; the raw files (remember that Markdown is just text) are being served up. This is in _contrast to_ what lives at:

<pre><strong>https://github.com/username/username.github.io/</strong>README.md</pre>


Basically, by __naming your repo__, `username.github.io`, Github has carved out a place on the web for you at `http://username.github.io`. That's all.


### Publish some real HTML

Since your `README.md` is just plaintext, it's not served up as a real web page. For that, you'll have to write up your own HTML (yes, that's a pain).

Follow these steps:

1. Go back to your repo page on github.com
   
   e.g. `https://github.com/username/username.github.io`

2. __Create a new file__ by clicking on the `+`
3. Name this file `test.html`
4. Go to town on writing some HTML. Or you can just copy this:

     
         <!DOCTYPE html>
         <html lang="en">
           <head>
             <meta charset="UTF-8">
             <title>Document</title>
           </head>       
           <body>
              <h1> This is my test page <h1>          
              <img src="http://placekitten.com/g/300/300"
              <p>Kitty says: <strong>Meow!</strong></p>
           </body>
         </html>
     

5. Commit the changes
6. Visit the page at `username.github.io/test.html`
   
   ![img](/files/tutorials/github/test.html.png)


7. Congratulations, you are now a web developer.

##### Video

Watch me create a web page from scratch:

<video id="github-pages-test-html-003" class="video-js vjs-default-skin" controls preload="auto" width="100%"> <source src="/files/videos/github/github-pages-test-html-003.mp4" type='video/mp4' /></video>




------------


### Go crazy

To see how much publishing power you now have, let's rip off all the code from another webpage.

__Note:__ If you are using the __Safari Browser__, you will need to enable the __Develop__ menu in order to complete this step:

Go to __Safari > Preferences__ in the menu bar, then select the __Advanced__ tab. You should see a checkbox named __Show Develop menu in menu bar__. Check that box and you should be good to go.

![img](files/tutorials/github/enable-safari-develop.png)





##### Ripping Wikipedia 

1. Go to any [Wikipedia page](http://en.wikipedia.org/wiki/Main_Page) of your choice
2. __View its source__. 
   
   - In __Google Chrome__, this is hidden under the menu item: __View > Developer > View Source__
   - In __Safari__, this is usually under __Develop > Show Page Source__
   - In __Firefox__, look under __Tools > Web Developer > Page Source__

3. Select __all__ the code and __Copy__ it to your clipboard.
4. In your github.io __repo page__, i.e. 
     
      `https://github.com/username/username.github.io`

   Make a new file, name it something like `hooray.html`, and then **paste everything** you copied into the file body and **commit the changes**.

5. Now visit: `username.github.io/hooray.html`
   
   ![img](/files/tutorials/github/hooray.html.ripoff.png)


6. Congratulations, you are now a content aggregator.

##### Video

Watch me recreate a Wikipedia page:


<video id="github-pages-wiki-html-004" class="video-js vjs-default-skin" controls preload="false" width="100%"> <source src="/files/videos/github/github-pages-wiki-html-004.mp4" type='video/mp4' /></video>




-------------

### Conclusion

That's as far as we'll go right now. The important thing to know is that you can now publish basically any kind of webpage you want and have it hosted at `username.github.io`. This will be useful as you create custom web features that need to live somewhere besides your laptop's hard drive.






Additional help:

- [Github's guide to Github Pages Basics](https://help.github.com/categories/20/articles)
