//
//  XConversionFunctions.swift
//  ExtAppKit
//
//  Created by Thomas Bonk on 26.11.15.
//  Copyright © 2015 Thomas Bonk Softwareentwicklung / meandmymac.de. All rights reserved.
//

import Foundation

// MARK: Get string fraction from float

private func gcdOf(_ a: Int, and b: Int) -> Int {
    enter()

    defer {
        leave()
    }

    if b == 0 {

        return a
    }
    else {

        return gcdOf(a, and: (a % b))
    }
}

public func fractionFromFloat(_ f: Float) -> String {
    enter()

    var result = ""
    var factor: Int = 100
    var whole: Int = Int((f - floor(f)) * Float(factor))
    var gcd = gcdOf(whole, and: factor)
    var nominator: Int = whole / (gcd == 0 ? 1 : gcd)
    var denominator: Int = factor / (gcd == 0 ? 1 : gcd)

    if Int(floor(f)) != 0 {
        result.append("\(Int(floor(f)))")
    }

    if nominator > 0 && denominator > 0 {

        if denominator > 2 * nominator {

            denominator = denominator / nominator
            nominator = nominator / nominator
        }
        else if nominator * 10 > 100 && denominator * 10 > 100 {

            nominator = nominator / 30;
            denominator = denominator / 30;
        }

        if result.characters.count > 0 {
            result.append(" \(nominator)/\(denominator)")
        }
        else {
            result.append("\(nominator)/\(denominator)")
        }
    }

    defer {
        leave()
    }
    return result
}

public func stringFromInteger(_ number: NSNumber?, defaultValue: String = "") -> String {
    enter()

    var str = defaultValue

    if let intValue: Int = number?.intValue {

        str = String(intValue)
    }

    defer {
        leave()
    }

    return str
}
