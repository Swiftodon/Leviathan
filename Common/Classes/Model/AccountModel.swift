//
//  AccountModel.swift
//  Leviathan
//
//  Created by Thomas Bonk on 18.04.17.
//
//

import Foundation
import Gloss
import Locksmith
import Moya
import RxSwift
import RxMoya
import MastodonSwift


class AccountModel {
    
    // MARK: - Private Properties
    
    private let fileLock = NSLock()
    
    
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
    
    func addIfNotExisting(_ account: Account) {
        
        guard self.find(email: account.email, server: account.server) == nil else {
            return
        }
        
        self.accounts.append(account)
    }
    
    func delete(_ account: Account) {
        
        if let index = self.accounts.index(where: { $0 == account } ) {
            
            self.delete(at: index)
        }
    }
    
    func delete(at index: Int) {
        
        let account = self.accounts[index]
        
        try! Locksmith.deleteDataForUserAccount(userAccount: account.email, inService: account.server)
        self.accounts.remove(at: index)
    }
    
    func find(email: String, server: String) -> Account? {
        
        return self.filter { account in
                (account.server.caseInsensitiveCompare(server) == .orderedSame) &&
                (account.email.caseInsensitiveCompare(email) == .orderedSame)
            }
            .first
    }
    
    func find(username: String, server: String) -> Account? {
        
        return self.filter { account in
                (account.server.caseInsensitiveCompare(server) == .orderedSame) &&
                (account.username.caseInsensitiveCompare(username) == .orderedSame)
            }
            .first
    }
    
    func filter(_ isIncluded: (Account) -> Bool) -> [Account] {
        
        return self.accounts.filter(isIncluded)
    }
    
    func verify(account: Leviathan.Account, completed: (() -> ())?, error: ((Swift.Error) -> ())? = nil) {
        
        var avatarUrl: URL? = nil
        let accessToken = account.accessToken
        let token = accessToken?.token
        let accessTokenPlugin = AccessTokenPlugin(token: token!)
        
        RxMoyaProvider<Mastodon.Account>(endpointClosure: /account.baseUrl, plugins: [accessTokenPlugin])
            .request(.verifyCredentials)
            .mapObject(type: MastodonSwift.Account.self)
            .subscribe(
                EventHandler(onNext: { acc in
                    
                    account.username = acc.username
                    avatarUrl = acc.avatar
                },
                onError: { err in
                    
                    error?(err)
                },
                onCompleted: {
                    
                    completed?()
                    /* TODO
                    if let url = avatarUrl {
                        
                    }
                    else {
                        
                        completed?()
                    }*/
                }))
            //.disposed(by: disposeBag)
    }
}
