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
        
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction fileprivate func cancel(sender: UIBarButtonItem) {
        
        self.navigationController?.popViewController(animated: true)
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
