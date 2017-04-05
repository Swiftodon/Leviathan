//
//  XOperators.swift
//  ExtAppKit
//
//  Created by Thomas Bonk on 07.11.16.
//
//

import Foundation


infix operator =?: AssignmentPrecedence
public func =?<T> ( left: inout T?, right: T?) -> () {
    enter()

    left = nil

    if right != nil {

        left = right
    }

    leave()
}

public func =?<T> ( left: inout T, right: T?) -> () {
    enter()

    if right != nil {

        left = right!
    }
    
    leave()
}
