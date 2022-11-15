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
import QuickLook
import WebView

fileprivate extension LocalizedStringKey {
    
}

struct StatusView: View {
    
    // MARK: - Public Properties
    
    var body: some View {
        VStack(alignment: .leading) {
            RebloggedHeader(status: status)
            StatusContent(persistedStatus: persistedStatus)
            ActionBar(
                persistedStatus: persistedStatus,
                status: status.reblog != nil ? status.reblog! : status)
            Divider().padding(.bottom, 2)
        }
        .padding(.all, 5)
    }

    @ObservedObject
    var persistedStatus: PersistedStatus
    
    
    // MARK: - Private Properties

    @State
    private var revealed = false
    @State
    private var previewUrl: URL?

    var status: Status {
        return persistedStatus.status!
    }
    
    
    // MARK: - Private Methods

    @ViewBuilder
    private func statusContent(_ status: Status) -> some View {
        VStack {
            statusHeader(status)
            if status.sensitive {
                VStack {
                    HStack {
                        Text(status.spoilerText!.attributedString!)
                            .lineLimit(40)
                            .multilineTextAlignment(.leading)
                        Spacer()
                    }

                    Button {
                        revealed.toggle()
                    } label: {
                        Text(revealed ? "Hide" : "Show")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.borderedProminent)
                }
            }

            if !status.sensitive || revealed {
                VStack {
                    HStack {
                        Text(status.content.attributedString!)
                            .lineLimit(40)
                            .multilineTextAlignment(.leading)
                        Spacer()
                    }

                    media(status)
                    card(status)
                }
            }
        }
    }

    @ViewBuilder
    private func media(_ status: Status) -> some View {
        if !status.mediaAttachments.isEmpty {
            dynamicMediaLayout(status.mediaAttachments)
        } else {
            EmptyView()
        }
    }

    @ViewBuilder
    private func dynamicMediaLayout(_ attachments: [Attachment]) -> some View {
        if attachments.count == 1 {
            mediaPreview(attachments[0], height: 240)
                .onTapGesture {
                    previewUrl = attachments[0].url
                }
                .quickLookPreview($previewUrl)
        } else {
            LazyVGrid(columns: [.init(alignment: .center), .init(alignment: .center)]) {
                ForEach(attachments, id: \.id) { medium in
                    mediaPreview(medium, height: 120)
                        .onTapGesture {
                            previewUrl = medium.url
                        }
                        .quickLookPreview($previewUrl)
                }
            }
        }
    }

    @ViewBuilder
    private func mediaPreview(_ medium: Attachment, height: CGFloat) -> some View {
        switch medium.type {
            case .image:
                imagePreview(medium, height: height)
            case .unknown:
                Text("Media type not supported")
            case .gifv:
                gifvPreview(medium, height: height)
            case .video:
                videoPreview(medium, height: height)
            case .audio:
                audioPreview(medium, height: height)
        }
    }

    @ViewBuilder
    private func imagePreview(_ medium: Attachment, height: CGFloat) -> some View {
        AsyncImage(url: medium.url) { image in
            image
                .centerCropped()
                .frame(height: height)
                .cornerRadius(5)
        } placeholder: {
            Text("Loading...")
        }
    }

    private func gifvPreview(_ medium: Attachment, height: CGFloat) -> some View {
        AsyncImage(url: medium.previewUrl) { image in
            image
                .centerCropped()
                .frame(height: height)
                .cornerRadius(5)
        } placeholder: {
            Text("Loading...")
        }
    }

    private func videoPreview(_ medium: Attachment, height: CGFloat) -> some View {
        AsyncImage(url: medium.previewUrl) { image in
            image
                .centerCropped()
                .frame(height: height)
                .cornerRadius(5)
        } placeholder: {
            Text("Loading...")
        }
    }

    private func audioPreview(_ medium: Attachment, height: CGFloat) -> some View {
        AsyncImage(url: medium.previewUrl) { image in
            image
                .centerCropped()
                .frame(height: height)
                .cornerRadius(5)
        } placeholder: {
            Image(systemName: "speaker.circle")
                .resizable()
                .frame(width: 48, height: 48)
        }
    }

    @ViewBuilder
    private func card(_ status: Status) -> some View {
        if let card = status.card {
            EmptyView()
        } else {
            EmptyView()
        }
    }

    @ViewBuilder
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
                    //Text(visibilityImage[status.visibility]!)
                    Spacer()
                }
                .foregroundColor(.secondary)
            }
            .font(.footnote)
        }
    }

    @ViewBuilder
    private func accountImage(_ status: Status) -> some View {
        VStack {
            AccountAvatar(account: status.account!)
            Spacer()
        }
    }
    
    
    
}
