//
//  AccountsPreferencesNavigationController.swift
//  Leviathan
//
//  Created by Thomas Bonk on 18.04.17.
//
//

import UIKit

class AccountsPreferencesNavigationController: UINavigationController {
    
    // MARK: - Public Constants
    
    static let Identifier = "MastodonAccountsPreferences"
    
    
    // MARK: - Class Methods
    
    static func present() {
        
        // Show the account preferences
        let storyboard = UIStoryboard(
            name: Bundle.main.object(forInfoDictionaryKey: "UIMainStoryboardFile") as! String,
            bundle: Bundle.main)
        let viewController = storyboard.instantiateViewController(
            withIdentifier: AccountsPreferencesNavigationController.Identifier)
        
        AppDelegate.shared.window?.rootViewController?.present(viewController, animated: true)
    }

    
    // MARK: - UINavigationController
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
}
