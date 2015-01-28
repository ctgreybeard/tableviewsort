//
//  NameListView.swift
//  TableViewSort
//
//  Created by William Waggoner on 1/28/15.
//  Copyright (c) 2015 William C Waggoner. All rights reserved.
//

import Cocoa

class NameListView: NSView {

    @IBOutlet weak var ac: NSArrayController!
    @IBOutlet weak var tv: NSTableView!

    let defaultSortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]

    override func awakeFromNib() {
        logger.debug("Entry")

        if let myAC = ac {
            logger.info("Bind AC to tv.sortDescriptors")
            ac.bind("sortDescriptors", toObject: tv, withKeyPath: "sortDescriptors", options: nil)
        }
        
        if let myTV = tv {
            logger.info("Setting initial TV sort descriptors")
            myTV.sortDescriptors = defaultSortDescriptors
        } else {
            logger.error("tv is nil")
        }
    }

}
