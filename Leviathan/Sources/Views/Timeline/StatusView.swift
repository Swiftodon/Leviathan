//
//  StatusView.swift
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

import MastodonSwift
import SwiftUI

struct StatusView: View {
    
    // MARK: - Public Properties
    
    var body: some View {
        VStack {
            rebloggedHeader()
            statusContent(status.reblog != nil ? status.reblog! : status)
            actionBar(status.reblog != nil ? status.reblog! : status)
            Divider().padding(.bottom, 2)
        }
        .padding(.all, 5)
        .background(backgroundColor)
        .cornerRadius(10)
        .onTapGesture {
            showActions.toggle()
        }
    }
    
    var persistedStatus: PersistedStatus
    var statusOperations: StatusOperationProvider
    
    
    // MARK: - Private Properties

    var status: Status {
        return persistedStatus.status!
    }
    
    @State
    private var showActions = false
    
    private var statusUsername: String {
        if let name = status.account?.displayName {
            return name
        }
        if let name = status.account?.username {
            return "@\(name)"
        }
        
        return "Unknown"
    }
    
    private var backgroundColor: Color {
        return showActions ? Color.secondaryBackgroundColor : Color.clear
    }
    
    
    // MARK: - Private Methods
    
    @ViewBuilder
    private func rebloggedHeader() -> some View {
        if status.reblog != nil {
            HStack {
                Label("\(statusUsername) boosted \(status.createdAtRelative)", systemImage: "repeat")
                    .foregroundColor(.secondary)
                Spacer()
            }
        } else {
            EmptyView()
        }
    }
    
    private func statusContent(_ status: Status) -> some View {
        VStack {
            statusHeader(status)
            HStack {
                Text(status.content.attributedString!)
                    .lineLimit(40)
                    .multilineTextAlignment(.leading)
                Spacer()
            }
        }
    }
    
    @ViewBuilder
    private func actionBar(_ status: Status) -> some View {
        if showActions {
            HStack {
                Button { } label: { Image(systemName: "bubble.right") }
                    .padding(.trailing, 5)
                Button {
                    boost(status)
                } label: {
                    Label("\(status.reblogsCount)", systemImage: "repeat")
                        .foregroundColor(status.reblogged ? .green : .primary)
                }
                .padding(.trailing, 5)
                Button {} label: { Label("\(status.favouritesCount)", systemImage: "star") }
                    .padding(.trailing, 5)
                Spacer()
            }
            .buttonStyle(.borderless)
        } else {
            EmptyView()
        }
    }
    
    private func statusHeader(_ status: Status) -> some View {
        LazyVGrid(columns: [GridItem(.fixed(32), alignment: .topLeading), GridItem(alignment: .topLeading)]) {
            accountImage(status)
            LazyVGrid(columns: [GridItem(alignment: .topLeading)]) {
                Text(status.account?.displayName ?? (status.account?.username ?? "Unknown"))
                    .font(.body)
                HStack {
                    Text("@\(status.account?.acct ?? "Unknown")")
                    Text("·")
                    Text(status.createdAtRelative)
                    Spacer()
                }
                .foregroundColor(.secondary)
            }
            .font(.footnote)
        }
    }
    
    private func accountImage(_ status: Status) -> some View {
        VStack {
            AccountAvatar(account: status.account!)
            Spacer()
        }
    }
    
    
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
