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
                model.toggleBoost(status: statusForAction)
            } label: {
                Label("\(statusForAction.reblogsCount)", systemImage: "repeat")
                    .foregroundColor(statusForAction.reblogged ? .green : .primary)
            }.padding(.trailing, 5)

            Button {
                model.toggleFavourite(status: statusForAction)
            } label: {
                Label("\(statusForAction.favouritesCount)", systemImage: "star")
                    .foregroundColor(statusForAction.favourited ? .green : .primary)
            }.padding(.trailing, 5)

            Button {
                model.toggleBookmark(status: statusForAction)
            } label: {
                Image(systemName: "bookmark")
                    .foregroundColor(statusForAction.bookmarked ? .green : .primary)
            }.padding(.trailing, 5)
            
            Spacer()

            If(clientApplication != nil) {
                Alternative(clientApplicationWebsite != nil) {
                    Link(clientApplication!.name, destination: clientApplicationWebsite!)
                } ifFalse: {
                    Text(clientApplication!.name)
                }
            }
            .font(.footnote)
        }
        .buttonStyle(.borderless)
    }


    // MARK: - Initialization

    init(persistedStatus: PersistedStatus) {
        self.persistedStatus = persistedStatus
        if let reblog = persistedStatus.reblog {
            statusForAction = reblog
        } else {
            statusForAction = persistedStatus
        }
    }



    // MARK: - Private Properties

    @EnvironmentObject
    private var model: TimelineModel
    @ObservedObject
    private var persistedStatus: PersistedStatus
    @ObservedObject
    private var statusForAction: PersistedStatus

    private var clientApplication: PersistedApplication? {
        statusForAction.application
    }

    private var clientApplicationWebsite: URL? {
        clientApplication?.website
    }
}
