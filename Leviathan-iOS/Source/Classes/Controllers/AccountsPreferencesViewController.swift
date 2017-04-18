//
//  AccountsPreferencesViewController.swift
//  Leviathan
//
//  Created by Bonk, Thomas on 18.04.17.
//
//

import UIKit

class AccountsPreferencesViewController: UITableViewController {

    // MARK: - Private Properties
    
    private var _accountController = Globals.injectionContainer.resolve(AccountController.self)
    
    
    // MARK: - UIViewController 
    
    override func viewDidLoad() {
        
        //self.navigationController?.supportedInterfaceOrientations = .portrait
    }

    
    // MARK: - Action Handlers
    
    @IBAction func done(sender: UIBarButtonItem) {
        
        self.navigationController?.dismiss(animated: true)
    }
}
