//
//  Status+images.swift
//  Leviathan
//
//  Created by Thomas Bonk on 04.11.22.
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
import SwiftUI

extension Status {
    var accountImage: some View {
        Image(systemName: "person.circle")
            .resizable()
            .frame(width: 32, height: 32)
    }
}
