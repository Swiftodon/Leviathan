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

struct Refresher: View {
    @Environment(\.refresh) private var refresh // 1

    var body: some View {
        VStack {
            Text("Refresher")
            if let refresh = refresh { // 2
                Button("Refresh") {
                    Task { await refresh() }
                }
            }
        }
    }
}

struct TimelineView: View {
    
    // MARK: - Public Properties
    
    var body: some View {
        Header(title: title) {
            ScrollViewReader { proxy in
                List {
                    ForEach(persistedStatuses, id: \.statusId) { status in
                        StatusView(persistedStatus: status)
                            .id(status.statusId)
                            .onAppear { statusAppears(status) }
                            .onDisappear { statusDisappears(status) }
                    }
                }
                .onAppear { currentProxy = proxy }
                .refreshable {
                    await asyncRefresh(proxy)
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigation) {
                    if model.isLoading {
                        ProgressView()
                        // TODO: This is ugly; is there a better way have the same size as the button?
                            .scaleEffect(0.5)
                            .padding(.horizontal, -4)
                    } else {
                        Button {
                            refresh(currentProxy)
                        } label: {
                            Image(systemName: "arrow.clockwise")

                        }
                        .buttonStyle(.borderless)
                        .padding(.horizontal, 5)
                    }
                }
            }
            .onAppear { appearing(currentProxy) }
            .onDisappear(perform: disappearing)
        }
    }
    
    var title: LocalizedStringKey
    var timeline: TimelineId
    @ObservedObject
    var model: TimelineModel
    
    
    // MARK: - Initialization
    
    init(title: LocalizedStringKey, timeline: TimelineId, model: TimelineModel) {
        self.title = title
        self.timeline = timeline
        self.model = model
        
        self._persistedStatuses =
        FetchRequest<PersistedStatus>(
            sortDescriptors: model.sortDescriptors,
            predicate: model.readFilter(),
            animation: .easeIn)
    }
    
    
    // MARK: - Private Properties

    @FetchRequest
    private var persistedStatuses: FetchedResults<PersistedStatus>
    @EnvironmentObject
    private var sessionModel: SessionModel
    @State
    private var currentProxy: ScrollViewProxy? = nil
    @State
    private var sink_: AnyCancellable!
    @State
    private var reloadCancellable: AnyCancellable!
    @State
    private var fixedStatus: PersistedStatus? = nil
    @State
    private var visibleStatuses: Set<PersistedStatus> = []
    private var firstVisibleStatus: PersistedStatus? {
        visibleStatuses.sorted { $0.timestamp > $1.timestamp }.first
    }
    
    
    // MARK: - Private Methods
    
    private func appearing(_ proxy: ScrollViewProxy? = nil) {
        reloadCancellable = sessionModel.objectWillChange.sink { _ in
            update {
                guard
                    sessionModel.currentSession != nil
                else {
                    return
                }
                
                persistedStatuses.nsPredicate = model.readFilter()
            }
        }
        
        if sessionModel.currentSession == nil && !sessionModel.sessions.isEmpty {
            sessionModel.select(session: sessionModel.sessions[0])
        }
    }
    
    private func disappearing() {
        reloadCancellable.cancel()
    }

    private func statusAppears(_ status: PersistedStatus) {
        guard
            !model.isLoading
        else {
            return
        }

        Task {
            update {
                visibleStatuses.insert(status)
            }
        }
    }

    private func statusDisappears(_ status: PersistedStatus) {
        Task {
            update {
                visibleStatuses.remove(status)
            }
        }
    }

    private func asyncRefresh(_ proxy: ScrollViewProxy? = nil) async {
        refresh(proxy)
    }
    
    private func refresh(_ proxy: ScrollViewProxy? = nil) {
        fixedStatus = firstVisibleStatus
        model.store(marker: fixedStatus?.statusId)

        sink_ = model.objectWillChange.sink {
            update {
                if !model.isLoading {
                    if let fixedStatus {
                        update {
                            proxy?.scrollTo(fixedStatus.statusId, anchor: .top)
                        }
                    }
                    sink_?.cancel()
                }
            }
        }

        do {
            try model.readTimeline()
        } catch {
            ToastView
                .Toast(
                    type: .error,
                    message: "An error occurred when loading the timeline",
                    error: error)
                .show()
        }
    }
}

struct TimelineView_Previews: PreviewProvider {
    static var previews: some View {
        TimelineView(title: "Timeline", timeline: .home, model: TimelineModel())
    }
}
