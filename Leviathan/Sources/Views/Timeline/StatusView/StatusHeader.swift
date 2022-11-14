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
    .pub: "􀆪",
    .unlisted: "􁙠",
    .priv: "􀎠",
    .direct: "􀍕"
]

struct StatusHeader: View {

    // MARK: - Public Properties

    var body: some View {
        LazyVGrid(columns: [GridItem(.fixed(32), alignment: .topLeading), GridItem(alignment: .topLeading)]) {
            accountImage(status)
            LazyVGrid(columns: [GridItem(alignment: .topLeading)]) {
                Text(status.account?.displayName ?? (status.account?.username ?? "Unknown"))
                    .font(.body)
                HStack(alignment: .top) {
                    Text("@\(status.account?.acct ?? "Unknown")")
                    Text("·")
                    Text(status.createdAtRelative)
                    Text(VisibilityImage[status.visibility]!)
                    Spacer()
                }
                .foregroundColor(.secondary)
            }
            .font(.footnote)
        }
    }

    @State
    var status: Status


    // MARK: - Private Methods

    @ViewBuilder
    private func accountImage(_ status: Status) -> some View {
        VStack {
            AccountAvatar(account: status.account!)
            Spacer()
        }
    }
}

