//
//  TimelineViewController.swift
//  Leviathan
//
//  Created by Thomas Bonk on 13.04.17.
//
//

import Cocoa

@IBDesignable
class TimelineViewController: NSViewController {
    
    // MARK: - Private Properties
    
    @IBOutlet private var _tableView: NSTableView!
    

    // MARK: - Public Properties
    
    @IBInspectable var timelineId: String = ""
}
