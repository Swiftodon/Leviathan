//
//  AccountEditViewController.swift
//  Leviathan
//
//  Created by Bonk, Thomas on 19.04.17.
//
//

import UIKit
import RxCocoa
import RxSwift
import Moya
import RxMoya
import MastodonSwift


class AccountEditViewController: UIViewController {

    // MARK: - Private Properties
    
    @IBOutlet private var serverTextField: UITextField!
    private var server = Variable<String>("")
    
    @IBOutlet private var emailTextField: UITextField!
    private var email = Variable<String>("")
    
    @IBOutlet private var passwordTextField: UITextField!
    private var password = Variable<String>("")
    
    private var url: URL!
    private var app: App!
    private var token: AccessToken!
    private let disposeBag = DisposeBag()
    private var account: Account? = nil
    private let accountController = Globals.injectionContainer.resolve(AccountController.self)

    
    // MARK: - UIViewController
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.bindControls()
    }
    
    
    // MARK: - Action Handlers
    
    @IBAction fileprivate func save(sender: UIBarButtonItem) {
        
        self.url = URL(string: "https://\(self.server.value)")
        
        RxMoyaProvider<Mastodon.Apps>(endpointClosure: /self.url,
                                      plugins: [CredentialsPlugin {
                                                    _ -> URLCredential? in
                                        
                                                    return URLCredential(user: self.email.value,
                                                                         password: self.password.value,
                                                                         persistence: .none)
                                                }])
            // TODO define constants for this
            .request(.register("Leviathan for iOS",
                               "urn:ietf:wg:oauth:2.0:oob",
                               "read write follow",
                               "https://github.com/Swiftodon"))
            .mapObject(type: App.self)
            .subscribe(
                EventHandler(onNext: self.applicationRegistration,
                             onError: self.requestErrorOccured,
                             onCompleted: self.applicationRegistrationCompleted))
            .disposed(by: disposeBag)
    }
    
    @IBAction fileprivate func cancel(sender: UIBarButtonItem) {
        
        self.navigationController?.popViewController(animated: true)
    }
    
    
    // MARK: - RxMoya Handlers
    
    fileprivate func applicationRegistration(_ app: App) {

        self.app = app
    }
    
    fileprivate func requestErrorOccured(_ error: Swift.Error) {
        
        let alertController = UIAlertController(title: NSLocalizedString("Error", comment: "UIAlertController Title"),
                                                message: NSLocalizedString("Error while loging in. Error message is: ", comment: "Message")+">\(error.localizedDescription)<",
                                                preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: NSLocalizedString("Cancel", comment: "Button Title"), style: .cancel)
        
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true)
    }
    
    fileprivate func applicationRegistrationCompleted() {
        
        RxMoyaProvider<Mastodon.OAuth>(endpointClosure: /self.url)
            .request(.authenticate(self.app, self.email.value, self.password.value))
            .mapObject(type: AccessToken.self)
            .subscribe(
                EventHandler(onNext: self.accessTokenReceived,
                             onError: self.requestErrorOccured,
                             onCompleted: self.oauthCompleted))
            .disposed(by: disposeBag)
    }
    
    fileprivate func accessTokenReceived(_ token: AccessToken) {
        
        self.token = token
    }
    
    fileprivate func oauthCompleted() {
        
        if account == nil {
            
            account = self.accountController?.createAccount(server: self.server.value,
                                                            email: self.email.value)
        }
        
        account?.password = self.password.value
        account?.clientId = app.clientId
        account?.clientSecret = app.clientSecret
        account?.accessToken = token
        
        account?.verifyAccount({ (verified, error) in
        
            self.accountController?.saveData()
            self.navigationController?.popViewController(animated: true)
        })
    }
    
    
    // MARK: - Private Methods
    
    fileprivate func bindControls() {
        
        // Bind the text fields to the properties
        (self.serverTextField.rx.text.orEmpty <-> self.server)
            .disposed(by: self.disposeBag)
        (self.emailTextField.rx.text.orEmpty <-> self.email)
            .disposed(by: self.disposeBag)
        (self.passwordTextField.rx.text.orEmpty <-> self.password)
            .disposed(by: self.disposeBag)
    }
}
