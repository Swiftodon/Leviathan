//
//  AccountsPreferencesViewController.swift
//  Leviathan
//
//  Created by Bonk, Thomas on 18.04.17.
//
//

import UIKit
import RxSwift
import RxCocoa


class AccountsPreferencesViewController: UITableViewController {

    // MARK: - Private Properties
    
    private var _accountController = Globals.injectionContainer.resolve(AccountController.self)
    
    
    // MARK: - UIViewController 
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let items = Observable.just(self._accountController?.accounts)

        items
            .bind(to: tableView.rx.items(cellIdentifier: "Cell", cellType: UITableViewCell.self)) {
                (row, element, cell) in
                
                cell.textLabel.text = element.username
                cell.detailTextLabel.text = element.server
            }
            .disposed(by: DisposeBag)
    }

    
    // MARK: - Action Handlers
    
    @IBAction func done(sender: UIBarButtonItem) {
        
        self.navigationController?.dismiss(animated: true)
    }
}
