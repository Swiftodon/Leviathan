//
//  LeviathanTimelinesTabViewController.swift
//  Leviathan
//
//  Created by Thomas Bonk on 11.04.17.
//
//

import Foundation
import Cocoa

class TimelinesTabViewController: NSTabViewController {

    // MARK: - NSViewController, NSTabViewController
    
    override func viewWillAppear() {
        
        _ = NotificationCenter.default.rx
            .notification(NSNotification.Name(Notifications.ShowTab.rawValue))
            .takeUntil(rx.methodInvoked(#selector(self.viewWillDisappear)))
            .subscribe(onNext: self.showTab)
    }
    
    
    // MARK: - Switch Tabs
    
    func showTab(_ notification: Notification) -> Void {
        
        let tag = notification.userInfo?[Notifications.TabId] as! Int
        let identifier = String(describing: tag)
        
        self.selectedTabViewItemIndex = self.tabViewItems
            .index(of: self.tabViewItems
                .filter({($0.identifier as! String) == identifier})
                    .first!)!
    }
    
}
