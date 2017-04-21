//
//  AccountController.swift
//  Leviathan
//
//  Created by Thomas Bonk on 18.04.17.
//
//

import Foundation


class AccountController {
    
    // MARK: - Public Properties
    
    public private(set) var accounts: [Account] = []
    public              let fileUrl: URL = {
        Globals.applicationDocumentsDirectory.appendingPathComponent("Accounts.json")
    }()
    
    
    // MARK: - Initialization
    
    init() {
        
        self.loadData()
    }
    
    deinit {
        
        self.saveData()
    }
    
    
    // MARK: - Load and save data
    
    func loadData() {
        
        let arr = NSArray(contentsOf: self.fileUrl)
        
        self.accounts = arr as? [Account] ?? []
    }
    
    func saveData() {
        
        let arr = self.accounts as NSArray
        
        arr.write(to: self.fileUrl, atomically: true)
    }
    
    
    // MARK: - Operations
    
    func createAccount(server: String, username: String) -> Account {
        
        let account = Account()
        
        account.server = server
        account.username = username
        
        self.accounts.append(account)
        
        return account
    }
    
    func deleteAccount(_ account: Account) {
        
        if let index = self.accounts.index(where: { $0 == account } ) {
            
            self.accounts.remove(at: index)
        }
    }
}
