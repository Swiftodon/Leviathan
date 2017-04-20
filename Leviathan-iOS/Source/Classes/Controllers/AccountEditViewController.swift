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
    
    private let disposeBag = DisposeBag()

    
    // MARK: - UIViewController
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.bindControls()
    }
    
    
    // MARK: - Action Handlers
    
    @IBAction fileprivate func save(sender: UIBarButtonItem) {
        
        let url = "https://\(self.server.value)"
        
        RxMoyaProvider<Mastodon.Apps>(endpointClosure: /url,
                                      plugins: [CredentialsPlugin { _ -> URLCredential? in
                                        return URLCredential(user: self.email.value, password: self.password.value, persistence: .none)
                                        }
            ])
            .request(.register("Leviathan", "urn:ietf:wg:oauth:2.0:oob", "read write follow", "https://github.com/Swiftodon"))
            .mapObject(type: App.self)
            .subscribe(self.applicationWasRegistered)
            .disposed(by: disposeBag)
        
        //self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction fileprivate func cancel(sender: UIBarButtonItem) {
        
        self.navigationController?.popViewController(animated: true)
    }
    
    
    // MARK: - RxMoya Handlers
    
    fileprivate func applicationWasRegistered(_ event: Event<App>) {

        switch event {
        case.next(let app):
        let url = "https://\(self.server.value)"
        
        RxMoyaProvider<Mastodon.OAuth>(endpointClosure: /url)
            .request(.authenticate(app, self.email.value, self.password.value))
            .mapObject(type: AccessToken.self)
            .subscribe { even in
                NSLog("")
        }
        .disposed(by: disposeBag)
            
        default:
            break
        }

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
