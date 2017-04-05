//
//  XStateMachineTransition.swift
//  ExtAppKit
//
//  Created by Bonk, Thomas on 13.02.17.
//  Copyright © 2017 Thomas Bonk Softwareentwicklung. All rights reserved.
//

import Foundation

internal class XStateMachineTransition<S: XStateType, E: XEventType> {
    
    // MARK: - Public Properties
    
    internal private(set) var fromState: S
    internal private(set) var toState: S
    
    // MARK: - Initialization
    
    internal init(from: S, to: S) {
        enter()
        
        self.fromState = from
        self.toState = to
    }
}
