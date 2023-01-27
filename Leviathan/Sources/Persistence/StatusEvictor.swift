//
//  StatusEvictor.swift
//  Leviathan
//
//  Created by Thomas Bonk on 24.01.23.
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

class StatusEvictor: ObservableObject {

    // MARK: - Private Properties

    private var timer: Timer!

    // MARK: - Initialization

    init() {
        self.timer = Timer.scheduledTimer(withTimeInterval: 360, repeats: true, block: { _ in
            self.evictStatuses()
        })
        mainAsync {
            self.timer.fire()
        }
    }


    // MARK: - Public Methods

    func evictStatuses() {
        Task {
            // TODO: Make retention period configurable per account
            let evictionTimestamp = Calendar.current.date(byAdding: .day, value: -5, to: Date())!
            let backgroundContext = PersistenceController.shared.container.newBackgroundContext()

            try SessionModel.shared.sessions.forEach { session in
                let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: PersistedStatus.entityName)
                fetchRequest.predicate = NSCompoundPredicate(
                    andPredicateWithSubpredicates: [
                        NSPredicate(format: "loggedOnAccountId == %@", session.account.id),
                        NSPredicate(format: "timestamp < %@", argumentArray: [evictionTimestamp])
                    ])
                // Create a batch delete request for the fetch request
                let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
                // Specify the result of the NSBatchDeleteRequest; should be the NSManagedObject IDs for the
                // deleted objects
                deleteRequest.resultType = .resultTypeObjectIDs
                // Perform the batch delete
                let batchDelete = try backgroundContext.execute(deleteRequest) as? NSBatchDeleteResult

                guard
                    let deleteResult = batchDelete?.result as? [NSManagedObjectID]
                else {
                    return
                }

                let deletedObjects: [AnyHashable: Any] = [
                    NSDeletedObjectsKey: deleteResult
                ]

                // Merge the delete changes into the managed object context
                NSManagedObjectContext.mergeChanges(
                    fromRemoteContextSave: deletedObjects,
                    into: [backgroundContext]
                )
            }
        }
    }
}
