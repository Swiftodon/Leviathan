//
//  AccountsPreferencesViewController.swift
//  Leviathan
//
//  Created by Bonk, Thomas on 18.04.17.
//
//

import UIKit

class AccountsPreferencesViewController: UIViewController {
    
    // MARK: - Public Constants
    
    static let Identifier = "MastodonAccountsPreferences"

    // MARK: - Private Properties
    
    private var _accountController = Globals.injectionContainer.resolve(AccountController.self)
    
    
    // MARK: - UIViewController 
    
    override func viewDidLoad() {
        
        //self.navigationController?.supportedInterfaceOrientations = .portrait
    }

}
