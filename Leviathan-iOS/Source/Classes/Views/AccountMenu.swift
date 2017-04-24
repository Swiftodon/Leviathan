//
//  AccountMenu.swift
//  Leviathan
//
//  Created by Thomas Bonk on 24.04.17.
//
//

import UIKit
import RxCocoa
import RxSwift
import Toucan
import Popover
import DoThis

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
    fileprivate let insets = CGFloat(5)
    fileprivate let accountController = Globals.injectionContainer.resolve(AccountController.self)
    fileprivate let settings = Globals.injectionContainer.resolve(Settings.self)
    fileprivate var entries: [(image: UIImage, title: String, account: Account?)] {
        var acc:[(UIImage,String,Account?)] = (self.accountController?.accounts.map { account in
            
            let imageSize = CGSize(width: 24, height: 24)
            var image: UIImage!
            
            if let avatarData = account.avatarData {
                
                image = Toucan(image: UIImage(data: avatarData)!)
                            .resize(imageSize)
                            .maskWithEllipse()
                            .image
            }
            else {
                
                image = Toucan(image: Asset.icAccount.image)
                            .resize(imageSize)
                            .image
            }
            
            return (image: image, title: "@\(account.username)@\(account.server)", account: account)
        })!
        
        acc.append((image: Asset.icAccount.image, title: "Manage Accounts", account: nil))
        
        return acc
    }
    fileprivate let disposeBag = DisposeBag()
    fileprivate var tableView: UITableView!

    
    fileprivate var tableViewHeight: CGFloat {
        
        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
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
        self.tableView.contentInset = UIEdgeInsets(top: insets, left: insets, bottom: insets, right: insets)
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: String.accountCell)
        
        Observable.just(self.entries)
            .bind(to: tableView.rx.items(cellIdentifier: String.accountCell)) {
                (row, element, cell) in
                
                cell.textLabel?.text = element.title
                cell.imageView?.image = element.image
            }
            .disposed(by: disposeBag)
        
        tableView.rx.itemSelected
            .asObservable()
            .subscribe(self.itemSelected)
            .disposed(by: disposeBag)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    
    // MARK: - Public Methods
    
    func show(fromView view: UIView) {
        
        Do
            .this { this in
                
                super.show(self.tableView, fromView: view)
                this.done()
            }
            .finally { this in
                
                var frame = self.frame
                
                frame.size.width = frame.size.width + self.insets
                frame.size.height = frame.size.height + self.insets
                
                self.frame = frame
            }
    }
    
    
    // MARK: - Private Methods
    
    func itemSelected(_ event: Event<IndexPath>) {
        
        Do
            .this { this in
                
                this.done(result: self.entries[event.element!.row].account)
            }
            .orThis { this in
                
                var finished = false
                
                if let account = this.previousResult as! Account? {
                    
                    self.settings?.activeAccount = account
                    self.dismiss()
                    finished = true
                }
                
                this.done(finished: finished)
            }
            .orThis { this in
                
                // TODO: open account preferences
                self.dismiss()
                this.done()
            }
    }
}
