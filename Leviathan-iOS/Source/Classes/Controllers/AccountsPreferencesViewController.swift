//
//  AccountsPreferencesViewController.swift
//  Leviathan
//
//  Created by Bonk, Thomas on 18.04.17.
//
//

import UIKit
import RxCocoa
import RxSwift
import Toucan

fileprivate extension String {
    static let accountCell = "MastodonAccountCell"
}


class AccountsPreferencesViewController: UIViewController {
    
    // MARK: - Private Properties
    
    @IBOutlet weak var tableView : UITableView!
    
    private var accountController: AccountController! = Globals.injectionContainer.resolve(AccountController.self)
    private let settings = Globals.injectionContainer.resolve(Settings.self)
    private let disposeBag = DisposeBag()
    
    // MARK: - UIViewController 
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard let accountController = accountController else {
            
            preconditionFailure()
        }
        
        self.accountController.loadData()
        
        Observable.just(accountController.accounts)
            .bind(to: tableView.rx.items(cellIdentifier: String.accountCell)) {
                (row, element, cell) in
                
                cell.textLabel?.text = "@\(element.username)"
                cell.detailTextLabel?.text = String(describing: element.baseUrl)
                
                if let avatarData = element.avatarData {
                    
                    cell.imageView?.image = Toucan(image: UIImage(data: avatarData)!)
                                                .maskWithEllipse()
                                                .image
                    
                }
                else {
                    
                    cell.imageView?.image = Asset.icAccount.image
                }
            }
            .disposed(by: disposeBag)
    }

    
    // MARK: - Action Handlers
    
    @IBAction func done(sender: UIBarButtonItem) {
        
        if settings?.activeAccount == nil && accountController.accounts.count > 0 {
            
            settings?.activeAccount = accountController.accounts.first
        }
        
        self.navigationController?.dismiss(animated: true)
    }
}
