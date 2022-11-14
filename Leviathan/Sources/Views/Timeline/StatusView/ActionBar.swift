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

            }.padding(.trailing, 5)

            Button {
                boost(status)
            } label: {
                Label("\(status.reblogsCount)", systemImage: "repeat")
                    .foregroundColor(status.reblogged ? .green : .primary)
            }.padding(.trailing, 5)
            Button {

            } label: {
                Label("\(status.favouritesCount)", systemImage: "star")
            }.padding(.trailing, 5)
            
            Spacer()

            if let app = status.application {
                Link(app.name, destination: app.website!)
                    .font(.footnote)
            }
        }
        .buttonStyle(.borderless)
    }

    @ObservedObject
    var persistedStatus: PersistedStatus
    @State
    var status: Status
    var statusOperations: StatusOperationProvider


    // MARK: - Actions

    private func boost(_ status: Status) {
        Task {
            do {
                if status.reblogged {
                    try await statusOperations.unboost(status: status)
                } else {
                    try await statusOperations.boost(status: status)
                }

                try await refreshStatus(persistedStatus)

                update {
                    if let reblog = persistedStatus.status?.reblog {
                        self.status = reblog
                    } else {
                        self.status = persistedStatus.status!
                    }
                }
            } catch {
                ToastView.Toast(
                    type: .error,
                    message: "Boosting the status didn't succeed. Please try again!",
                    error: error)
                .show()
            }
        }
    }

    private func refreshStatus(_ persistedStatus: PersistedStatus) async throws {
        // TODO: Implement this method
        try await statusOperations.refreshStatus(persistedStatus)
    }
}
