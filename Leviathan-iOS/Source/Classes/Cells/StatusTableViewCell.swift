//
//  StatusTableViewCell.swift
//  Leviathan
//
//  Created by Thomas Bonk on 14.05.17.
//
//

import UIKit
import RxSwift
import RxMoya
import MastodonSwift

extension String {
    
    func htmlAttributedString() -> NSAttributedString? {
        
        guard let data = self.data(using: String.Encoding.utf16, allowLossyConversion: false) else { return nil }
        guard let html = try? NSMutableAttributedString(
            data: data,
            options: [NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType],
            documentAttributes: nil) else { return nil }
        
        return html
    }
}


class StatusTableViewCell: UITableViewCell {

    // MARK: - Properties
    
    @IBOutlet var userAvatarImageView: UIImageView!
    @IBOutlet var userLabel: UILabel!
    @IBOutlet var usernameLabel: UILabel!
    @IBOutlet var postedLabel: UILabel!
    @IBOutlet var noteLabel: UILabel!

    var status: MastodonSwift.Status! = nil {
        didSet {
            self.updateCell()
        }
    }
    
    let disposeBag = DisposeBag()
    
    
    // MARK: - Private Methods
    
    private func updateCell() {
        
        self.userLabel.text = self.status.account?.displayName
        self.usernameLabel.text = self.status.account?.acct
        self.noteLabel.attributedText = self.status.content.htmlAttributedString()
        
        RxMoyaProvider<AvatarImage>()
            .request(.download(self.status.account!.avatar!))
            .mapImage()
            .subscribe(
                EventHandler(onNext: { img in
                    
                    self.userAvatarImageView.image = img
                },
                onError: { err in
                                
                    self.userAvatarImageView.image = Asset.icAccount.image
                }))
            .disposed(by: disposeBag)
    }
}
