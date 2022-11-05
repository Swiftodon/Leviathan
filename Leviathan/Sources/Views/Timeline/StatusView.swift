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
            Divider()
        }
        .onTapGesture {
            showActions.toggle()
        }
    }
    
    var status: Status
    
    
    // MARK: - Private Properties
    
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
                Text(status.content.trimHTMLTags()!)
                    .lineLimit(40)
                    .multilineTextAlignment(.leading)
                Spacer()
            }
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
            status.accountImage
            Spacer()
        }
    }
}
