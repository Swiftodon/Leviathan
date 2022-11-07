//
//  PersistedStatus.swift
//  Leviathan
//
//  Created by Thomas Bonk on 06.11.22.
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
import MastodonSwift

extension PersistedStatus: Identifiable, NamedEntity {
    
    // MARK: - Enums
    
    enum Timeline: Int16 {
        case home       = 0
        case local      = 1
        case federated  = 2
        case unknown    = 0xAAA
    }
    
    
    // MARK: - Properties
    
    var timeline: Timeline {
        set {
            self.tl = newValue.rawValue
        }
        get {
            return Timeline(rawValue: self.tl) ?? .unknown
        }
    }
    
    var status: MastodonSwift.Status? {
        set {
            if let data = try? JSONEncoder().encode(newValue) {
                self.statusData = data
            }
        }
        get {
            let status = try? JSONDecoder().decode(MastodonSwift.Status.self, from: statusData)
            return status
        }
    }
}
