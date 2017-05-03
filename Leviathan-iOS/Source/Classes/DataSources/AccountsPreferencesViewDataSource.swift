//
//  AccountsPreferencesViewModel.swift
//  Leviathan
//
//  Created by Thomas Bonk on 01.05.17.
//
//

import UIKit
import Toucan


fileprivate extension String {
    static let accountCell = "MastodonAccountCell"
}

class AccountsPreferencesViewDataSource
    : NSObject
    , UITableViewDataSource {
    
    // MARK: - Public Properties
    
    let model: AccountModel = Globals.injectionContainer.resolve(AccountModel.self)!
    let defaultImage = Asset.icAccount.image
    let imageSize = CGSize(width: 24, height: 24)
    
    
    // MARK: - UITableViewDataSource
    
    @available(iOS 2.0, *)
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
     
        return self.model.accounts.count
    }
    
    @available(iOS 2.0, *)
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String.accountCell) else {
            preconditionFailure()
        }
        
        let account = self.model.accounts[indexPath.row]
        
        cell.textLabel?.text = "@\(account.username)"
        cell.detailTextLabel?.text = String(describing: account.baseUrl)
        
        if let avatarData = account.avatarData {
            
            cell.imageView?.image = Toucan(image: UIImage(data: avatarData)!)
                .resize(self.imageSize)
                .maskWithEllipse()
                .image
            
        }
        else {
            
            cell.imageView?.image = self.defaultImage
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        switch editingStyle {
        case .delete:
            tableView.beginUpdates()
            tableView.deleteRows(at: [indexPath], with: .fade)
            self.model.delete(at: indexPath.row)
            tableView.endUpdates()
            break
            
        default:
            // do nothing
            break
        }
    }
}
