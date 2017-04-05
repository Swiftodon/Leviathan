//
//  NSDate+StripDate.swift
//  ExtAppKit
//
//  Created by Thomas Bonk on 01.02.16.
//  Copyright © 2016 Thomas Bonk Softwareentwicklung / meandmymac.de. All rights reserved.
//

import Foundation

/**
    Useful extensions to the NSDate class.
 */
public extension Date {
    /**
        Returns the given date without the time components.

        :param: date    The date

        :returns: The given date without the date components.
     */
    public static func timeWithoutDate(_ date: Date? = nil) -> Date {
        enter()

        let d = date == nil ? Date() : date!
        let flags = NSCalendar.Unit(rawValue: NSCalendar.Unit.hour.rawValue | NSCalendar.Unit.minute.rawValue | NSCalendar.Unit.second.rawValue)
        let calendar = Calendar.current
        let componentsDate = (calendar as NSCalendar).components(flags, from: d)
        let dateWithoutTime = calendar.date(from: componentsDate)

        defer {
            leave()
        }
        return dateWithoutTime!
    }

    /**
     Returns the date without the time components.

     :returns: The date without the time components.
     */
    public func timeWithoutDate() -> Date {
        enter()
        defer {
            leave()
        }
        return Date.dateWithoutTime(self)
    }

}
