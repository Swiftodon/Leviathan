//
//  PersistedTag.swift
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

extension PersistedTag: Identifiable, NamedEntity {

    // MARK: - Static Methods

    static func create(in context: NSManagedObjectContext, from tag: Tag) throws -> PersistedTag {
        guard
            let accountId = SessionModel.shared.currentSession?.account.id
        else {
            throw LeviathanError.noUserLoggedOn
        }

        let persistedTag: PersistedTag = context.createEntity()

        persistedTag.loggedOnAccountId = accountId
        
        persistedTag.name = tag.name
        persistedTag.url = tag.url

        return persistedTag
    }

}
