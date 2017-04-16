//
//  WindowController.swift
//  Leviathan
//
//  Created by Thomas Bonk on 11.04.17.
//
//

import Cocoa
import RxCocoa


class WindowController: NSWindowController {

    // MARK: - Action Handlers
    
    @IBAction func selectTimeline(sender: NSToolbarItem) {
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: Notifications.ShowTab.rawValue),
                                        object: sender,
                                        userInfo: [Notifications.TabId: sender.tag])
        
    }
}
