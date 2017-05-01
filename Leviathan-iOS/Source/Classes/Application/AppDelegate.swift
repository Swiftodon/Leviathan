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
    
    // MARK: - Class Properties
    
    static let shared: AppDelegate = {
       UIApplication.shared.delegate as! AppDelegate
    }()

    // MARK: - Public Properties
    
    var window: UIWindow?
    let di = (
        settings: Globals.injectionContainer.resolve(Settings.self)!,
        accountModel: Globals.injectionContainer.resolve(AccountModel.self)!
    )

    // MARK: - UIApplicationDelegate
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        return true
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        if let firstAccount = di.accountModel.accounts.first {
            if di.settings.activeAccount == nil {
                di.settings.activeAccount = firstAccount
            }
        } else {
            AccountsPreferencesNavigationController.present()
        }
    }
}
