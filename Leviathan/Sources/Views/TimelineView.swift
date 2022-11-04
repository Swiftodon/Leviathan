//
//  TimelineView.swift
//  Leviathan
//
//  Created by Thomas Bonk on 31.10.22.
//

import Combine
import MastodonSwift
import SwiftUI

struct TimelineView: View {
    
    // MARK: - Public Properties
    
    var body: some View {
        Header(title: title) {
            List {
                ForEach(model.timeline, id: \.id) { status in
                    Text("\(status.content)")
                }
            }
            .refreshable {
                do {
                    try await model.readTimeline()
                } catch {
                    NSLog("\(error)")
                }
            }
            .onAppear {
                sink_ = accountModel.objectWillChange.sink { _ in
                    DispatchQueue.main.async {
                        if let _ = AccountModel.shared.auth {
                            Task {
                                do {
                                    try await model.readTimeline()
                                } catch {
                                    NSLog("\(error)")
                                }
                            }
                        }
                    }
                }
                
                sink2_ = model.objectWillChange.sink(receiveValue: { _ in
                    DispatchQueue.main.async {
                        statuses = model.timeline
                    }
                })
            }
        }
    }
    
    var title: LocalizedStringKey
    @ObservedObject
    var model: TimelineModel
    
    // MARK: - Private Properties
    
    @EnvironmentObject
    private var accountModel: AccountModel
    
    @State
    private var statuses: [Status] = []
    @State
    private var sink_: AnyCancellable!
    @State
    private var sink2_: AnyCancellable!
}

struct TimelineView_Previews: PreviewProvider {
    static var previews: some View {
        TimelineView(title: "Timeline", model: TimelineModel())
    }
}
