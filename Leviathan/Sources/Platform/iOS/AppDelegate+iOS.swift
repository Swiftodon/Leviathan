//
//  AppDelegate.swift
//  Leviathan
//
//  Created by Thomas Bonk on 11.11.22.
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

#if os(iOS)

import Foundation
import MastodonSwift
import SwiftUI
import UIKit

typealias ApplicationDelegateAdaptor = UIApplicationDelegateAdaptor

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey  : Any] = [:]) -> Bool {
        if url.host == "oauth-callback" {
            MastodonClient.handleOAuthResponse(url: url)
        }
        return true
    }
}

#endif

