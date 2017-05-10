//
//  PostNoteViewController.swift
//  Leviathan
//
//  Created by Bonk, Thomas on 26.04.17.
//
//

import UIKit
import Eureka
import RxCocoa
import RxSwift
import Moya
import RxMoya
import MastodonSwift
import Toucan

class PostNoteViewController: FormViewController {

    // MARK: - Private Properties
    
    @IBOutlet private var tv: UITableView! {
        // tableView doesn't appear in IB
        set {
            super.tableView = tv
        }
        get {
            return super.tableView
        }
    }
    @IBOutlet private var accountIndicatorButton: UIButton!
    
    private let settings = Globals.injectionContainer.resolve(Settings.self)
    private let disposeBag = DisposeBag()
    
    private var note = Variable<String>("")
    
    
    // MARK: - UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.bindAvatarImage()
        self.prepareForm()
    }
    
    
    // MARK: - Action Handlers
    
    @IBAction fileprivate func cancel(sender: UIBarButtonItem) {
        
        self.dismiss(animated: true)
    }
    
    @IBAction fileprivate func post(sender: UIBarButtonItem) {
        
        let account = settings?.activeAccount
        let accessToken = account?.accessToken
        let token = accessToken?.token
        let accessTokenPlugin = AccessTokenPlugin(token: token!)
        
        RxMoyaProvider<Mastodon.Statuses>(endpointClosure: /account!.baseUrl, plugins: [accessTokenPlugin])
            .request(.new(self.note.value, nil, nil, false, "", .pub))
            .mapObject(type: MastodonSwift.Status)
            .subscribe(
                EventHandler(onNext: { status in
                 
                    NSLog("Error: \(status)")
                },
                onError: { err in
                    
                    NSLog("Error: \(err.localizedDescription)")
                },
                onCompleted: {
                
                    self.dismiss(animated: true)
                }))
            .disposed(by: self.disposeBag)
    }
    
    
    // MARK: - Private Methods
    
    fileprivate func prepareForm() {
        
        self.form +++ Section("Note")
            <<< TextAreaRow() { row in
                    row.textAreaHeight = .dynamic(initialTextViewHeight: 44)
                    row.onChange { self.note.value = $0.value ?? "" }
                }
    }
    
    fileprivate func bindAvatarImage() {
    
        guard let settings = settings else {
            preconditionFailure()
        }
        
        setAvatarImage(for: settings.activeAccount)
        settings.accountSubject.subscribe { event in
            switch event {
            case .next(let account):
                self.setAvatarImage(for: account)
            default:
                break
            }
            }.addDisposableTo(disposeBag)
    }
    
    fileprivate func setAvatarImage(for account: Account?) {
        
        guard let account = account else {
            self.accountIndicatorButton?.setImage(Asset.icAccount.image, for: .normal)
            return
        }
        
        guard let avatarData = account.avatarData else {
            return
        }
        
        guard let image =  UIImage(data: avatarData) else {
            return
        }
        
        accountIndicatorButton?.setImage(
            Toucan(image: image)
                .maskWithEllipse()
                .resize(CGSize(width: 24, height: 24))
                .image,
            for: .normal
        )
    }
}
