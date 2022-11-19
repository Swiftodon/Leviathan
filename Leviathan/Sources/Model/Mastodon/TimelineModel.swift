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
    @Published
    public var marker: Markers? = nil
    
    public var timelineId: TimelineId { TimelineId.home }
    public var sortDescriptors: [NSSortDescriptor] { [NSSortDescriptor(key: "timestamp", ascending: false)] }

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
    
    
    // MARK: - Private Properties

    private var context: NSManagedObjectContext
    private var lastStatusIdFetchRequest: NSFetchRequest<PersistedStatus> {
        let request = PersistedStatus.makeFetchRequest() // NSFetchRequest<PersistedStatus>(entityName: PersistedStatus.entityName)
        request.predicate = readFilter()
        request.sortDescriptors = sortDescriptors
        
        return request
    }
    private var lastUpdated: TimeInterval? = nil
    private var canUpdate: Bool {
        let now = Date().timeIntervalSinceReferenceDate

        if let lastUpdated {
            if now - lastUpdated > 60 {
                self.lastUpdated = now
                return true
            }
            else {
                return false
            }
        }

        lastUpdated = now
        return true
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

    func store(marker: StatusId?) {
        guard
            let statusId = marker
        else {
            return
        }

        guard
            let auth = SessionModel.shared.currentSession?.auth
        else {
            return
        }

        guard
            timelineId == .home
        else {
            return
        }

        Task {
            _ = try await auth.saveMarkers([.home : statusId])
            loadMarker()
        }
    }

    func loadMarker() {
        guard
            let auth = SessionModel.shared.currentSession?.auth
        else {
            return
        }

        guard
            timelineId == .home
        else {
            return
        }

        let waiter = DispatchGroup()
        waiter.enter()
        Task {
            let mrkr = try await auth.readMarkers([.home])

            update {
                self.marker = mrkr
            }

            waiter.leave()
        }
        waiter.wait()
    }
    
    func readTimeline() throws {
        guard
            let _ = SessionModel.shared.currentSession?.auth
        else {
            throw LeviathanError.noUserLoggedOn
        }

        guard
            canUpdate
        else
        {
            ToastView
                .Toast(type: .info, message: "You are all caught-up!")
                .show()
            return
        }

        let backgroundContext = PersistenceController.shared.container.newBackgroundContext()

        backgroundContext.perform {
            Task {
                update { self.isLoading = true }
                defer {
                    update { self.isLoading = false }
                }
                if let timeline = try await self.retrieveTimeline() {
                    if timeline.isEmpty {
                        ToastView
                            .Toast(type: .info, message: "You are all caught-up!")
                            .show()
                    } else {
                        try self.persist(timeline: timeline, context: self.context)
                    }
                }
            }
        }
    }
    
    
    // MARK: - Methods for internal usage

    func retrieveTimeline() async throws -> [Status]? {
        return try await SessionModel.shared.currentSession?.auth?.getHomeTimeline(minId: lastStatusId, limit: 200)
    }
    
    func persist(timeline: [MastodonSwift.Status], context: NSManagedObjectContext) throws {
        guard !timeline.isEmpty else {
            return
        }

        try timeline.forEach { status in
            let persistedStatus = try PersistedStatus.create(in: context, from: status)

            persistedStatus.timeline = self.timelineId
        }

        try self.context.save()
    }
}
