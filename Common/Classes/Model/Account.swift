//
//  Account.swift
//  Leviathan
//
//  Created by Thomas Bonk on 15.04.17.
//
//

import Foundation

class Account {
    
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
    public var accessToken : String = ""
    
    public var baseUrl: URL {
        return URL(string: "https://\(self.server)")!
    }
}
