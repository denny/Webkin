# Webkin

##### A command-line tool for converting web-based fiction into ebooks

I started writing Webkin so that I could download stories from the web and read
them on my Kindle when I'm not online. I originally intended to make it output
.mobi or .epub files, but it turned out that plain text files look nice enough
on the Kindle (at least on my Kindle Voyage), so that's what it outputs for
now. I may add other output formats at some point in the future.

Given that online fiction is spread around a LOT of websites, Webkin has a
plugin system, hopefully allowing support to be added for any website. I will
be adding more plugins myself, but I hope other people will contribute plugins
for their favourite websites too.


### Writing Webkin Plugins

Webkin plugins are very simple; they're just a single file Ruby module, which
extends the main Story class with the following two methods:

`self.url_regex`  
  This returns a regex which will match a story page on the website. Webkin
  uses this to find the right plugin for a URL which has been passed to it.

`fetch`  
  This is the main method in a Webkin plugin; it downloads the story page
  (or pages, if your site has multi-page stories) and strips off any header
  and footer HTML, leaving just the story section in the `html` attribute.
  It should also populate the `title` and (if possible) `author` attributes.

The plugin's filename and Module name must match, with the Module name
capitalised.

If you've downloaded Webkin from Github then you should have at least one
example plugin to look at.


### Please support your favourite websites

Webkin is free, but if you'd like to show your appreciation for it then please
make a donation towards the running costs of your favourite free fiction site,
if they offer ways to do that and you can afford to do so.


Circle CI status: [![CircleCI](https://circleci.com/gh/denny/Webkin.svg?style=svg)](https://circleci.com/gh/denny/Webkin)
