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
    public static let injectionContainer = Container()
}

