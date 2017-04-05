//
//  XAssociatedObjects.swift
//  ExtAppKit
//
//  Created by Thomas Bonk on 19.12.15.
//  Copyright © 2015 Thomas Bonk Softwareentwicklung / meandmymac.de. All rights reserved.
//

import Foundation


public func associatedObject<ValueType: AnyObject>(_ base: AnyObject, key: UnsafePointer<UInt8>, initialiser: (() -> ValueType)? = nil) -> ValueType? {

    if let associated = objc_getAssociatedObject(base, key) as? ValueType {

        return associated
    }

    if let associated = initialiser?() {

        objc_setAssociatedObject(base, key, associated, .OBJC_ASSOCIATION_RETAIN)
        return associated
    }

    return nil
}

public func associateObject<ValueType: AnyObject>(_ base: AnyObject, key: UnsafePointer<UInt8>, value: ValueType?) {
    enter()

    objc_setAssociatedObject(base, key, value, .OBJC_ASSOCIATION_RETAIN)

    leave()
}
