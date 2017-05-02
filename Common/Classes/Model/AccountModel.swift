//
//  AccountModel.swift
//  Leviathan
//
//  Created by Thomas Bonk on 18.04.17.
//
//

import Foundation
import Gloss


class AccountModel {
    
    // MARK: - Private Properties
    
    private let fileLock = NSLock() //DispatchQueue(label: "AccountModel_IO_Lock")
    
    
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
    
    @discardableResult func loadData() -> AccountModel {
        
        fileLock.lock()
        defer {
            fileLock.unlock()
        }
        
        if let arr = NSArray(contentsOf: self.fileUrl) {
            
            let jsonArray = arr as! [JSON]
        
            self.accounts = [Account].from(jsonArray: jsonArray)!
        }
        
        return self
    }
    
    @discardableResult func saveData() -> AccountModel {
        
        fileLock.lock()
        defer {
            fileLock.unlock()
        }
            
        let jsonArray = self.accounts.toJSONArray()
        let arr = jsonArray! as NSArray
        
        arr.write(to: self.fileUrl, atomically: true)
        
        return self
    }
    
    
    // MARK: - Operations
    
    func create(server: String, email: String) -> Account {
        
        let account = Account()
        
        account.server = server
        account.email = email
        
        self.accounts.append(account)
        
        return account
    }
    
    func delete(_ account: Account) {
        
        if let index = self.accounts.index(where: { $0 == account } ) {
            
            self.delete(at: index)
        }
    }
    
    func delete(at index: Int) {
        
        self.accounts.remove(at: index)
    }
    
    func find(_ server: String, _ username: String) -> Account? {
        
        let foundAccounts = self.accounts.filter { account in
            (account.server.caseInsensitiveCompare(server) == .orderedSame) &&
            (account.username.caseInsensitiveCompare(username) == .orderedSame)
        }
        
        return foundAccounts.first
    }
}
