//
//  StatusHeader.swift
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

fileprivate let VisibilityImage: [Status.Visibility: String] = [
    .pub: "globe",
    .unlisted: "checklist.unchecked",
    .priv: "lock",
    .direct: "envelope"
]

struct StatusHeader: View {

    // MARK: - Public Properties

    var body: some View {
        LazyVGrid(columns: [GridItem(.fixed(32), alignment: .topLeading), GridItem(alignment: .topLeading)]) {
            accountImage(persistedStatus)
            LazyVGrid(columns: [GridItem(alignment: .topLeading)]) {
                Text(displayName)
                    .font(.body)
                HStack(alignment: .top) {
                    Text("@\(accountName)")
                    Text("·")
                    Updating(120) {
                        Text(createdAt)
                    } onUpdate: {
                        createdAt = persistedStatus.createdAtRelative
                    }
                    Image(systemName: VisibilityImage[persistedStatus.visibility]!)
                        .resizable()
                        .frame(width: 12, height: 12)
                    Spacer()
                }
                .foregroundColor(.secondary)
            }
            .font(.footnote)
        }
    }

    @ObservedObject
    var persistedStatus: PersistedStatus


    // MARK: - Private Properties

    @State
    private var createdAt: String
    private var displayName: String
    private var accountName: String


    // MARK: - Initialization

    init(persistedStatus: PersistedStatus) {
        self.persistedStatus = persistedStatus
        createdAt = persistedStatus.createdAtRelative
        displayName = (persistedStatus.account?.displayName ?? persistedStatus.account?.username) ?? "Unknown"
        accountName = persistedStatus.account?.acct ?? "Unknown"
    }


    // MARK: - Private Methods

    @ViewBuilder
    private func accountImage(_ status: PersistedStatus) -> some View {
        VStack {
            AsyncImage(url: status.account?.avatar) { image in
                image
                    .resizable()
                    .frame(width: 32, height: 32)
                    .cornerRadius(4)
            } placeholder: {
                Image(systemName: "person.circle")
                    .resizable()
                    .frame(width: 32, height: 32)
            }
            Spacer()
        }
    }
}

