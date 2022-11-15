//
//  MediaPreview.swift
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
import QuickLook
import SwiftUI

struct MediaPreview: View {

    // MARK: - Public Proeprties
    var body: some View {
        dynamicMediaLayout()
    }

    @State
    var attachments: [Attachment]


    // MARK: - Private Properties

    @State
    private var mediumUrl: URL?


    // MARK: - Private Methods

    @ViewBuilder
    private func dynamicMediaLayout() -> some View {
        if attachments.count == 1 {
            mediaPreview(attachments[0], height: 240)
        } else {
            LazyVGrid(columns: [.init(alignment: .center), .init(alignment: .center)]) {
                ForEach(attachments, id: \.id) { medium in
                    mediaPreview(medium, height: 120)
                }
            }
            .padding(.all, 8)
            .background(Color.backgroundColor)
            .clipShape(RoundedRectangle(cornerRadius: 8))
        }
    }

    @ViewBuilder
    private func mediaPreview(_ medium: Attachment, height: CGFloat) -> some View {
        switch medium.type {
            case .image:
                imagePreview(medium, height: height)
            case .unknown:
                Text("Media type not supported")
            default:
                unsupportedPreview(medium)
        }
    }

    @ViewBuilder
    private func imagePreview(_ medium: Attachment, height: CGFloat) -> some View {
        AsyncImage(url: medium.previewUrl!) { image in
            image
                .centerCropped()
                .frame(height: height)
                .cornerRadius(5)
        } placeholder: {
            ProgressView()
        }
        .onTapGesture {
            mediumUrl = medium.url
        }
        .quickLookPreview($mediumUrl)
    }

    @ViewBuilder
    private func unsupportedPreview(_ medium: Attachment) -> some View {
        VStack(alignment: .center) {
            Text("Preview for type '\(medium.type.rawValue)' not supported")
                .lineLimit(3)
                .font(.footnote)
            Link(medium.url.host()!, destination: medium.url)
                .font(.footnote)
        }
        .padding(.all, 8)
        .background(Color.backgroundColor)
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }
}
