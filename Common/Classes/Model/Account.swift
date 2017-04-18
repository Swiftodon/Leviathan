//
//  Account.swift
//  Leviathan
//
//  Created by Thomas Bonk on 15.04.17.
//
//

import Foundation

class Account: Equatable {
    
    // MARK: - Public Properties
    
    public var server  : String = ""
    public var username: String = ""
    public var password: String {
        set {
            
        }
        get {
            return ""
        }
    }
    
    public var clientId    : String = ""
    public var clientSecret: String = ""
    public var accessToken : String {
        set {
            
        }
        get {
            return ""
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
}
