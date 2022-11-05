//
//  Status+createdAt.swift
//  Leviathan
//
//  Created by Thomas Bonk on 05.11.22.
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

import MastodonSwift
import Foundation

fileprivate var dateFormatter: ISO8601DateFormatter = {
    let dateFormatter = ISO8601DateFormatter()
    dateFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
    
    return dateFormatter
}()

extension Status {
    var timestamp: Date {
        return dateFormatter.date(from: self.createdAt)!
    }
    
    var createdAtRelative: String {
        var difference = timestamp.distance(to: Date())
        
        if difference < 60 {
            return "just now"
        }
        
        difference = difference / 60
        if difference < 60 {
            return "\(Int(difference)) min ago"
        }
        
        difference = difference / 60
        if difference < 24 {
            if Int(difference) < 2 {
                return "\(Int(difference)) hour ago"
            } else {
                return "\(Int(difference)) hours ago"
            }
        }
        
        difference = difference / 24
        return "\(Int(difference)) days ago"
    }
}
