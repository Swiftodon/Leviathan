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

fileprivate extension String {
    static let accountCell = "MastodonAccountCell"
}


class AccountsPreferencesViewController: UIViewController {
    
    // MARK: - Private Properties
    
    @IBOutlet weak var tableView : UITableView!
    private var accountController: AccountController! = nil
    private let disposeBag = DisposeBag()
    
    // MARK: - UIViewController 
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.accountController = Globals.injectionContainer.resolve(AccountController.self)
        guard let accountController = accountController else {
            
            preconditionFailure()
        }
        
        Observable.just(accountController.accounts)
            .bind(to: tableView.rx.items(cellIdentifier: String.accountCell)) {
                (row, element, cell) in
                
                cell.textLabel?.text = element.username
                cell.detailTextLabel?.text = element.server
            }
            .disposed(by: disposeBag)
    }

    
    // MARK: - Action Handlers
    
    @IBAction func done(sender: UIBarButtonItem) {
        self.navigationController?.dismiss(animated: true)
    }
}
