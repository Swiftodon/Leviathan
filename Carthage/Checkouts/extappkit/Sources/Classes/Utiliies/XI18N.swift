//
//  XI18N.swift
//  ExtAppKit
//
//  Created by Thomas Bonk on 25.10.14.
//  Copyright (c) 2014 Thomas Bonk Softwareentwicklung / meandmymac.de. All rights reserved.
//

import Foundation

/**
    Returns the translated string for a given string.

    :param: string  The string which shall be transalted.

    :returns: The translated string, if a translation is available; otherwise
              the string is returned again.
*/
public func I18N(_ string: String) -> String {
    enter()

    var translatedString : String!

    translatedString = NSLocalizedString(string, tableName: nil, comment: "")

    if translatedString.characters.count == 0 {

        translatedString = string
    }


    //#define I18N(str) NSLocalizedString(str, nil)
    //#define I18NT(str,tab) NSLocalizedStringFromTable(str, tab, nil)

    defer {
        leave()
    }
    return translatedString
}
