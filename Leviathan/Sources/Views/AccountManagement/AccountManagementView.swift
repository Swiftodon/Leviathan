//
//  AccountManagementView.swift
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

struct AccountManagementView: View {
    
    // MARK: - Public Properties
    
    var body: some View {
        NavigationStack {
            List(selection: $selectedAccount) {
                ForEach(accountModel.accounts, id: \.id) { account in
                    NavigationLink {
                        AccountDetailEditorView(account: account)
                    } label: {
                        AccountItemView(account: account)
                    }
                    .tag(account.id)
                }
            }
            .listStyle(.sidebar)
            .navigationTitle("Accounts")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button { accountModel.add(account: .init()) } label: { Text("Add") }
                }
                ToolbarItem(placement: .destructiveAction) {
                    Button { deleteAccount() } label: { Text("Remove") }.disabled(selectedAccount == nil)
                }
                ToolbarItem(placement: .cancellationAction) {
                    Button { dismiss() } label: { Text("Done") }
                }
            }
        }
        .frame(minWidth: 400, minHeight: 500)
        .onAppear {
            if !accountModel.accounts.isEmpty {
                selectedAccount = accountModel.accounts[0].id
            }
        }
    }
    
    
    // MARK: - Private Properties
    
    @Environment(\.dismiss)
    private var dismiss
    @EnvironmentObject
    private var accountModel: AccountModel
    @State
    private var selectedAccount: UUID?
    
    
    // MARK: - Private Methods
    
    private func deleteAccount() {
        if let selectedAccount {
            if let account = accountModel.accounts.first(where: { $0.id == selectedAccount }) {
                accountModel.remove(account: account)
            }
        }
    }
}

struct AccountManagementView_Previews: PreviewProvider {
    static var previews: some View {
        AccountManagementView()
    }
}
