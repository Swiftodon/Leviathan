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

    
    // MARK: - UINavigationController
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
}
