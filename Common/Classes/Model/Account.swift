//
//  Account.swift
//  Leviathan
//
//  Created by Thomas Bonk on 15.04.17.
//
//

import Cocoa
import MastodonSwift

class Account {
    
    // MARK: - Initialization
    
    init() {
        
    }
    
    // MARK: - Properties required for NSTreeController
    
    let children: [Account] = []
    let isLeaf = true
}
