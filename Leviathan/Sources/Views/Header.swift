//
//  Header.swift
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

struct Header<Content>: View where Content: View {
    
    // MARK: - Public Properties
    
    var body: some View {
        NavigationStack {
            content()
                .navigationTitle(title)
                .navigationBarTitleDisplayMode(NavigationBarItem.TitleDisplayMode.inline)
                .toolbar {
                    ToolbarItem(placement: .navigation) {
                        Menu {
                            if sessionModel.sessions.isEmpty {
                                Text("No sessions connected")
                            } else {
                                ForEach(sessionModel.sessions, id: \.id) { session in
                                    Button {
                                        sessionModel.select(session: session)
                                    } label: {
                                        Text(session.account.displayName!)
                                    }
                                }
                            }
                        } label: {
                            // TODO: Use the image of the user here
                            Image(systemName: "person.circle")
                                .resizable()
                                .frame(width: 24, height: 24)
                        }
                        .buttonStyle(.borderless)
                    }
                }
        }
    }
    
    var title: LocalizedStringKey
    var content: () -> Content
    
    
    // MARK: - Initialization
    
    init(title: LocalizedStringKey, @ViewBuilder content: @escaping () -> Content) {
        self.title = title
        self.content = content
    }
    
    
    // MARK: - Private Properties
    
    @EnvironmentObject
    private var sessionModel: SessionModel
}

struct Header_Previews: PreviewProvider {
    static var previews: some View {
        Header(title: "Header", content: { Text("Content") })
    }
}
