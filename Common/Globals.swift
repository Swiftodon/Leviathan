//
//  Globals.swift
//  Leviathan
//
//  Created by Thomas Bonk on 12.04.17.
//
//

import Foundation
import Swinject


// MARK: - Timeline Controller IDs

enum Timeline: String {
    
    case Home           = "3000"
    case Local          = "4000"
    case Federated      = "5000"
    case Notification   = "2000"
}


// MARK: - Global Variables and Constants

public struct Globals {

    // The DI Container
    public static let injectionContainer: Container = {
        
        let container = Container()
        
        container.register(AccountController.self) { _ in AccountController() }
        container.register(Settings.self) { _ in Settings() }
        
        return container
    }()
    
    // The documents directory
    public static let applicationDocumentsDirectory: URL = {
       
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last!
    }()
}

