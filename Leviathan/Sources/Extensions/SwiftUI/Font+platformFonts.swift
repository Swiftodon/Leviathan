//
//  Font+platformFonts.swift
//  Leviathan
//
//  Created by Thomas Bonk on 09.11.22.
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

import Foundation
import SwiftUI

#if canImport(AppKit)
import AppKit

typealias PlatformFont = NSFont
typealias PlatformFontDescriptor = NSFontDescriptor

extension NSFontDescriptor {
    class func preferredFontDescriptor(withTextStyle style: NSFont.TextStyle) -> NSFontDescriptor {
        return preferredFontDescriptor(forTextStyle: style)
    }
}

#elseif canImport(UIKit)
import UIKit

typealias PlatformFont = UIFont
typealias PlatformFontDescriptor = UIFontDescriptor
#endif

extension Font {
    static var platformBody: PlatformFont {
        let platformFont = PlatformFont(
            descriptor: PlatformFontDescriptor.preferredFontDescriptor(withTextStyle: .body),
            size: PlatformFont.systemFontSize)
        
        #if canImport(AppKit)
        return platformFont!
        #else
        return platformFont
        #endif
    }
}
