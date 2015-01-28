//
//  AppDelegate.swift
//  TableViewSort
//
//  Created by William Waggoner on 1/28/15.
//  Copyright (c) 2015 William C Waggoner. All rights reserved.
//

import Cocoa

let logger = XCGLogger()

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    @IBOutlet weak var window: NSWindow!

    var names: [String]!

    var ourData = NSMutableArray()

    func loadFile(fileName file: String) -> [String]? {
        var into: [String]?
        let namefileURL = NSBundle.mainBundle().URLForResource(file, withExtension: "txt")
        if let goodURL = namefileURL {
            logger.info("Loading \(file) from \(goodURL)")
            let nameFile = NSString(contentsOfURL: goodURL, encoding: NSUTF8StringEncoding, error: nil)
            if let names = nameFile {
                into = names.componentsSeparatedByString("\n") as? [String]
            }
        } else {
            logger.error("Unable to load \(file)")
            into = ["NoName1", "NoName2", "NoName3"]
        }
        return into
    }

    let namename = "name"
    let numname = "num"

    func addName() {
        // Pick a name
        let whichName = random() % names.count
        let whatNum = random() % 100
        var newOne = NSMutableDictionary()
        newOne["name"] = names[whichName]
        newOne["num"] = whatNum
        names.removeAtIndex(whichName)   // Don't reuse names ...
        willChange(.Insertion, valuesAtIndexes: NSIndexSet(index: whichName), forKey: "ourData")
        let whichOne = ourData.count
        ourData.insertObject(newOne, atIndex: whichOne)
        didChange(.Insertion, valuesAtIndexes: NSIndexSet(index: whichName), forKey: "ourData")
        logger.info("Added \(newOne[namename]!):\(newOne[numname]!) at \(whichOne)")
    }

    func loadNames() {
        if names == nil {
            names = loadFile(fileName: "givennames")
            if names == nil {names = [String](count: 1000, repeatedValue: "James")} // Make it up if the file isn't found
        }
    }
    
    func applicationDidFinishLaunching(aNotification: NSNotification) {
        logger.info("Here we go!")
        loadNames()
    }

    func applicationWillTerminate(aNotification: NSNotification) {
        logger.info("Bye bye!")
    }

    func applicationShouldTerminateAfterLastWindowClosed(sender: NSApplication) -> Bool {
        return true
    }

}

