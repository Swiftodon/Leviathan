//
//  AccountModel.swift
//  Leviathan
//
//  Created by Thomas Bonk on 02.11.22.
//  Copyright 2022 The Swiftodon Team
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//

import Combine
import MastodonSwift
import Foundation
import Valet

fileprivate extension String {
    static let Accounts = "\(String.ApplicationBundleId).ACCOUNTS"
}

class AccountModel: ObservableObject {
    
    // MARK: - Public Static Properties
    
    public static var shared: AccountModel = { AccountModel() }()
    
    
    // MARK: - Public Properties
    
    @Published
    public private(set) var accounts: [Account] = [] {
        didSet { saveAccounts() }
    }
    
    @Published
    public var currentAccount: Account? {
        didSet {
            guard let currentAccount else {
                auth = nil
                return
            }
            
            Task {
                guard currentAccount.isReadyToConnect else {
                    return
                }
                
                guard let url = URL(string: currentAccount.serverUrl) else {
                    return
                }
                
                if let accessToken =  currentAccount.accessToken {
                    let client = MastodonClient(baseURL: url)
                    auth = client.getAuthenticated(token: accessToken.token)
                } else {
                    do {
                        try await currentAccount.connect()
                    } catch {
                        ToastView.Toast(type: .error, message: "You can't be authenticate!", error: error).show()
                    }
                }
            }
        }
    }
    public private(set) var auth: MastodonClientAuthenticated?
    
    
    // MARK: - Private Properties
    
    private var valet: Valet
    private var cancellables: [Account:AnyCancellable] = [:]
    
    
    // MARK: - Initialization
    
    private init() {
        valet = Valet.iCloudValet(with: Identifier(nonEmpty: .ApplicationBundleId)!, accessibility: .whenUnlocked)
        
        guard let data = try? valet.object(forKey: .Accounts) else {
            return
        }
        
        guard let accounts = try? JSONDecoder().decode([Account].self, from: data) else {
            return
        }
        
        self.accounts = accounts
        self.accounts.forEach(subscribe(toChangesOf:))
    }
    
    
    // MARK: - Manage Accounts
    
    public func add(accountAt instanceURL: URL) {
//        accounts.append(account)
//        subscribe(toChangesOf: account)
        Task {
            do {
                let scopes = ["read", "write"]
                let client = MastodonClient(baseURL: instanceURL)
                let app = try await client.createApp(named: "Leviathan", redirectUri: "leviathan://oauth-callback", scopes: scopes, website: URL(string: "https://github.com/Swiftodon/Leviathan")!)
                let authToken = try await client.authentiate(app: app, scope: scopes)
                
                print("token", authToken)
                let account = Account(accessToken: AccessToken(credential: authToken))
//                try await account.connect()
                
                DispatchQueue.main.async {
                    account.serverUrl = instanceURL.absoluteString
                    
                    self.accounts.append(account)
                    self.subscribe(toChangesOf: account)
                    
                    self.currentAccount = account
                }
            } catch {
                preconditionFailure()
            }
        }
        
    }
    
    public func remove(account: Account) {
        if let index = accounts.firstIndex(where: { account == $0 }) {
            unsubscribe(fromChangesOf: account)
            accounts.remove(at: index)
        }
    }
    
    
    // Mark: - Private Methods
    
    private func subscribe(toChangesOf account: Account) {
        let cancellable = account.objectWillChange.sink { _ in
            update  {
                self.saveAccounts()
            }
        }
        
        cancellables[account] = cancellable
    }
    
    private func unsubscribe(fromChangesOf account: Account) {
        cancellables[account]?.cancel()
        cancellables.removeValue(forKey: account)
    }
    
    private func saveAccounts() {
        DispatchQueue.global(qos: .background).async {
            if let data = try? JSONEncoder().encode(self.accounts) {
                try? self.valet.setObject(data, forKey: .Accounts)
            }
        }
    }
    
    
    // MARK: - Account Class
    
    class Account: ObservableObject, Codable, Equatable, Hashable, Identifiable {
        
        // MARK: - Public Properties
        
        private(set) var id: UUID
        
        @Published
        var name: String
        @Published
        var serverUrl: String
        @Published
        var email: String
        @Published
        var password: String
        @Published
        var app: App?
        @Published
        var accessToken: AccessToken?
        @Published
        var accountInfo: MastodonSwift.Account?
        
        var isReadyToConnect: Bool {
            !serverUrl.isEmpty && (accessToken != nil || (!email.isEmpty && !password.isEmpty))
        }
        
        // MARK: - Initialization
        init(accessToken: AccessToken? = nil) {
            id = UUID()
            name = "No Name"
            serverUrl = ""
            email = ""
            password = ""
            self.accessToken = accessToken
        }
        
        // MARK: - Encodable / Decodable
        
        required init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            
            id = try container.decode(UUID.self, forKey: .id)
            name = try container.decode(String.self, forKey: .name)
            serverUrl = try container.decode(String.self, forKey: .serverUrl)
            email     = try container.decode(String.self, forKey: .email)
            password  = try container.decode(String.self, forKey: .password)
            if container.contains(.app) {
                app = try container.decode(App.self, forKey: .app)
            }
            if container.contains(.accessToken) {
                accessToken = try container.decode(AccessToken.self, forKey: .accessToken)
            }
            if container.contains(.accountInfo) {
                accountInfo = try container.decode(MastodonSwift.Account.self, forKey: .accountInfo)
            }
        }
        
        func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            
            try container.encode(id, forKey: .id)
            try container.encode(name, forKey: .name)
            try container.encode(serverUrl, forKey: .serverUrl)
            try container.encode(email, forKey: .email)
            try container.encode(password, forKey: .password)
            if let app {
                try container.encode(app, forKey: .app)
            }
            if let accessToken {
                try container.encode(accessToken, forKey: .accessToken)
            }
            if let accountInfo {
                try container.encode(accountInfo, forKey: .accountInfo)
            }
        }
        
        
        // MARK: - Equatable
        
        public static func == (lhs: Account, rhs: Account) -> Bool {
            lhs.hashValue == rhs.hashValue
        }
        
        
        // MARK: - Hashable
        
        public func hash(into hasher: inout Hasher) {
            hasher.combine(serverUrl)
        }
        
        
        // MARK: - Coding Keys
        
        private enum CodingKeys: CodingKey {
            case id
            case name
            case serverUrl
            case email
            case password
            case app
            case accessToken
            case accountInfo
        }
    }
}

extension AccountModel.Account {
    func connect() async throws {
        guard
            let url = URL(string: self.serverUrl)
        else {
            return
        }
        let client = MastodonClient(baseURL: url)
        var app: App! = self.app
        var accessToken: AccessToken! = self.accessToken
        
        if app == nil {
            app =  try await client.createApp(
                named: .ApplicationName,
                scopes: ["read", "write", "follow"],
                website: URL(string: .ApplicationURI)!)
            
            update { [app] in
                self.app = app
            }
        }
        
        if accessToken == nil {
            accessToken = try await client.getToken(
                withApp: app,
                username: self.email,
                password: self.password,
                scope: ["read", "write", "follow"])
            
            update { [accessToken] in
                self.accessToken = accessToken
            }
        }
        
        let auth = client.getAuthenticated(token: accessToken.token)
        if let acctInfo = try? await auth.verifyCredentials() {
            update { [acctInfo] in
                self.accountInfo = acctInfo
            }
        }
    }
    
    func disconnect() {
        self.accessToken = nil
    }
}
