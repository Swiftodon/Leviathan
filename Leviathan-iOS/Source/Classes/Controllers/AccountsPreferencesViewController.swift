//
//  AccountsPreferencesViewController.swift
//  Leviathan
//
//  Created by Bonk, Thomas on 18.04.17.
//
//

import UIKit
import RxCocoa
import RxSwift
import Toucan

fileprivate extension String {
    static let accountCell = "MastodonAccountCell"
}


class AccountsPreferencesViewController: UIViewController {
    
    // MARK: - Private Properties
    
    @IBOutlet weak var tableView : UITableView!
    
    private var viewModel: Observable<AccountsPreferencesViewModel>!
    private let settings = Globals.injectionContainer.resolve(Settings.self)
    private let defaultImage = Asset.icAccount.image
    private let imageSize = CGSize(width: 24, height: 24)
    private let disposeBag = DisposeBag()
    
    
    // MARK: - UIViewController 
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.createBindings()
    }

    
    // MARK: - Action Handlers
    
    @IBAction fileprivate func done(sender: UIBarButtonItem) {

        if settings?.activeAccount == nil {
            
        }
        
        self.navigationController?.dismiss(animated: true)
    }
    
    
    // MARK: - Private Methods
    
    fileprivate func createBindings() {
        
        guard let accountModel = Globals.injectionContainer.resolve(AccountModel.self) else {
            preconditionFailure()
        }
        let initialState = AccountsPreferencesViewModel(accountModel.loadData())
        let deleteCommand = self.tableView.rx
                                .itemDeleted
                                .map(AccountsPreferencesViewEditingCommand.delete)
        viewModel = Observable.system(initialState,
                                      accumulator: AccountsPreferencesViewModel.executeCommand,
                                      scheduler: MainScheduler.instance,
                                      feedback: { _ in deleteCommand }).shareReplay(1)
        viewModel
            .map { $0.model.accounts }
            .bind(to: self.tableView.rx.items(cellIdentifier: String.accountCell)) {
                (row, element, cell) in
                
                cell.textLabel?.text = "@\(element.username)"
                cell.detailTextLabel?.text = String(describing: element.baseUrl)
                
                if let avatarData = element.avatarData {
                    
                    cell.imageView?.image = Toucan(image: UIImage(data: avatarData)!)
                        .resize(self.imageSize)
                        .maskWithEllipse()
                        .image
                    
                }
                else {
                    
                    cell.imageView?.image = self.defaultImage
                }
            }
            .disposed(by: disposeBag)
        viewModel
            .map { $0.model.accounts }
            .subscribe { event in
                switch (self.settings?.activeAccount, event.element?.first) {
                case let (activeAccount, firstAccount) where activeAccount != nil && firstAccount == nil:
                    self.settings?.activeAccount = nil
                    break
                case let (activeAccount, firstAccount) where activeAccount == nil && firstAccount != nil:
                    self.settings?.activeAccount = firstAccount
                    break
                default:
                    break
                }
            }
            .disposed(by: disposeBag)
    }
}
