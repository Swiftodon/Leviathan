//
//  Account.swift
//  Leviathan
//
//  Created by Thomas Bonk on 15.04.17.
//
//

import Foundation
import Locksmith

class Account: Equatable {
    
    // MARK: - Public Properties
    
    public var server  : String = ""
    public var username: String = ""
    public var password: String {
        set {
            
            self.saveToKeychain(password: newValue)
        }
        get {
            
            return self.loadValueFromKeychain(forKey: "password")
        }
    }
    
    public var clientId    : String {
        set {
            
            self.saveToKeychain(clientId: newValue)
        }
        get {
            
            return self.loadValueFromKeychain(forKey: "clientId")
        }
    }
    
    public var clientSecret: String {
        set {
            
            self.saveToKeychain(clientSecret: newValue)
        }
        get {
            
            return self.loadValueFromKeychain(forKey: "clientSecret")
        }
    }
    
    public var accessToken : String {
        set {
            
            self.saveToKeychain(accessToken: newValue)
        }
        get {
            
            return self.loadValueFromKeychain(forKey: "accessToken")
        }
    }
    
    public private(set) var avatar: Data? = nil
    
    public var baseUrl: URL {
        return URL(string: "https://\(self.server)")!
    }
    
    // MARK: - Equatable
    
    static func ==(lhs: Account, rhs: Account) -> Bool {
        
        let equals = lhs.server == rhs.server && lhs.username == rhs.username
        
        return equals
    }
    
    
    // MARK: - Private Methods
    
    fileprivate func saveToKeychain(password: String? = nil,
                                    clientId: String? = nil,
                                    clientSecret: String? = nil,
                                    accessToken: String? = nil) {
        
        let data = [
            "password": password ?? self.password,
            "clientId": clientId ?? self.clientId,
            "clientSecret": clientSecret ?? self.clientSecret,
            "accessToken": accessToken ?? self.accessToken
        ]
        
        try! Locksmith.updateData(data: data, forUserAccount: self.username, inService: self.server)
    }
    
    fileprivate func loadValueFromKeychain(forKey key: String) -> String {
        
        let data = Locksmith.loadDataForUserAccount(userAccount: self.username, inService: self.server)
        let value = data?[key] ?? ""
        
        return value as! String
    }
}
