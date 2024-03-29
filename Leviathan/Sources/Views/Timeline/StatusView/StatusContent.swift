//
//  StatusContent.swift
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

import SwiftUI

struct StatusContent: View {

    // MARK: - Public Properties

    var body: some View {
        VStack {
            StatusHeader(persistedStatus: statusForDisplay)

            If(statusForDisplay.sensitive) {
                spoilerView()
            }

            If(!statusForDisplay.sensitive || revealed) {
                statusContent()
            }
        }
    }

    @State
    var persistedStatus: PersistedStatus


    // MARK: Private Properties

    @State
    private var revealed = false

    var statusForDisplay: PersistedStatus {
        if let reblog = persistedStatus.reblog {
            return reblog
        }

        return persistedStatus
    }

    var attachments: [PersistedAttachment] {
        if let attmnts = statusForDisplay.mediaAttachments {
            return Array(attmnts)
        }

        return []
    }

    var revealedButtonText: LocalizedStringKey {
        revealed ? "Hide" : "Show"
    }


    // MARK: - Private Methods

    @ViewBuilder
    private func statusContent() -> some View {
        VStack(alignment: .leading) {
            HStack(alignment: .top) {
                Text(statusForDisplay.content.attributedString!)
                    .lineLimit(40)
                    .multilineTextAlignment(.leading)
                Spacer()
            }

            If(!attachments.isEmpty) {
                MediaPreview(attachments: attachments)
            }

            If(statusForDisplay.card != nil) {
                CardView(card: statusForDisplay.card!)
            }
        }
    }

    @ViewBuilder
    private func spoilerView() -> some View {
        VStack {
            HStack(alignment: .top) {
                Text(statusForDisplay.spoilerText!.attributedString!)
                    .lineLimit(40)
                    .multilineTextAlignment(.leading)
                Spacer()
            }

            Button {
                revealed.toggle()
            } label: {
                Text(revealedButtonText)
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
        }
    }
}
