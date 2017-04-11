//
//  LeviathanWindowController.swift
//  Leviathan
//
//  Created by Thomas Bonk on 11.04.17.
//
//

import Cocoa
import RxCocoa


class LeviathanWindowController: NSWindowController {

    // MARK: - Action Handlers
    
    @IBAction func selectTimeline(sender: NSToolbarItem) {
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: ShowTabNotification),
                                        object: sender,
                                        userInfo: [ShowTabNotificationId: sender.tag])
        
    }
}
