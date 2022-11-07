//
//  AccountAvatar.swift
//  Leviathan
//
//  Created by Marcus Kida on 07.11.22.
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

struct AccountAvatar: View {
    
    let status: Status
    
    @State private var accountAvatar: Image?
    
    var body: some View {
        ZStack {
            if let accountAvatar = accountAvatar {
                accountAvatar
                    .resizable()
                    .frame(width: 32, height: 32)
            } else {
                Image(systemName: "person.circle")
                    .resizable()
                    .frame(width: 32, height: 32)
            }
        }
        .onAppear {
            Task {
                guard
                    let avatarUrl = status.account?.avatar,
                    let (data, _) = try? await URLSession.shared.data(from: avatarUrl)
                else {
                    return
                }
                
                #if os(macOS)
                guard let image = NSImage(data: data) else { return }
                accountAvatar = Image(nsImage: image)
                #elseif os(iOS)
                guard let image = UIImage(data: data) else { return }
                accountAvatar = Image(uiImage: image)
                #endif
            }
        }
    }
}
