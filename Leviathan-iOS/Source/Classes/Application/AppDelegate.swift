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
    let di = (
        settings: Globals.injectionContainer.resolve(Settings.self)!,
        accountController: Globals.injectionContainer.resolve(AccountController.self)!
    )

    // MARK: - UIApplicationDelegate
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        return true
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        if let firstAccount = di.accountController.accounts.first {
            if di.settings.activeAccount == nil {
                di.settings.activeAccount = firstAccount
            }
        } else {
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
