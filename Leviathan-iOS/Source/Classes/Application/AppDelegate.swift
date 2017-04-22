//
//  AppDelegate.swift
//  Leviathan-iOS
//
//  Created by Thomas Bonk on 11.04.17.
//
//

import UIKit
import DoThis

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    // MARK: - Public Properties
    
    var window: UIWindow?


    // MARK: - UIApplicationDelegate
    
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        DispatchQueue.main.async {
            
            self.checkAccountSettings()
        }
        
        return true
    }
    
    
    // MARK: - Show account settings
    
    private func checkAccountSettings() {
        
        Do
            .this(do: self.checkIfApplicationIsReady)
            .orThis(do: self.selectDefaultAccount)
            .orThis(do: self.showAccountSettings)
    }
    
    fileprivate func checkIfApplicationIsReady(_ this: DoThis) {
        
        this.done()
    }
    
    fileprivate func selectDefaultAccount(_ this: DoThis) {
        
        let accountController = Globals.injectionContainer.resolve(AccountController.self)
        
        guard (accountController?.accounts.count)! > 0 else {
            
            this.done()
            return
        }
        
        this.done(finished: true)
    }
    
    fileprivate func showAccountSettings(_ this: DoThis) {
        
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
        
        this.done(finished: true)
    }
}
