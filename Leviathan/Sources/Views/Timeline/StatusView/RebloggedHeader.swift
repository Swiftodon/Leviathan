//
//  RebloggedHeader.swift
//  Leviathan
//
//  Created by Thomas Bonk on 14.11.22.
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
import SwiftUI

struct RebloggedHeader: View {

    // MARK: - Public Properties

    var body: some View {
        If(showReblogHeader) {
            HStack(alignment: .top) {
                Updating(120) {
                    Label("\(statusUsername) boosted \(createdAt)", systemImage: "repeat")
                        .foregroundColor(.secondary)
                } onUpdate: {
                    createdAt = persistedStatus.createdAtRelative
                }
                Spacer()
            }
        }
    }

    @ObservedObject
    var persistedStatus: PersistedStatus


    // MARK: - Private properties

    @State
    private var createdAt: String
    private var showReblogHeader: Bool
    private var statusUsername: String {
        if let name = persistedStatus.account?.displayName {
            return name
        }
        if let name = persistedStatus.account?.username {
            return "@\(name)"
        }

        return "Unknown"
    }


    // MARK: - Initialization

    init(persistedStatus: PersistedStatus) {
        self.persistedStatus = persistedStatus
        createdAt = persistedStatus.createdAtRelative
        showReblogHeader = (persistedStatus.reblog != nil)
    }
}

