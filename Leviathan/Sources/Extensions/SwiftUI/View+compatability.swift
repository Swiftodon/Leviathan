//
//  View+compatability.swift
//  Leviathan
//
//  Created by Thomas Bonk on 01.11.22.
//  Copyright 2022 The Swiftodon Team
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//

#if os(macOS)

import SwiftUI

struct NavigationBarItem {
    enum TitleDisplayMode {
        case automatic
        case inline
        case large
    }
}

public enum UIKeyboardType : Int, @unchecked Sendable {
    case `default` = 0 // Default type for the current input method.
    case asciiCapable = 1 // Displays a keyboard which can enter ASCII characters
    case numbersAndPunctuation = 2 // Numbers and assorted punctuation.
    case URL = 3 // A type optimized for URL entry (shows . / .com prominently).
    case numberPad = 4 // A number pad with locale-appropriate digits (0-9, ۰-۹, ०-९, etc.). Suitable for PIN entry.
    case phonePad = 5 // A phone pad (1-9, *, 0, #, with letters under the numbers).
    case namePhonePad = 6 // A type optimized for entering a person's name or phone number.
    case emailAddress = 7 // A type optimized for multiple email address entry (shows space @ . prominently).
    case decimalPad = 8 // A number pad with a decimal point.
    case twitter = 9 // A type optimized for twitter text entry (easy access to @ #)
    case webSearch = 10 // A default keyboard type with URL-oriented addition (shows space . prominently).
    case asciiCapableNumberPad = 11 // A number pad (0-9) that will always be ASCII digits.
}

extension View {
    func navigationBarTitleDisplayMode(_ displayMode: NavigationBarItem.TitleDisplayMode) -> some View {
        return self
    }
    public func keyboardType(_ type: UIKeyboardType) -> some View {
        return self
    }
}

#endif
