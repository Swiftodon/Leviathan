//
//  LeviathanTimelinesTabViewController.swift
//  Leviathan
//
//  Created by Thomas Bonk on 11.04.17.
//
//

import Cocoa

class LeviathanTimelinesTabViewController: NSTabViewController {

    // MARK: - NSViewController, NSTabViewController
    
    override func viewWillAppear() {
        
        _ = NotificationCenter.default.rx
            .notification(NSNotification.Name(ShowTabNotification))
            .takeUntil(rx.methodInvoked(#selector(self.viewWillDisappear)))
            .subscribe(onNext: self.showTab)
    }
    
    
    // MARK: - Switch Tabs
    
    func showTab(notification: Notification) {
        
        let tag = notification.userInfo?[ShowTabNotificationId] as! Int
        let identifier = String(describing: tag)
        
        self.selectedTabViewItemIndex = self.tabViewItems
            .index(of: self.tabViewItems
                .filter({($0.identifier as! String) == identifier})
                    .first!)!
    }
    
}
