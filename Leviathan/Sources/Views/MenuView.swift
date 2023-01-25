//
//  MenuView.swift
//  Leviathan
//
//  Created by Thomas Bonk on 12.11.22.
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

struct MenuView: View {

    // MARK: - Public Properties

    var body: some View {
        VStack {
            HStack {
                Button {
                    presentationMode.wrappedValue.dismiss()
                } label: {
                    Image(systemName: "xmark.circle.fill")
                }
                .buttonStyle(.borderless)
                Text("Menu").bold()
                Spacer()
            }
            .padding(.all, 10)

            NavigationStack {
                List {
                    Section("Sessions") {
                        NavigationLink {
                            LogonView {
                                presentationMode.wrappedValue.dismiss()
                            }
                            .navigationTitle("Logon")
                        } label: {
                            HStack {
                                Image(systemName: "plus.circle")
                                    .resizable()
                                    .frame(width: 24, height: 24)
                                    .foregroundColor(.green)
                                Text("Add")
                            }
                        }
                        .padding([.horizontal, .top], 5)
                        .padding(.bottom, 10)

                        ForEach(sessionModel.sessions, id: \.id) { session in
                            HStack {
                                AccountAvatar(account: session.account)
                                Text(session.account.displayName!)
                                Spacer()
                                Button {
                                    sessionModel.remove(session: session)
                                    // TODO: Delete all data from database
                                } label: {
                                    Image(systemName: "rectangle.portrait.and.arrow.right")
                                        .foregroundColor(.red)
                                }
                                .buttonStyle(.borderless)
                            }
                            .onTapGesture {
                                sessionModel.select(session: session)
                                presentationMode.wrappedValue.dismiss()
                            }
                            .padding(.all, 5)
                        }
                    }
                }
                .listStyle(.inset)
            }
        }
    }


    // MARK: - Private Properties

    @Environment(\.presentationMode)
    private var presentationMode: Binding<PresentationMode>
    @EnvironmentObject
    private var sessionModel: SessionModel
}

struct MenuView_Previews: PreviewProvider {
    static var previews: some View {
        MenuView()
    }
}
