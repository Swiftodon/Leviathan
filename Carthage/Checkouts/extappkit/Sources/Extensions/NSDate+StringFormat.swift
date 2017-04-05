//
//  NSDate+StringFormat.swift
//  ExtAppKit
//
//  Created by Thomas Bonk on 28.11.14.
//  Copyright (c) 2014 Thomas Bonk Softwareentwicklung / meandmymac.de. All rights reserved.
//

import Foundation


public extension Date {

    /**
        Formats the receiver's date according to te given style.
    */
    public func dateString(_ style: DateFormatter.Style = .medium) -> String {
        enter()

        let dateFormatter = DateFormatter()
        var result : String!

        dateFormatter.locale = Locale.current
        dateFormatter.dateStyle = style
        dateFormatter.timeZone = TimeZone.current

        result = dateFormatter.string(from: self)

        defer {
            leave()
        }
        return result
    }

    /**
        Formats the receiver's date according to te given format string.
    */
    public func dateString(format: String) -> String {
        enter()

        let dateFormatter = DateFormatter()
        var result : String!

        dateFormatter.locale = Locale.current
        dateFormatter.dateFormat = format
        dateFormatter.timeZone = TimeZone.current

        result = dateFormatter.string(from: self)

        defer {
            leave()
        }
        return result
    }

    /**
        Formats the receiver's time according to te given format string.
    */
    public func timeString(_ format: String? = nil) -> String {
        enter()

        let dateFormatter = DateFormatter()
        let fmt = format != nil ? format : "HH:mm"
        var result : String!

        dateFormatter.locale = Locale.current
        dateFormatter.dateFormat = fmt
        dateFormatter.timeZone = TimeZone.current

        result = dateFormatter.string(from: self)

        defer {
            leave()
        }
        return result
    }
}
