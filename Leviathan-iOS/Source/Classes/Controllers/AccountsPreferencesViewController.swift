//
//  AccountsPreferencesViewController.swift
//  Leviathan
//
//  Created by Bonk, Thomas on 18.04.17.
//
//

import UIKit
import Toucan


class AccountsPreferencesViewController
    : UIViewController
    , UITableViewDelegate
    , UINavigationControllerDelegate {
    
    // MARK: - Private Properties
    
    @IBOutlet private weak var tableView : UITableView!
    @IBOutlet private var dataSource: AccountsPreferencesViewDataSource!
    
    
    private let settings = Globals.injectionContainer.resolve(Settings.self)
    private let defaultImage = Asset.icAccount.image
    private let imageSize = CGSize(width: 24, height: 24)
    
    
    // MARK: - UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.delegate = self
    }
    
    
    // MARK: - UINavigationControllerDelegate
    
    func navigationControllerSupportedInterfaceOrientations(_ navigationController: UINavigationController) -> UIInterfaceOrientationMask {
        
        return .portrait
    }
    
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        
        self.tableView.reloadData()
    }
    
    
    // MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, willBeginEditingRowAt indexPath: IndexPath) {
        
        self.tableView.beginUpdates()
    }
    
    func tableView(_ tableView: UITableView, didEndEditingRowAt indexPath: IndexPath?) {
        
        self.tableView.endUpdates()
    }

    
    // MARK: - Action Handlers
    
    @IBAction fileprivate func done(sender: UIBarButtonItem) {
        
        let firstAccount = self.dataSource.model.accounts.first
        
        if settings?.activeAccount == nil {
            
            self.settings?.activeAccount = firstAccount
        }
        else if firstAccount == nil {
            self.settings?.activeAccount = nil
        }
        
        self.navigationController?.dismiss(animated: true)
    }
}
