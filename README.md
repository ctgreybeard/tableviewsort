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

### Branch: TableView

We add the subClass for the TableView, TableView itself, the ArrayController, and the Add button which adds entries into the names array. Basic Cocoa Bindings is set up. The Table View shows names and numbers as they are added.

* Add new Class file NameListView. We don't do anything inside here now, that happens later.

* Add the TableView in Interface Builder. Two columns called Name and Num. The size or positioning doesn't matter much. Leave room for the Add button.

* Add the Array Controller. Just drag one from the Object Library. I dropped this one right below the Font Manager.

* Make the initial Bindings using Interface Builder. Start by selecting the MainMenu.xib file in the Project Navigator.

    * Select the Table View. It is right under the Clip View.

    * Select the Bindings Inspector in the Utilities pane.

    * Under Table Content dropdown the Content item.

    * Select Bind to: Array Controller. It should be already set as the default. `arrangedObjects` is the correct key.

    * Continue down that tree. The next layer is the columns. Fow the two columns change the title to `Name` and `Num` respectively.

    * Two layers down in each column you will find `Table View Cell` (not to be confused with its parent`Table Cell View`!)

    * For the two columns Value binding use Bind to Table Cell View with the key of `objectValue.name` and `objectValue.num` respectively. You will know you are in the right place because `objectValue` is pre-filled into the Model Key Path. Ignore the exclamation in the grey circle.

    * Now select the Array Controller you added before.

    * Under Controller Content dropdown Content Array

        * Here we change the "Bind to" to App Delegate, make sure the check box is checked.

        * The Model Key Path defaults to `self`, erase that and if you type an `o` in that field it should show you `ourData` ... choose that so it appears as Model Key Path.

* Now drag a button to the window, name it `Add`, and using the Interface Builder ctrl-drag to the Application Delegate to create an Action of addOne. Add the code to call `addName()`

If you have loaded the TableView branch this has all been done.

Run the app and click the Add button. Names should appear as you click. They aren't sorted at all, just added in the same order that they appear in the array.

As an aside and slightly related to the sorting notice the two calls inside the `addName()` method of `willChange` and `didChange`. The reason for these is that NSArray is not observable and we need to provide our own notice to the array controller. If the datasource for the Array Controller were something else this might not be required. By providing the notification to the Array Controller it will handle notifying the Table View.

At this point we have a minimally functional Table View. Go take a break ... 

### Branch: Sort1

In this step we do two things:

1. We connect the Array Controller to the Table View for the `sortDescriptors` binding. This tells the Array Controller to ask the Table View for the sort descriptors. It's important that the Array Controller does that because it will let us do the "column header click" trick later.

2. Then we tell the Table View what the starting sort descriptors are. 

The order doesn't really matter because in this sequence the Array Controller asks the Table View for the descriptors in the first step and gets none back. But in the second step the Table View notifies the Array Controller that the dscriptors have changed which makes the AC ask the TV for the new descriptors. (I hope you don't mind the abbreviations ...)

If we reverse the order then the TV gets the descriptors first and has them when the AC asks for them in the second step.

In the end it really doesn't matter.

Here are the steps:

* Open the Identity Inspector for the View and change the Class name to `NameListView`. This is not strictly necessary but it allows us to put the code into awakeFromNib which is a good place to put it.

* Remove the drawRect from the NameListView class. We don't need it.

* Create outlets for the Array Controller (I called mine `ac`) and Table View (`tv`)

* Add the definition for default SortDescriptors too. They could be inline in the code but this is more explicit.

* Add the binding code and the sort descriptor setting as shown in the example.

In fact this is completely functional right now. If your app wants to change the sort all it has to do is send the new descriptor to the Table View. But we want to be able to click the column headers. That's next.

But, you may ask, why don't we do this through Interface Builder bindings. I know I asked that.

Setting the Sort Descriptors isn't a binding so that's why that doesn't appear under the Bindings Inspector. But what about the binding of the Array Controller to the Table View? Let's take a look ...

Select the Array Controller in Interface Builder and show the Bindings Inspector. Under `Controller Content Parameters` you will find `Sort Descriptors` ... cool. But the choices don't match our needs. Only the App Delegate is useful that I can tell and we could use that but we would merely be a middleman. The AC would ask the App Delegate and the App Delegate would have to ask the Table View. Not terribly useful. By doing the binding as we do it cuts out the middleman.

The last step is Sort2.

### Branch: Sort2

This one is easy.

* In Interface Builder select, in turn, the two columns: Name and Num. They are one level below the Table View.

* Use Attributes Inspector under Table Column and enter `name` and `num` as the Sort Key for the appropriate column.

That's it.

Run the app, add a few names, and the names are sorted as they are added and you can click on the column headers to sort either column ascending or descending.

All of this was pretty simple and straight forward. And the only code we needed to add was the binding and maybe the initial Sort Descriptors. Everything elas was done right in Interface Builder.

## Footnotes
1. https://developer.apple.com/library/mac/technotes/tn2203/_index.html in particular