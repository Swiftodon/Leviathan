//
//  Card.swift
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

struct CardView: View {

    // MARK: - Public Properties
    
    var body: some View {
        cardView()
            .padding(.all, 8)
            .background(Color.backgroundColor)
            .clipShape(RoundedRectangle(cornerRadius: 8))
    }

    @ObservedObject
    var card: PersistedCard


    // MARK: - Private Methods

    @ViewBuilder
    private func cardView() -> some View {
        switch card.type {
            case .link:
                LinkCard(card: card)

            case .video:
                // TODO: Implement dedicated card
                LinkCard(card: card)

            case .photo:
                // TODO: Implement dedicated card
                LinkCard(card: card)

            default:
                notSupported(type: card.type)
        }
    }

    @ViewBuilder
    private func linkCard() -> some View {
        HStack(alignment: .top) {
            if let image = card.image {
                AsyncImage(url: URL(string: image)) { image in
                    image.resizable()
                } placeholder: {
                    ProgressView()
                }
                .frame(width: 64, height: 64)
                .cornerRadius(8)
            }

            VStack(alignment: .leading) {
                Text(card.title)
                    .font(.headline)
                Text(card.description)
                    .font(.subheadline)
                Link(card.url.host()!, destination: card.url)
                    .font(.footnote)
            }
        }
    }

    @ViewBuilder
    private func notSupported(type: MastodonSwift.Card.CardType) -> some View {
        HStack(alignment: .top) {
            Spacer()

            VStack(alignment: .center) {
                Text("Preview for card type '\(type.rawValue)' is not supported!")
                    .italic()
                Link(card.url.host()!, destination: card.url)
                    .font(.footnote)
            }

            Spacer()
        }
    }
}

struct LinkCard: View {

    // MARK: - Public Properties

    var body: some View {
        HStack(alignment: .top) {
            if let image = card.image {
                AsyncImage(url: URL(string: image)) { image in
                    image.resizable()
                } placeholder: {
                    ProgressView()
                }
                .frame(width: 64, height: 64)
                .cornerRadius(8)
            }

            VStack(alignment: .leading) {
                Text(card.title)
                    .font(.headline)
                Text(card.descr)
                    .font(.subheadline)
                Link(card.url.host()!, destination: card.url)
                    .font(.footnote)
            }
        }
    }

    @ObservedObject
    var card: PersistedCard
}

