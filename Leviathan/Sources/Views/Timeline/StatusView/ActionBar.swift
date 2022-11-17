//
//  ActionBar.swift
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

struct ActionBar: View {

    // MARK: - Public Properties

    var body: some View {
        HStack {
            Button {

            } label: {
                Image(systemName: "bubble.right")
                    .foregroundColor(.primary)
            }.padding(.trailing, 5)

            Button {

            } label: {
                Label("\(statusForAction.reblogsCount)", systemImage: "repeat")
                    .foregroundColor(statusForAction.reblogged ? .green : .primary)
            }.padding(.trailing, 5)

            Button {

            } label: {
                Label("\(statusForAction.favouritesCount)", systemImage: "star")
                    .foregroundColor(statusForAction.favourited ? .green : .primary)
            }.padding(.trailing, 5)

            Button {

            } label: {
                Image(systemName: "bookmark")
                    .foregroundColor(statusForAction.bookmarked ? .green : .primary)
            }.padding(.trailing, 5)
            
            Spacer()

            if let app = statusForAction.application {
                Link(app.name, destination: app.website!)
                    .font(.footnote)
            }
        }
        .buttonStyle(.borderless)
    }

    @ObservedObject
    var persistedStatus: PersistedStatus


    // MARK: - Private Properties

    var statusForAction: PersistedStatus {
        if let reblog = persistedStatus.reblog {
            return reblog
        }

        return persistedStatus
    }
}
