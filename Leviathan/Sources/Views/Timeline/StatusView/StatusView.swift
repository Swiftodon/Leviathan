//
//  StatusView.swift
//  Leviathan
//
//  Created by Thomas Bonk on 04.11.22.
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
import QuickLook
import WebView

struct StatusView: View {
    
    // MARK: - Public Properties
    
    var body: some View {
        VStack(alignment: .leading) {
            RebloggedHeader(persistedStatus: persistedStatus)
            StatusContent(persistedStatus: persistedStatus)
            ActionBar(persistedStatus: persistedStatus)
            #if os(macOS)
            Divider().padding(.bottom, 2)
            #endif
        }
        .padding(.all, 5)
    }

    @ObservedObject
    var persistedStatus: PersistedStatus
}
