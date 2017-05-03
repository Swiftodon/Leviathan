//
//  Account.swift
//  Leviathan
//
//  Created by Thomas Bonk on 15.04.17.
//
//

import Foundation
import Locksmith
import Alamofire
import Gloss
import Moya
import RxSwift
import RxMoya
import MastodonSwift

extension MastodonSwift.AccessToken: Encodable {
 
    // MARK: - Encodable
    
    public func toJSON() -> JSON? {
        return jsonify([
            "access_token" ~~> self.token
        ])
    }
}


class Account: NSObject, Decodable, Encodable {
    
    // MARK: - Private Properties
    private var disposeBag = DisposeBag()
    
    // MARK: - Public Properties
    
    public var server  : String = ""
    public var email: String = ""
    public var username: String = ""
    public var password: String {
        set {
            
            self.saveToKeychain(password: newValue)
        }
        get {
            
            return self.loadValueFromKeychain(forKey: "password") ?? ""
        }
    }
    
    public var clientId    : String {
        set {
            
            self.saveToKeychain(clientId: newValue)
        }
        get {
            
            return self.loadValueFromKeychain(forKey: "clientId") ?? ""
        }
    }
    
    public var clientSecret: String {
        set {
            
            self.saveToKeychain(clientSecret: newValue)
        }
        get {
            
            return self.loadValueFromKeychain(forKey: "clientSecret") ?? ""
        }
    }
    
    public var accessToken : AccessToken? {
        set {
            
            let json = newValue?.toJSON()
            
            self.saveToKeychain(accessToken: json)
        }
        get {
        
            if let json: JSON? = self.loadValueFromKeychain(forKey: "accessToken") {
            
                return AccessToken(json: json!)
            }
            else {
                
                return nil
            }
        }
    }
    
    public private(set) var avatarData: Data? = nil
    
    public var baseUrl: URL {
        return URL(string: "https://\(self.server)")!
    }
    
    
    // MARK: - Initialization
    
    override init() {
        super.init()
    }
    
    required init?(json: JSON) {
        
        self.server = ("server" <~~ json)!
        self.email = ("email" <~~ json)!
        self.username = ("username" <~~ json)!
        self.avatarData = "avatarData" <~~ json
    }
    
    
    // MARK: - Equatable
    
    static func ==(lhs: Account, rhs: Account) -> Bool {
        
        let equals = lhs.server == rhs.server && lhs.email == rhs.email
        
        return equals
    }
    
    
    // MARK: - Encodable
    
    func toJSON() -> JSON? {
        return jsonify([
            "server" ~~> self.server,
            "email" ~~> self.email,
            "username" ~~> self.username,
            "avatarData" ~~> self.avatarData
            ])
    }
    
    
    // MARK: - Public Methods
    
    func verifyAccount(_ completed: ((_ verified: Bool?, _ error: Swift.Error?) -> ())?) {
        
        var avatarUrl: URL? = nil
        let accessToken = self.accessToken
        let token = accessToken?.token
        let accessTokenPlugin = AccessTokenPlugin(token: token!)
        
        RxMoyaProvider<Mastodon.Account>(endpointClosure: /self.baseUrl, plugins: [accessTokenPlugin])
            .request(.verifyCredentials)
            .mapObject(type: MastodonSwift.Account.self)
            .subscribe(
                EventHandler(onNext: { account in
                    
                    self.username = account.username
                    avatarUrl = account.avatar
                }, onError: { error in
                    
                    completed?(false, error)
                }, onCompleted: {
                    
                    if let url = avatarUrl {
                        
                        Alamofire
                            .request(url)
                            .responseData { response in
                                
                                if response.error == nil {
                                
                                    self.avatarData = response.data
                                }
                                
                                completed?(true, nil)
                            }
                    }
                    else {
                        
                        completed?(true, nil)
                    }
                }))
            .disposed(by: disposeBag)
    }
    
    
    // MARK: - Private Methods
    
    fileprivate func saveToKeychain(password: String? = nil,
                                    clientId: String? = nil,
                                    clientSecret: String? = nil,
                                    accessToken: JSON? = nil) {
        
        let data = [
            "password": password ?? self.password,
            "clientId": clientId ?? self.clientId,
            "clientSecret": clientSecret ?? self.clientSecret,
            "accessToken": accessToken ?? self.accessToken?.toJSON() as Any
        ] as [String : Any]
        
        try! Locksmith.updateData(data: data, forUserAccount: self.email, inService: self.server)
    }
    
    fileprivate func loadValueFromKeychain<T>(forKey key: String) -> T? {
        
        let data = Locksmith.loadDataForUserAccount(userAccount: self.email, inService: self.server)
        let value = data?[key]
        
        guard let val = value as? T else {
            return nil
        }
        
        return val
    }
}
