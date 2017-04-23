//
//  Settings.swift
//  Leviathan
//
//  Created by Thomas Bonk on 23.04.17.
//
//

import Foundation

fileprivate extension String {
    
    static let activeAccountServer   = "activeAccountServer"
    static let activeAccountUsername = "activeAccountUsername"
}

class Settings {
    
    // MARK: - Private Properties
    
    private let defaultValues:  [String:Any] = [
        String.activeAccountServer: "",
        String.activeAccountUsername: ""
    ]
    private let userDefaults  = UserDefaults.standard
    
    
    // MARK: - Initialization
    
    init() {
        self.userDefaults.register(defaults: defaultValues)
    }
    
    
    // MARK: - Settings
    
    var activeAccount: Account? {
        get {
            
            let server = self.userDefaults.string(forKey: String.activeAccountServer)
            let username = self.userDefaults.string(forKey: String.activeAccountUsername)
            let accountController = Globals.injectionContainer.resolve(AccountController.self)
            let account = accountController?.find(server!, username!)
            
            return account
        }
        set {
            
            self.userDefaults.willChangeValue(forKey: String.activeAccountServer)
            self.userDefaults.set(newValue?.server, forKey: String.activeAccountServer)
            self.userDefaults.didChangeValue(forKey: String.activeAccountServer)
            
            self.userDefaults.willChangeValue(forKey: String.activeAccountUsername)
            self.userDefaults.set(newValue?.username, forKey: String.activeAccountUsername)
            self.userDefaults.didChangeValue(forKey: String.activeAccountUsername)
            
            self.userDefaults.synchronize()
        }
    }

}
