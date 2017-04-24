//
//  AccountMenu.swift
//  Leviathan
//
//  Created by Thomas Bonk on 24.04.17.
//
//

import UIKit
import Popover

fileprivate extension String {
    static let accountCell = "MastodonAccountCell"
}


class AccountMenu: Popover {
    
    // MARK - Private Properties
    
    fileprivate let options = [
                        .arrowSize(CGSize(width: 12, height: 8)),
                        .blackOverlayColor(UIColor(white: 0.0, alpha: 0.6)),
                        .sideEdge(10)
                    ] as [PopoverOption]
    fileprivate let accountController = Globals.injectionContainer.resolve(AccountController.self)
    fileprivate var tableView: UITableView!
    
    fileprivate var tableViewHeight: CGFloat {
        
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
        let cellHeight = cell.frame.size.height
        let tableHeight = CGFloat(self.accountController!.accounts.count + 1) * cellHeight
        let maxHeight = CGFloat(500)
        
        return min(tableHeight, maxHeight)
    }

    

    // MARK: - Initialization
    
    init(width: CGFloat) {
        super.init(options: options)
    
        let height = self.tableViewHeight
        let frame = CGRect(x: 0, y: 0, width: width, height: height)
        
        self.tableView = UITableView(frame: frame, style: .plain)
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: String.accountCell)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    
    // MARK: - Public Methods
    
    func show(fromView view: UIView) {
        
        super.show(self.tableView, fromView: view)
    }
}
