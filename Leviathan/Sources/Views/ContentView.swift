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

import MastodonSwift
import MultiplatformTabBar
import SwiftletUtilities
import SwiftUI

struct ContentView: View {
    
    // MARK: - Public Properties
    
    var body: some View {
        tabBar()
            .tab(icon: Image(systemName: "house.circle")) {
                TimelineView(title: "Home", timeline: .home, model: timelineModel)
            }
            .tab(icon: Image(systemName: "location.circle")) {
                TimelineView(title: "Local Timeline", timeline: .local, model: localTimelineModel)
            }
            .tab(icon: Image(systemName: "globe")) {
                TimelineView(title: "Federated Timeline", timeline: .federated, model: federatedTimelineModel)
            }
            .tab(icon: Image(systemName: "at.circle")) {
                Text("Mentions")
            }
            .tab(icon: Image(systemName: "envelope.circle")) {
                Text("Direct Messages")
            }
            .tab(icon: Image(systemName: "bell.circle")) {
                NotificationsView(model: notificationsModel)
            }
            .onReceive(NotificationCenter.default.publisher(for: .ShowServerConfiguration)) { _ in
                showAccountManagementSheet.toggle()
            }
            .onReceive(NotificationCenter.default.publisher(for: .ShowToast), perform: triggerAlert)
            .sheet(isPresented: $showAccountManagementSheet) { AccountManagementView() }
            .toastView(toast: $currentToast)
    }
    
    
    // MARK: - Private Properties
    
    @State
    private var showAccountManagementSheet = false
    @State
    private var currentToast: ToastView.Toast? = nil
    
    @EnvironmentObject
    private var timelineModel: TimelineModel
    @EnvironmentObject
    private var localTimelineModel: LocalTimelineModel
    @EnvironmentObject
    private var federatedTimelineModel: FederatedTimelineModel
    @EnvironmentObject
    private var notificationsModel: NotificationsModel
    
    
    // MARK: - Private Methods
    
    private func tabBar() -> MultiplatformTabBar {
        if HardwareInformation.isMac || HardwareInformation.isPad {
            return MultiplatformTabBar(tabPosition: .left, barVerticalAlignment: .top)
        } else {
            return MultiplatformTabBar(tabPosition: .bottom, barHorizontalAlignment: .center)
        }
    }
    
    private func triggerAlert(_ notification: Foundation.Notification) {
        currentToast = (notification.object as! ToastView.Toast)
    }
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
