//
//  LeviathanApp.swift
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

import MastodonSwift
import SwiftUI

@main
struct LeviathanApp: SwiftUI.App {
    
    // MARK: - Public Properties
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .environmentObject(TimelineModel())
                .environmentObject(LocalTimelineModel())
                .environmentObject(FederatedTimelineModel())
                .environmentObject(NotificationsModel())
                .environmentObject(SessionModel.shared)
                .onOpenURL(perform: handleUrl)
        }
    }

    // MARK: - Private Properties

    private let persistenceController = PersistenceController.shared


    // MARK: - Private Methods

    private func handleUrl(_ url: URL) {
        if url.scheme == "leviathan" {
            handleOauthCallback(url)
        }
    }

    private func handleOauthCallback(_ url: URL) {
        update {
            MastodonClient.handleOAuthResponse(url: url)
        }
    }
}
