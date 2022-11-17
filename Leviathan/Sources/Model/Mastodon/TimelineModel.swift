//
//  TimelineModel.swift
//  Leviathan
//
//  Created by Thomas Bonk on 31.10.22.
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

class TimelineModel: ObservableObject {
    
    // MARK: - Public Properties

    @Published
    public var isLoading = false
    
    public var timelineId: TimelineId { TimelineId.home }
    public var sortDescriptors: [NSSortDescriptor] { [NSSortDescriptor(key: "timestamp", ascending: false)] }
    
    
    // MARK: - Private Properties

    private var context: NSManagedObjectContext
    private var lastStatusIdFetchRequest: NSFetchRequest<PersistedStatus> {
        let request = PersistedStatus.makeFetchRequest() // NSFetchRequest<PersistedStatus>(entityName: PersistedStatus.entityName)
        request.predicate = readFilter()
        request.sortDescriptors = sortDescriptors
        
        return request
    }
    var lastStatusId: String? {
        do {
            let result = try context.fetch(lastStatusIdFetchRequest)
            if result.count > 0 {
                return result[0].statusId
            }
        } catch {
            NSLog("\(error)")
        }
        
        return nil
    }
    
    
    // MARK: - Initialization
    
    init() {
        context = PersistenceController.shared.container.viewContext
    }

    
    // MARK: - Public Methods
    
    func readFilter() -> NSPredicate {
        let accountId = SessionModel.shared.currentSession?.account.id
        
        return NSPredicate(
            format: "tl == %d AND loggedOnAccountId == %@ AND isReblogChild == false",
            timelineId.rawValue,
            accountId ?? 0)
    }

    func retrieveTimeline() async throws -> [Status]? {
        return try await SessionModel.shared.currentSession?.auth?.getHomeTimeline(sinceId: lastStatusId)
    }
    
    func readTimeline() async throws {
        
        defer {
            update { self.isLoading = false }
        }

        guard SessionModel.shared.currentSession != nil else {
            return
        }

        update { self.isLoading = true }

        guard let timeline = try await retrieveTimeline() else {
            return
        }

        persist(timeline: timeline)
    }
    
    
    // MARK: - Methods for internal usage
    
    func persist(timeline: [MastodonSwift.Status]) {
        guard !timeline.isEmpty else {
            return
        }
        
        Task {
            try timeline.forEach { status in
                let persistedStatus = try PersistedStatus.create(in: context, from: status)

                persistedStatus.timeline = self.timelineId
            }
            
            context.perform {
                do {
                    try self.context.save()
                } catch {
                    ToastView.Toast(type: .error, message: "Can't save the new statuses.", error: error).show()
                }
            }
        }
    }
}
