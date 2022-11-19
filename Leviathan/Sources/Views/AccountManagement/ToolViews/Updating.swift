//
//  Updating.swift
//  Leviathan
//
//  Created by Thomas Bonk on 17.11.22.
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

struct Updating<Content: View>: View {

    // MARK: - Public Properties

    var body: some View {
        content()
            .onAppear {
                guard
                    updateTimer == nil
                else {
                    return
                }

                updateTimer = Timer.scheduledTimer(withTimeInterval: 60, repeats: true, block: { _ in
                    onUpdate()
                })
                updateTimer?.fire()
            }
            .onDisappear {
                updateTimer?.invalidate()
                updateTimer = nil
            }
    }


    // MARK: - Private Properties

    private let interval: TimeInterval
    private let content: () -> Content
    private let onUpdate: () -> ()
    @State
    private var updateTimer: Timer? = nil


    // MARK: - Initialization

    init(
        _ interval: TimeInterval = 60,
           content: @escaping () -> Content,
          onUpdate: @escaping () -> ()) {

        self.interval = interval
        self.onUpdate = onUpdate
        self.content = content
    }
}

