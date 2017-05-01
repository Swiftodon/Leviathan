//
//  AccountsPreferencesViewModel.swift
//  Leviathan
//
//  Created by Thomas Bonk on 01.05.17.
//
//

import Foundation


enum AccountsPreferencesViewEditingCommand {
    case delete(indexPath: IndexPath)
}


struct AccountsPreferencesViewModel {
    
    // MARK: - Public Properties
    
    private(set) var model: AccountModel!
    
    
    // MARK: - Initialization
    
    init(_ model: AccountModel) {
        
        self.model = model
    }
    
    
    // MARK: - Command Handlers
    
    func deleteAccount(_ indexPath: IndexPath) -> AccountsPreferencesViewModel {
        
        self.model.delete(at: indexPath.row)
        self.model.saveData()
        return AccountsPreferencesViewModel(self.model)
    }

    
    // MARK: - Command Dispatcher
    
    static func executeCommand(state: AccountsPreferencesViewModel, _ command: AccountsPreferencesViewEditingCommand) -> AccountsPreferencesViewModel {
        switch command {
            
            
            case let .delete(indexPath):
                return state.deleteAccount(indexPath)
        }
    }
}
