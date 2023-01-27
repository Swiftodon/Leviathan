//
//  PersistenceController.swift
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

extension NSManagedObjectContext {
    func createEntity<E: NamedEntity>() -> E {
        return NSEntityDescription
            .insertNewObject(
                forEntityName: E.entityName,
                into: self) as! E
    }
}

class PersistenceController {
    
    // MARK: - Properties
    
    static let shared: PersistenceController = { PersistenceController() }()
    
    // TODO: Migrate to NSPersistentCloudKitContainer once we're for release
    //let container: NSPersistentCloudKitContainer
    let container: NSPersistentContainer
    
    
    // MARK: - Initialization
    
    private init() {
        // TODO: Migrate to NSPersistentCloudKitContainer once we're for release
        //container = NSPersistentCloudKitContainer(name: "test")
        container = NSPersistentContainer(name: .ApplicationName)
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                /** TODO: Use another toast package
                ToastView
                    .Toast(
                        type: .fatalError,
                        message: "Can't open database. The app is going to be terminated!",
                        error: error,
                        duration: 0,
                        onDismissed: {
                            fatalError("Can't open database. The app is going to be terminated!\n\(error)\n\(error.userInfo)")
                        })
                    .show()
                 */
            }
        })
        container.viewContext.automaticallyMergesChangesFromParent = true
        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
    }
}
