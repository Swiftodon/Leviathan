//
//  Settings.swift
//  Leviathan
//
//  Created by Thomas Bonk on 23.04.17.
//
//

import Foundation
import RxSwift

fileprivate extension String {
    static let activeAccount = "activeAccount"
    static let activeAccountServer = "activeAccountServer"
    static let activeAccountUsername = "activeAccountUsername"
}

@objc class Settings: NSObject {
    
    // MARK: - Private Properties
    private let defaultValues: [String: Any] = [
        String.activeAccountServer: "",
        String.activeAccountUsername: ""
    ]
    private let userDefaults  = UserDefaults.standard
    public let accountSubject = PublishSubject<Account>()
    
    // MARK: - Initialization
    override init() {
        super.init()
        userDefaults.register(defaults: defaultValues)
    }
    
    
    // MARK: - Settings
    var activeAccount: Account? {
        get {
            guard let server = userDefaults.string(forKey: String.activeAccountServer) else {
                return nil
            }
            guard let username = userDefaults.string(forKey: String.activeAccountUsername) else {
                return nil
            }
            guard let accountController = Globals.injectionContainer.resolve(AccountController.self) else {
                return nil
            }
            return accountController.find(server, username)
        }
        set {
            guard let newValue = newValue else {
                // TODO: Remove account if set to `nil` ???
                return
            }
            userDefaults.set(newValue.server, forKey: String.activeAccountServer)
            userDefaults.set(newValue.username, forKey: String.activeAccountUsername)
            userDefaults.synchronize()
            accountSubject.onNext(newValue)
        }
    }
}
