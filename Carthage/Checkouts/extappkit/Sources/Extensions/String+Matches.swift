//
//  String+String_Matches.swift
//  ExtAppKit
//
//  Created by Thomas Bonk on 23.01.16.
//  Copyright © 2016 Thomas Bonk Softwareentwicklung / meandmymac.de. All rights reserved.
//

import Foundation


public extension String {
    
    func beginsWith (_ str: String) -> Bool {

        if let range = self.range(of: str) {

            return range.lowerBound == self.startIndex
        }

        return false
    }

    func endsWith (_ str: String) -> Bool {

        if let range = self.range(of: str, options:NSString.CompareOptions.backwards) {

            return range.upperBound == self.endIndex
        }
        
        return false
    }
}
