//
//  AccountsPreferencesNavigationController.swift
//  Leviathan
//
//  Created by Thomas Bonk on 18.04.17.
//
//

import UIKit


fileprivate extension String {
    static let identifier = "MastodonAccountsPreferences"
}

class AccountsPreferencesNavigationController: UINavigationController {

    // MARK: - Class Methods
    
    static func present() {
        
        // Show the account preferences
        let storyboard = UIStoryboard(
            name: Bundle.main.object(forInfoDictionaryKey: "UIMainStoryboardFile") as! String,
            bundle: Bundle.main)
        let viewController = storyboard.instantiateViewController(
            withIdentifier: String.identifier)
        
        AppDelegate.shared.window?.rootViewController?.present(viewController, animated: true)
    }
}
