//
//  PersistedAttachment.swift
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

extension PersistedAttachment: Identifiable, NamedEntity {

    // MARK: - Public Properties

    var type: Attachment.AttachmentType {
        set {
            type_ = newValue.rawValue
        }
        get {
            Attachment.AttachmentType(rawValue: type_)!
        }
    }

    // MARK: - Static Methods

    static func create(in context: NSManagedObjectContext, from attachment: Attachment) throws -> PersistedAttachment {
        guard
            let accountId = SessionModel.shared.currentSession?.account.id
        else {
            throw LeviathanError.noUserLoggedOn
        }
        
        let persistedAttachment: PersistedAttachment = context.createEntity()
        
        persistedAttachment.loggedOnAccountId = accountId

        persistedAttachment.attachmentId = attachment.id
        persistedAttachment.type = attachment.type
        persistedAttachment.url = attachment.url
        persistedAttachment.previewUrl = attachment.previewUrl

        persistedAttachment.remoteUrl = attachment.remoteUrl
        persistedAttachment.descr = attachment.description
        persistedAttachment.blurhash = attachment.blurhash
        
        return persistedAttachment
    }

}
