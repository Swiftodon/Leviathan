//
//  XEventType.swift
//  ExtAppKit
//
//  Created by Bonk, Thomas on 13.02.17.
//  Copyright © 2017 Thomas Bonk Softwareentwicklung. All rights reserved.
//

import Foundation

public protocol XEventType: Hashable {
    
}

public enum NoEvents: XEventType {

    case any
}
