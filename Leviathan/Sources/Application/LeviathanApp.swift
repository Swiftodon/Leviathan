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

import SwiftUI
import MastodonSwift

#if os(macOS)
import AppKit
#elseif os(iOS)
import UIKit
#endif

@main
struct LeviathanApp: SwiftUI.App {
    
    #if os(macOS)
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    #elseif os(iOS)
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    #endif
    
    // MARK: - Public Properties
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .environmentObject(TimelineModel())
                .environmentObject(LocalTimelineModel())
                .environmentObject(FederatedTimelineModel())
                .environmentObject(NotificationsModel())
                .environmentObject(AccountModel.shared)
        }
    }
    
    
    // MARK: - Private Properties
    
    private let persistenceController = PersistenceController.shared
}

#if os(macOS)
class AppDelegate: NSObject, NSApplicationDelegate {
    func applicationDidFinishLaunching(_ notification: AppKit.Notification) {
        NSAppleEventManager.shared().setEventHandler(self, andSelector:#selector(AppDelegate.handleGetURL(event:withReplyEvent:)), forEventClass: AEEventClass(kInternetEventClass), andEventID: AEEventID(kAEGetURL))
    }
    
    @objc func handleGetURL(event: NSAppleEventDescriptor!, withReplyEvent: NSAppleEventDescriptor!) {
        let zamazingo = event.paramDescriptor(forKeyword: AEKeyword(keyDirectObject))?.stringValue
        
        if let urlString = event.paramDescriptor(forKeyword: AEKeyword(keyDirectObject))?.stringValue, let url = URL(string: urlString), url.host == "oauth-callback" {
            MastodonClient.handleOAuthResponse(url: url)
        }
    }
}
#elseif os(iOS)
class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey  : Any] = [:]) -> Bool {
      if url.host == "oauth-callback" {
          MastodonClient.handleOAuthResponse(url: url)
      }
      return true
    }
}
#endif
