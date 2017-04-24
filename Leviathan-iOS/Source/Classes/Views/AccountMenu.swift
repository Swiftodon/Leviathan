//
//  AccountMenu.swift
//  Leviathan
//
//  Created by Thomas Bonk on 24.04.17.
//
//

import UIKit
import Popover


class AccountMenu: Popover {
    
    // MARK - Private Properties
    
    fileprivate let options = [
                        .arrowSize(CGSize(width: 8, height: 8)),
                        .blackOverlayColor(UIColor(white: 0.0, alpha: 0.6)),
                        .sideEdge(10)
                    ] as [PopoverOption]
    fileprivate var tableView: UITableView!
    

    // MARK: - Initialization
    
    init(frame: CGRect) {
        super.init(options: options)
        
        self.tableView = UITableView(frame: frame, style: .plain)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    
    // MARK: - Public Methods
    
    func show(fromView view: UIView) {
        
        super.show(self.tableView, fromView: view)
    }
}
