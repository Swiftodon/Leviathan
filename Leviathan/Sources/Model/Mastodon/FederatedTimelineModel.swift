//
//  FederatedTimelineModel.swift
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


import Foundation

class FederatedTimelineModel: TimelineModel {
    
    // MARK: - Public Properties
    
    public override var timelineId: TimelineId { TimelineId.federated }

    
    // MARK: - Public Methods
  
    override func readTimeline() async throws {
        guard let timeline = try await SessionModel.shared.currentSession?.auth?.getPublicTimeline(isLocal: false) else {
            return
        }
    }
}
