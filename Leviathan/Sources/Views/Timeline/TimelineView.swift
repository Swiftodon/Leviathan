//
//  TimelineView.swift
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

import Combine
import MastodonSwift
import SwiftUI

struct TimelineView: View {
    
    // MARK: - Public Properties
    
    var body: some View {
        Header(title: title) {
            List {
                ForEach(persistedStatuses, id: \.statusId) { status in
                    StatusView(status: status.status!, statusOperations: model)
                }
            }
            .refreshable(action: refresh)
            .toolbar {
                ToolbarItem(placement: .navigation) {
                    if model.isLoading {
                        ProgressView()
                            // TODO: This is ugly; is there a better way have the same size as the button?
                            .scaleEffect(0.5)
                            .padding(.horizontal, -4)
                    } else {
                        Button { refreshInTask() } label: { Image(systemName: "arrow.clockwise") }
                            .buttonStyle(.borderless)
                            .padding(.horizontal, 5)
                    }
                }
            }
            .onAppear(perform: appearing)
            .onDisappear(perform: disappearing)
        }
    }
    
    var title: LocalizedStringKey
    @ObservedObject
    var model: TimelineModel
    
    
    // MARK: - Initialization
    
    init(title: LocalizedStringKey, model: TimelineModel) {
        self.title = title
        self.model = model
        self._persistedStatuses =
            FetchRequest<PersistedStatus>(sortDescriptors: model.sortDescriptors, predicate: model.readFilter())
    }
    
    
    // MARK: - Private Properties
    
    @FetchRequest
    private var persistedStatuses: FetchedResults<PersistedStatus>
    @EnvironmentObject
    private var accountModel: AccountModel
    @State
    private var reloadCancellable: AnyCancellable!
    
    
    // MARK: - Private Methods
    
    private mutating func do__() {
        self._persistedStatuses =
            FetchRequest<PersistedStatus>(sortDescriptors: model.sortDescriptors, predicate: model.readFilter())
    }
    
    private func appearing() {
        reloadCancellable = accountModel.objectWillChange.sink { _ in
            update {
                guard accountModel.currentAccount != nil else {
                    return
                }
                persistedStatuses.nsPredicate = model.readFilter()
                refreshInTask()
            }
        }
        
        if accountModel.currentAccount == nil && !accountModel.accounts.isEmpty {
            accountModel.currentAccount = accountModel.accounts[0]
        }
    }
    
    private func disappearing() {
        reloadCancellable.cancel()
    }
    
    private func refreshInTask() {
        Task {
            await refresh()
        }
    }
    
    @Sendable
    private func refresh() async {
        do {
            if let _ = AccountModel.shared.auth {
                try await model.readTimeline()
            } else {
                ToastView.Toast(type: .warning, message: "You are not logged in. Can't update your timeline.").show()
            }
        } catch {
            ToastView.Toast(type: .error, message: "An error occured while loading your timeline.", error: error).show()
        }
    }
}

struct TimelineView_Previews: PreviewProvider {
    static var previews: some View {
        TimelineView(title: "Timeline", model: TimelineModel())
    }
}
