//
//  PersistedStatus.swift
//  Leviathan
//
//  Created by Thomas Bonk on 06.11.22.
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

extension PersistedStatus: Identifiable, NamedEntity {
    
    // MARK: - Properties
    
    var timeline: TimelineId {
        set {
            self.tl = newValue.rawValue
        }
        get {
            return TimelineId(rawValue: self.tl) ?? .unknown
        }
    }

    var visibility: Status.Visibility {
        set {
            visibility_ = newValue.rawValue
        }
        get {
            Status.Visibility(rawValue: visibility_)!
        }
    }

    var createdAtRelative: String {
        var difference = timestamp.distance(to: Date())

        if difference < 60 {
            return "just now"
        }

        difference = difference / 60
        if difference < 60 {
            return "\(Int(difference)) min ago"
        }

        difference = difference / 60
        if difference < 24 {
            if Int(difference) < 2 {
                return "\(Int(difference)) hour ago"
            } else {
                return "\(Int(difference)) hours ago"
            }
        }

        difference = difference / 24
        return "\(Int(difference)) days ago"
    }


    // MARK: - Static Methods

    static func create(in context: NSManagedObjectContext, from status: Status) throws -> PersistedStatus {
        guard
            let accountId = SessionModel.shared.currentSession?.account.id
        else {
            throw LeviathanError.noUserLoggedOn
        }

        let persistedStatus: PersistedStatus = context.createEntity()

        persistedStatus.loggedOnAccountId = accountId
        
        persistedStatus.statusId = status.id
        persistedStatus.timestamp = status.timestamp
        persistedStatus.uri = status.uri
        persistedStatus.url = status.url
        if let account = status.account {
            persistedStatus.account = try PersistedAccount.create(in: context, from: account)
            persistedStatus.account!.status = persistedStatus
        }
        persistedStatus.inReplyToId = status.inReplyToId
        persistedStatus.inReplyToAccount = status.inReplyToAccount

        if let reblog = status.reblog {
            persistedStatus.reblog = try PersistedStatus.create(in: context, from: reblog)
            persistedStatus.reblog!.reblogParent = persistedStatus
            persistedStatus.reblog!.isReblogChild = true
        }

        persistedStatus.content = status.content
        persistedStatus.createdAt = status.createdAt
        persistedStatus.reblogsCount = Int32(status.reblogsCount)
        persistedStatus.favouritesCount = Int32(status.favouritesCount)
        persistedStatus.reblogged = status.reblogged
        persistedStatus.favourited = status.favourited
        persistedStatus.sensitive = status.sensitive
        persistedStatus.bookmarked = status.bookmarked
        persistedStatus.pinned = status.pinned
        persistedStatus.muted = status.muted
        persistedStatus.spoilerText = status.spoilerText
        persistedStatus.visibility = status.visibility

        try status.mediaAttachments.forEach { attachment in
            let attachmnt = try PersistedAttachment.create(in: context, from: attachment)

            attachmnt.status = persistedStatus
            persistedStatus.addToMediaAttachments(attachmnt)
        }

        if let card = status.card {
            persistedStatus.card = try PersistedCard.create(in: context, from: card)
            persistedStatus.card?.status = persistedStatus
        }

        try status.mentions.forEach { mention in
            let mntn = try PersistedMention.create(in: context, from: mention)

            mntn.status = persistedStatus
            persistedStatus.addToMentions(mntn)
        }

        try status.tags.forEach { tag in
            let tg = try PersistedTag.create(in: context, from: tag)

            tg.status = persistedStatus
            persistedStatus.addToTags(tg)
        }

        if let app = status.application {
            persistedStatus.application = try PersistedApplication.create(in: context, from: app)
            persistedStatus.application?.status = persistedStatus
        }

        return persistedStatus
    }
}
