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

import MastodonSwift
import Foundation

class TimelineModel: ObservableObject, StatusOperationProvider {
    
    // MARK: - Public Properties
    
    @Published
    public var timeline: [Status] = []
    @Published
    public var isLoading = false
    
    
    // MARK: - Public Methods
    
    func readTimeline() async throws {
        let sinceId: StatusId? = !timeline.isEmpty ? timeline[0].id : nil
        
        update { self.isLoading = true }
        defer {
            update { self.isLoading = false }
        }
        
        guard let timeline = try await AccountModel.shared.auth?.getHomeTimeline(sinceId: sinceId) else {
            self.timeline = []
            return
        }
        
        update { [timeline] in
            if !timeline.isEmpty {
                self.timeline.insert(contentsOf: timeline, at: 0)
            }
        }
    }
    
    
    // MARK: - StatusOperationProvider
    
    func boost(status: MastodonSwift.Status) async throws {
        if let _ = try await status.boost() {
            try await readTimeline()
        }
    }
    
    func unboost(status: MastodonSwift.Status) async throws {
        
    }
}
