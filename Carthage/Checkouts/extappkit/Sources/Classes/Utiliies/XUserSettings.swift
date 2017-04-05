//
//  XUserSettings.swift
//  ExtAppKit
//
//  Created by Thomas Bonk on 22.10.14.
//  Copyright (c) 2014 Thomas Bonk Softwareentwicklung / meandmymac.de. All rights reserved.
//

import Foundation

/**
    Convenient class for managing the user defaults.
*/
open class XUserSettings: NSObject {

    // MARK: Initialization

    public override init() {

        // EMPTY BY DESIGN
    }

    
    // MARK: Initialization Methods 

    /**
        Regsiter default values to the user defaults.

        :param: defaults    Default user settings
    */
    open func registerDefaults(_ defaults: [String : AnyObject]) {
        enter()

        let userDefaults = UserDefaults.standard

        userDefaults.register(defaults: defaults)

        defer {
            leave()
        }
    }


    // MARK: Get and Set Defaults

    /**
        Read the value for a key from the user settings.

        :param: key     The key of the user setting

        :returns: The value for the key
    */
    open func getUserDefault(_ key: String) -> AnyObject? {

        enter()

        let userDefaults = UserDefaults.standard
        let result : AnyObject? = userDefaults.object(forKey: key) as AnyObject?

        defer {
            leave()
        }
        return result
    }

    /**
        Write a value for a key to the user defaults.

        :param: key     The key of the user setting
        :param: value   The new value
    */
    open func setUserDefault(_ key: String, value: AnyObject) {
        enter()

        let userDefaults = UserDefaults.standard

        userDefaults.set(value, forKey: key)
        userDefaults.synchronize()

        defer {
            leave()
        }
    }
}
