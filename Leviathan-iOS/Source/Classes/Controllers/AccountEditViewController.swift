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
import Eureka


class AccountEditViewController: FormViewController {

    // MARK: - Private Properties
    @IBOutlet private var tv: UITableView! {
        set {
            self.tableView = newValue
        }
        get {
            return self.tableView
        }
    }
    @IBOutlet private var spinningView: UIView!
    @IBOutlet private var cancelButton: UIBarButtonItem!
    @IBOutlet private var saveButton: UIBarButtonItem!
    
    private var server = Variable<String>("")
    private var email = Variable<String>("")
    private var password = Variable<String>("")
    private var inputValidator: Observable<Bool>!
    
    private var url: URL!
    private var app: App!
    private var token: AccessToken!
    private let disposeBag = DisposeBag()
    private var account: Account? = nil
    private let accountController = Globals.injectionContainer.resolve(AccountController.self)

    
    // MARK: - UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.prepareForm()
        self.createBindings()
    }
    
    
    // MARK: - Action Handlers
    
    @IBAction fileprivate func save(sender: UIBarButtonItem) {
        
        self.url = URL(string: "https://\(self.server.value)")
        
        self.spinningView.isHidden = false
        self.cancelButton.isEnabled = false
        self.saveButton.isEnabled = false
        
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
        
        self.spinningView.isHidden = true
        self.cancelButton.isEnabled = true
        self.saveButton.isEnabled = true
        
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
            
            account = self.accountController?.create(server: self.server.value,
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
    
    fileprivate func prepareForm() {
        
        let visualizeValidationError: (TextCell, TextRow) -> ()  = { cell, row in
            cell.contentView.layer.borderWidth = !row.isValid ? 2 : 0
            cell.contentView.layer.borderColor = !row.isValid ? UIColor.red.cgColor : UIColor.clear.cgColor
        }
        
        self.form
            +++ Section("Server")
                <<< TextRow() { row in
                    row.placeholder = "Enter hostname of Mastodon server"
                    row.onChange { self.server.value = $0.value ?? "" }
                    row.add(rule: RuleRequired())
                    row.validationOptions = .validatesOnChange
                }
                .cellUpdate(visualizeValidationError)
            +++ Section("E-Mail")
                <<< TextRow() { row in
                    row.placeholder = "Enter e-mail address"
                    row.onChange { self.email.value = $0.value ?? "" }
                    row.add(rule: RuleRequired())
                    row.add(rule: RuleEmail())
                    row.validationOptions = .validatesOnChange
                }
               .cellUpdate(visualizeValidationError)
            +++ Section("Password")
                <<< PasswordRow() { row in
                    row.placeholder = "Enter password"
                    row.onChange { self.password.value = $0.value ?? "" }
                    row.add(rule: RuleRequired())
                    row.validationOptions = .validatesOnChange
                }
                .cellUpdate { cell, row in
                    cell.contentView.layer.borderWidth = !row.isValid ? 2 : 0
                    cell.contentView.layer.borderColor = !row.isValid ? UIColor.red.cgColor : UIColor.clear.cgColor
                }
    }
    
    fileprivate func createBindings() {
        
        // Validations
        let serverValid: Observable<Bool> = self.server.asObservable()
            .map { text -> Bool in
                text.characters.count > 0 && (URL(string: "http://\(text)") != nil)
            }
            .shareReplay(1)
        let emailValid: Observable<Bool> = self.email.asObservable()
            .map { text -> Bool in
                text.characters.count > 0
            }
            .shareReplay(1)
        let serverAndEmailValid: Observable<Bool>
            = Observable.combineLatest(serverValid, emailValid) {
                $0 && $1
            }
        let accountValid: Observable<Bool>
            = Observable.combineLatest(self.server.asObservable(), self.email.asObservable()) {
                self.accountController?.find($0, $1) == nil
            }
        let passwordValid: Observable<Bool> = self.password.asObservable()
            .map { text -> Bool in
                text.characters.count > 0
            }
            .shareReplay(1)
        let everythingValid: Observable<Bool>
            = Observable.combineLatest([serverAndEmailValid, accountValid, passwordValid]) {
                $0[0] && $0[1] && $0[2]
            }
                
        everythingValid
            .bind { enabled in
                self.saveButton.isEnabled = enabled
            }
            .disposed(by: self.disposeBag)
    }
}
