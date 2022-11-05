//
//  AccountDetailEditorView.swift
//  Leviathan
//
//  Created by Thomas Bonk on 02.11.22.
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

struct AccountDetailEditorView: View {
    
    // MARK: - Public Properties
    
    var body: some View {
        VStack {
            Form {
                TextField("Account Name:", text: $account.name, prompt: Text("Account Name"))
                    .keyboardType(.default)
                    .fixedSize()
                TextField("Mastodon Server URL:", text: $account.serverUrl, prompt: Text("Mastodon Server URL"))
                    .keyboardType(.URL)
                    .fixedSize()
                TextField("Email:", text: $account.email, prompt: Text("Email Address"))
                    .keyboardType(.emailAddress)
                    .fixedSize()
                SecureField("Password", text: $account.password, prompt: Text("Password"))
                    .keyboardType(.default)
            }
            Spacer()
        }
        .padding()
        .navigationTitle(account.name)
        .navigationBarTitleDisplayMode(NavigationBarItem.TitleDisplayMode.inline)
        .toolbar {
            if let _ = account.accessToken {
                Button(action: disconnect, label: { Text("Disconnect") })
            } else {
                Button(action: connect, label: { Text("Connect") })
            }
        }
    }
    
    @ObservedObject
    var account: AccountModel.Account
    
    
    // MARK: - Private Methods
    
    private func connect() {
        Task {
            do {
                try await account.connect()
            } catch {
                Alert(type: .error(error), message: "Can't authenticate you!").show()
            }
        }
    }
    
    private func disconnect() {
        Task {
            account.disconnect()
        }
    }
}

struct AccountDetailEditorView_Previews: PreviewProvider {
    static var previews: some View {
        AccountDetailEditorView(account: .init())
    }
}
