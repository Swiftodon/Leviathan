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


class AccountsPreferencesViewController: UIViewController {
    
    // MARK: - Private Constants
    
    private let _CellIdentifier = "MastodonAccountCell"
    

    // MARK: - Private Properties
    
    @IBOutlet private var _tableView: UITableView!
    
    private var _accountController = Globals.injectionContainer.resolve(AccountController.self)
    
    
    // MARK: - UIViewController 
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        var accounts = Observable.just(self._accountController?.accounts)

        accounts
            .bind(to: self._tableView.rx.items) { // TODO: This line gives the error >Ambiguous reference to member 'items'<
                (tableView, row, element) in
                
                let cell = tableView.dequeueReusableCell(withIdentifier: AccountsPreferencesViewController._CellIdentifier)!
                
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
