//
//  TimelineViewController.swift
//  Leviathan
//
//  Created by Thomas Bonk on 17.04.17.
//
//

import UIKit
import RxCocoa
import RxSwift
import MastodonSwift
import Toucan

// MARK: - Key Paths
fileprivate extension String {
    static let activeAccount = "activeAccount"
}

class TimelineViewController: UITableViewController {
    
    // MARK: - Private Properties
    @IBOutlet weak var accountButton: UIButton?
    private var statuses: [Status] = []
    private let settings = Globals.injectionContainer.resolve(Settings.self)
    private let disposeBag = DisposeBag()
    

    // MARK: - Public Properties
    @IBInspectable var timelineId = Timeline.Home
    
    
    // MARK: - UIViewController
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard let _ = settings else {
            preconditionFailure()
        }
        
        setAvatarImage(for: settings?.activeAccount)
        settings?.accountSubject.subscribe { event in
            switch event {
            case .next(let account):
                self.setAvatarImage(for: account)
            default:
                break
            }
        }.addDisposableTo(disposeBag)
        
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 70
    }
    
    
    // MARK: - Action Handlers
    
    @IBAction fileprivate func showAccountMenu(sender: UIButton) {
        
        let width = self.view.frame.width * 0.8
        let accountMenu = AccountMenu(width: width)
        
        guard let button = self.accountButton else {
            return
        }
        
        accountMenu.show(fromView: button)
    }

    fileprivate func setAvatarImage(for account: Account?) {
        
        guard let account = account else {
            self.accountButton?.setImage(Asset.icAccount.image, for: .normal)
            return
        }

        var image: UIImage!
        if let avatarData = account.avatarData {
            image =  UIImage(data: avatarData)
        }
        else {
            image = Asset.icAccount.image
        }
        
        accountButton?.setImage(
            Toucan(image: image)
                .maskWithEllipse()
                .resize(CGSize(width: 36, height: 36))
                .image,
            for: .normal
        )
    }
}
