# TableView Sorting using NSArrayController

## Background

I suspect that when most people finally figure out how to get an NSTableView to sort by simply clicking the column headers they say "Oh! That was easy! [But hard to learn.]" and go on their way. Apparently no one then writes about it. I looked. And looked. But couldn't find that one piece that made it work the way I knew it should. It turns out that the information was there; it's just hidden in offhand comments and implications. I thought I would put this out there to help the next guy trying to figure out how to make sorting work using Cocoa Bindings, Interface Builder, NSTableView, and NSArrayController. I hope all those keywords will help someone find this item ...

## Setup

I have loaded the project to Github at https://github.com/ctgreybeard/tableviewsort from where you can download it.

The XCGLogger code is borrowed from the project of the same name by Dave Wood. You can get his project at https://github.com/DaveWoodCom/XCGLogger  It is included as source here instead of as a Framework because it was easier that way. You probably want to go get his latest code and use it rather than this static version.

### Goal

What I wanted to do was understand how to get a generic NSTableView to sort simply by clicking on the column headers. It seemed a simple and natural thing to want to do. And according to several documents I found[1] it would seem to be easy. My experience did not meet my expectation. Although I could get the table to initially sort on a column and even maintain that sort as I addd and removed objects I couldn't get the sort order to change or the sort column to change.

### Discussion

What you are looking at (if you downloaded the project from Github) is the final version.  If you run it under Xcode you will see a window pop up with two columns. It's empty of names but clicking the Add button will add names and numbers to the list. The names are randomly selected as well as the numbers. You will see the sort indicator at the had of the Name column. Clicking the header "Name" will reverse the sort, clicking again will reverse the reverse. Clicking the Num column will make the Num column sorted and, naturally, clicking it again will reverse sort it. All is exactly as you would expect. Please don't criticize the look of the application though, it isn't meant to be pretty, just functional.

You can easily step through the progress of the app by checking out the different branches of the project under Source Control.  Each branch terminates at a stage of development that builds and runs but might not do exactly what you think it should.  Each section below is headlined with the name of the branch that it refers to. Go ahead and use Switch To Branch to load up the code for that stage. You can se the exact changes from branch to branch using [TBD].

The end of each branch will build unless otherwise noted. It may not work and probably will not until we get to the end but it shouldn't crash.

To return to the end result at any time simply switch to the Master branch and all will be restored.

## Project Steps

### Branch: Startup

At this point the project was initiated as a new Cocoa Application under Xcode and this file and the XCGLogger were added.

The next branch will be Names. Switch to that to add the data source that we will be using.  I also switched this file to be README.md as that works better on Github.

### Branch: Names

Added givennames.txt. Just a list of names I collected from several such lists on the network. It's sorted and unique'd so there are no duplicates.

Added the code to load the names into an array. This really has nothing to do with sorting except that it gives us some more realistic data to look at.

The next branch is TableView.

## Footnotes
1. https://developer.apple.com/library/mac/technotes/tn2203/_index.html in particular