//
//  XCache.swift
//  ExtAppKit
//
//  Created by Thomas Bonk on 23.11.15.
//  Copyright © 2015 Thomas Bonk Softwareentwicklung / meandmymac.de. All rights reserved.
//

import Foundation


open class XCache {

    // Mark: Class Variables

    private static let _instance: XCache = { XCache() }()


    // MARK: Public Typealiases

    public typealias ObjectLoadCallback = (_ group: String, _ key: AnyObject) -> (AnyObject?, Int)

    // MARK: Singleton Property 

    open class var sharedInstance : XCache {

        return XCache._instance
    }


    // MARK: Private Properties

    fileprivate var _cache: NSCache = NSCache<AnyObject, AnyObject>()


    // MARK: Public Properties

    open var totalCostLimit: Int {
        get {
            enter()

            defer {
                leave()
            }
            return self._cache.totalCostLimit
        }
        set {
            enter()

            self._cache.totalCostLimit = newValue

            defer {
                leave()
            }
        }
    }


    // MARK: Initialization

    public init(totalCostLimit: Int = 1024 * 1024 * 8) {
        enter()

        self.totalCostLimit = totalCostLimit

        defer {
            leave()
        }
    }


    // MARK: Manage Objects

    open func objectForGroup(_ group: String, key: AnyObject, objectLoad: ObjectLoadCallback) -> AnyObject? {
        enter()

        var object: AnyObject? = nil
        var codedKey: String = "\(group)_\(key)"

        object = self._cache.object(forKey: codedKey as AnyObject)

        if object == nil {

            var cost: Int = 0

            (object, cost) = objectLoad(group, key)

            if object != nil {

                self._cache.setObject(object!, forKey: codedKey as AnyObject, cost: cost)
            }
        }

        defer {
            leave()
        }
        return object
    }

    open func removeObjectForGroup(_ group: String, key: AnyObject) {
        enter()

        var codedKey: String = "\(group)_\(key)"

        self._cache.removeObject(forKey: codedKey as AnyObject)

        defer {
            leave()
        }
    }

}
