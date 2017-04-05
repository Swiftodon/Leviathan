//
//  String+Path.swift
//  ExtAppKit
//
//  Created by Thomas Bonk on 11.10.15.
//  Copyright © 2015 Thomas Bonk Softwareentwicklung / meandmymac.de. All rights reserved.
//

import Foundation

extension String {

    public var lastPathComponent: String {

        get {
            return (self as NSString).lastPathComponent
        }
    }
    public var pathExtension: String {

        get {

            return (self as NSString).pathExtension
        }
    }
    public var stringByDeletingLastPathComponent: String {

        get {

            return (self as NSString).deletingLastPathComponent
        }
    }
    public var stringByDeletingPathExtension: String {

        get {

            return (self as NSString).deletingPathExtension
        }
    }
    public var pathComponents: [String] {

        get {

            return (self as NSString).pathComponents
        }
    }

    public func stringByAppendingPathComponent(_ path: String) -> String {

        let nsSt = self as NSString

        return nsSt.appendingPathComponent(path)
    }

    public func stringByAppendingPathExtension(_ ext: String) -> String? {

        let nsSt = self as NSString

        return nsSt.appendingPathExtension(ext)
    }
}
