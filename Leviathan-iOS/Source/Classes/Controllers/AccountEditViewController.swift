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
    private var unlockView = Variable<Bool>(true)
    
    private var url: URL!
    private var app: App!
    private var token: AccessToken!
    private let disposeBag = DisposeBag()
    private var account: Leviathan.Account? = nil
    private let accountModel = Globals.injectionContainer.resolve(AccountModel.self)

    
    // MARK: - UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.prepareForm()
        self.createBindings()
    }
    
    
    // MARK: - Action Handlers
    
    @IBAction fileprivate func save(sender: UIBarButtonItem) {
        
        self.url = URL(string: "https://\(self.server.value)")
        
        self.unlockView.value = false
        //self.spinningView.isHidden = false
        //self.cancelButton.isEnabled = false
        //self.saveButton.isEnabled = false
        
        let credentialsPlugin = CredentialsPlugin { _ in
            URLCredential(user: self.email.value, password: self.password.value, persistence: .none)
        }
        
        MastodonClient(plugins: [credentialsPlugin])
            .createApp("Leviathan for iOS",
                       scopes: ["read", "write", "follow"],
                       url: URL(string: "https://github.com/Swiftodon")!,
                       endpointClosure: /self.url)
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
        
        self.unlockView.value = true
        //self.spinningView.isHidden = true
        //self.cancelButton.isEnabled = true
        //self.saveButton.isEnabled = true
        
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true)
    }
    
    fileprivate func applicationRegistrationCompleted() {
        
        MastodonClient()
            .getToken(self.app, username: self.email.value, password: self.password.value, endpointClosure: /self.url)
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
        
        let acc = self.account ?? Leviathan.Account()
                
        acc.server = self.server.value
        acc.email = self.email.value
        acc.password = self.password.value
        acc.clientId = self.app.clientId
        acc.clientSecret = self.app.clientSecret
        acc.accessToken = self.token
        
        acc.verifyAccount({ (verified, error) in
        
            // TODO handle error
            self.accountModel?.addIfNotExisting(acc)
            self.accountModel?.saveData()
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
                self.accountModel?.find(email: $1, server: $0) == nil
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
            .bind(to: self.saveButton.rx.isEnabled)
            .disposed(by: self.disposeBag)
        
        self.unlockView
            .asObservable()
            .bind(to: self.spinningView.rx.isHidden)
            .disposed(by: self.disposeBag)
        self.unlockView
            .asObservable()
            .bind(to: self.cancelButton.rx.isEnabled)
            .disposed(by: self.disposeBag)
        self.unlockView
            .asObservable()
            .bind(to: self.saveButton.rx.isEnabled)
            .disposed(by: self.disposeBag)
    }
}
