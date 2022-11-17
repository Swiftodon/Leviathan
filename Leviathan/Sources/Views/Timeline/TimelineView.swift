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
            ScrollViewReader { proxy in
                List {
                    ForEach(persistedStatuses, id: \.statusId) { status in
                        StatusView(persistedStatus: status)
                            .id(status.statusId)
                            .onAppear { statusAppears(status) }
                            .onDisappear { statusDisappears(status) }
                    }
                }
                .refreshable { refreshInTask(proxy) }
                .toolbar {
                    ToolbarItem(placement: .navigation) {
                        if model.isLoading {
                            ProgressView()
                            // TODO: This is ugly; is there a better way have the same size as the button?
                                .scaleEffect(0.5)
                                .padding(.horizontal, -4)
                        } else {
                            Button { refreshInTask(proxy) } label: { Image(systemName: "arrow.clockwise") }
                                .buttonStyle(.borderless)
                                .padding(.horizontal, 5)
                        }
                    }
                }
                .onAppear { appearing(proxy) }
                .onDisappear(perform: disappearing)
            }
        }
        .onChange(of: scenePhase, perform: scenePhaseChanged(phase:))
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

    @Environment(\.scenePhase)
    var scenePhase
    @FetchRequest
    private var persistedStatuses: FetchedResults<PersistedStatus>
    @EnvironmentObject
    private var sessionModel: SessionModel
    @State
    private var reloadCancellable: AnyCancellable!
    private var fixedStatus: MutableField<PersistedStatus?> = MutableField(value: nil)
    private var lockStatusAppearanceUpdate = MutableField(value: false)
    private var visibleStatuses = MutableField(value: Set<PersistedStatus>())
    private var firstVisibleStatus: PersistedStatus? {
        visibleStatuses.value.sorted { $0.timestamp < $1.timestamp }.first
    }
    
    
    // MARK: - Private Methods

    private func scenePhaseChanged(phase: ScenePhase) {
        NSLog("\(phase)")
    }
    
    private func appearing(_ proxy: ScrollViewProxy? = nil) {
        reloadCancellable = sessionModel.objectWillChange.sink { _ in
            update {
                guard
                    sessionModel.currentSession != nil
                else {
                    return
                }
                
                persistedStatuses.nsPredicate = model.readFilter()
                refreshInTask()
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
            !lockStatusAppearanceUpdate.value
        else {
            return
        }

        update {
            visibleStatuses.value.insert(status)
        }
    }

    private func statusDisappears(_ status: PersistedStatus) {
        guard
            !lockStatusAppearanceUpdate.value
        else {
            return
        }

        update {
            visibleStatuses.value.remove(status)
        }
    }
    
    private func refreshInTask(_ proxy: ScrollViewProxy? = nil) {
        lockStatusAppearanceUpdate.value = true
        fixedStatus.value = firstVisibleStatus

        Task {
            await refresh()
        }

        if let fixedStatus = fixedStatus.value {
            update {
                proxy?.scrollTo(fixedStatus.statusId, anchor: .top)

                update {
                    lockStatusAppearanceUpdate.value = false
                }
            }
        }
    }
    
    @Sendable
    private func refresh() async {
        do {
            if let _ = SessionModel.shared.currentSession?.auth {
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
        TimelineView(title: "Timeline", timeline: .home, model: TimelineModel())
    }
}
