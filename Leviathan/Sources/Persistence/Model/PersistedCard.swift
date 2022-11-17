//
//  PersistedCard.swift
//  Leviathan
//
//  Created by Thomas Bonk on 17.11.22.
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

import CoreData
import Foundation
import MastodonSwift

extension PersistedCard: Identifiable, NamedEntity {

    // MARK: - Public Properties

    var type: MastodonSwift.Card.CardType {
        set {
            type_ = newValue.rawValue
        }
        get {
            MastodonSwift.Card.CardType(rawValue: type_)!
        }
    }


    // MARK: - Static Methods

    static func create(in context: NSManagedObjectContext, from card: MastodonSwift.Card) throws -> PersistedCard {
        guard
            let accountId = SessionModel.shared.currentSession?.account.id
        else {
            throw LeviathanError.noUserLoggedOn
        }

        let persistedCard: PersistedCard = context.createEntity()

        persistedCard.loggedOnAccountId = accountId

        persistedCard.url = card.url
        persistedCard.title = card.title
        persistedCard.descr = card.description
        persistedCard.type = card.type

        persistedCard.authorName = card.authorName
        persistedCard.authorUrl = card.authorUrl
        persistedCard.providerName = card.providerName
        persistedCard.providerUrl = card.providerUrl
        persistedCard.html = card.html
        persistedCard.width = card.width != nil ? Int32(card.width!) : nil
        persistedCard.height = card.height != nil ? Int32(card.height!) : nil
        persistedCard.image = card.image
        persistedCard.embedUrl = card.embedUrl
        persistedCard.blurhash = card.blurhash

        return persistedCard
    }
}
