//
//  LogonView.swift
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

import MastodonSwift
import SwiftUI
import WebView

struct LogonView: View {
    var body: some View {
        ScrollView {
            VStack {
                Text("Please enter the server name of the Mastodon instance, that you wish to logon to.")
                    .lineLimit(5)
                    .multilineTextAlignment(.center)
                    .padding(.bottom, 10)

                Form {
                    TextField("Server Name:", text: $serverName, prompt: Text("Server Name"))
                        .fixedSize()
                        .onChange(of: serverName, perform: loadInstanceInformation(server:))
                }
                .padding(.bottom, 10)

                instanceInformation()

                WebView(webView: webViewStore.webView)
                    .frame(width: 400, height: 300)
                    .padding(.vertical, 10)
                    .cornerRadius(10)

                Spacer()
            }
        }
        .onAppear {
            webViewStore.webView.load(URLRequest(url: URL(string: "https://www.youtube.com/embed/IPSbNdBmWKE")!))
        }
        .padding(.all, 20)
    }

    var completed: (() -> ())? = nil


    // MARK: - Private Properties

    @StateObject
    private var webViewStore = WebViewStore()
    @EnvironmentObject
    private var sessionModel: SessionModel
    @State
    private var serverName: String = ""
    @State
    private var instance: Instance? = nil


    // MARK: - Private Methods

    @ViewBuilder
    private func instanceInformation() -> some View {
        if let instance {
            VStack {
                AsyncImage(
                    url: URL(string: instance.thumbnail!)!,
                    content:{ $0.resizable() },
                    placeholder: { Text("🐘").font(.system(size: 72)) })
                .frame(width: 240, height: 120)
                .cornerRadius(10)

                Text(instance.description!.attributedString!)
                    .lineLimit(50)
                    .multilineTextAlignment(.center)

                Button {
                    logon()
                } label: {
                    Text("Logon")
                        .font(.system(size: 18))
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 8).fill(Color.blue))
                        .frame(width: 250, height: 50)
                }
                .buttonStyle(PlainButtonStyle())

                Spacer()
            }
        } else {
            EmptyView()
        }
    }

    private func logon() {
        sessionModel.logon(instanceURL: URL(string: "https://\(serverName)")!)
        completed?()
    }

    private func loadInstanceInformation(server: String) {
        if let url = URL(string: "https://\(server)") {
            let client = MastodonClient(baseURL: url)

            Task {
                let instance = try? await client.readInstanceInformation()

                update {
                    self.instance = instance
                }
            }
        }
    }
}

struct LogonView_Previews: PreviewProvider {
    static var previews: some View {
        LogonView()
    }
}
