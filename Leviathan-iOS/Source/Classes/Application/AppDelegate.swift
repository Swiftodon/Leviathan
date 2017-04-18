//
//  AppDelegate.swift
//  Leviathan-iOS
//
//  Created by Thomas Bonk on 11.04.17.
//
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    // MARK: - Public Properties
    
    var window: UIWindow?


    // MARK: - UIApplicationDelegate
    
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        DispatchQueue.main.async {
            
            self.showAccountSettingsIfNecessary()
        }
        
        return true
    }
    
    
    // MARK: - Show account settings
    
    private func showAccountSettingsIfNecessary() {
        
        let accountController = Globals.injectionContainer.resolve(AccountController.self)
        
        if accountController?.accounts.count == 0 {
            
            // Show the account preferences
            let storyboard = UIStoryboard(
                name: Bundle.main.object(forInfoDictionaryKey: "UIMainStoryboardFile") as! String,
                bundle: Bundle.main)
            let viewController = storyboard.instantiateViewController(
                withIdentifier: AccountsPreferencesNavigationController.Identifier)
            
            self.window?.rootViewController?.present(viewController, animated: true)
        }
    }
}
