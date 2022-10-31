//
//  ContentView.swift
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

import MultiplatformTabBar
import SwiftUI

struct ContentView: View {
  
  // MARK: - Public Properties
  
  var body: some View {
    MultiplatformTabBar(tabPosition: .bottom, barHorizontalAlignment: .center)
      .tab(title: "Timeline", icon: Image(systemName: "clock")) {
        TimelineView(title: "Timeline", model: timelineModel)
      }
      .tab(title: "Local", icon: Image(systemName: "location.circle")) {
        TimelineView(title: "Local Timeline", model: localTimelineModel)
      }
      .tab(title: "Federated", icon: Image(systemName: "globe")) {
        TimelineView(title: "Federated Timeline", model: federatedTimelineModel)
      }
      .tab(title: "Notifications", icon: Image(systemName: "bell.circle")) {
        NotificationsView(model: notificationsModel)
      }
  }
  
  
  // MARK: - Private Properties
  
  @EnvironmentObject
  private var timelineModel: TimelineModel
  @EnvironmentObject
  private var localTimelineModel: LocalTimelineModel
  @EnvironmentObject
  private var federatedTimelineModel: FederatedTimelineModel
  @EnvironmentObject
  private var notificationsModel: NotificationsModel
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
      .environmentObject(TimelineModel())
      .environmentObject(LocalTimelineModel())
      .environmentObject(FederatedTimelineModel())
      .environmentObject(NotificationsModel())
  }
}
