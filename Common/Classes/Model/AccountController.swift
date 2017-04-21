//
//  AccountController.swift
//  Leviathan
//
//  Created by Thomas Bonk on 18.04.17.
//
//

import Foundation
import Gloss


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
    
    
    // MARK: - Load and save data
    
    func loadData() {
        
        if let arr = NSArray(contentsOf: self.fileUrl) {
            
            let jsonArray = arr as! [JSON]
        
            self.accounts = [Account].from(jsonArray: jsonArray)!
        }
    }
    
    func saveData() {
        
        let jsonArray = self.accounts.toJSONArray()
        let arr = jsonArray! as NSArray
        
        arr.write(to: self.fileUrl, atomically: true)
    }
    
    
    // MARK: - Operations
    
    func createAccount(server: String, email: String) -> Account {
        
        let account = Account()
        
        account.server = server
        account.email = email
        
        self.accounts.append(account)
        
        return account
    }
    
    func deleteAccount(_ account: Account) {
        
        if let index = self.accounts.index(where: { $0 == account } ) {
            
            self.accounts.remove(at: index)
        }
    }
}
