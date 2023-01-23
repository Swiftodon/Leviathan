//
//  ComposeView.swift
//  Leviathan
//
//  Created by Thomas Bonk on 25.11.22.
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
import SwiftUI

fileprivate extension Int {
    static let MaxTootLength = 500
}

struct ComposeView: View {

    // MARK: - Public Properties
    
    var body: some View {
        VStack {
            header()

            if sensitive {
                TextField("Write your spoiler text", text: $spoilerText)
                    .padding(.horizontal, 5)
            }

            HStack {
                Text("What do you want to say?")
                Spacer()
            }
            .padding(.all, 5)

            TextEditor(text: $text)
                .font(.body)
                .cornerRadius(10)
                .onReceive(Just(text)) { _ in
                    textLength = text.count
                }
                .padding(.horizontal, 5)

            Spacer()

            actionButtons()
        }
    }

    // MARK: - Private Properties

    @Environment(\.presentationMode)
    private var presentationMode: Binding<PresentationMode>
    @EnvironmentObject
    private var sessionModel: SessionModel
    @State
    private var spoilerText = ""
    @State
    private var text = ""
    @State
    private var textLength = 0
    @State
    private var selection: Int = 1
    @State
    private var sensitive = false


    // MARK: - Private Methods

    @ViewBuilder
    private func header() -> some View {
        HStack {
            Button {
                presentationMode.wrappedValue.dismiss()
            } label: {
                Image(systemName: "xmark.circle.fill")
            }
            .buttonStyle(.borderless)

            Spacer()

            Button {
                postToot()
            } label: {
                Text("Toot")
            }
            .buttonStyle(.borderless)
        }
        .padding(.all, 10)
    }

    @ViewBuilder
    private func actionButtons() -> some View {
        HStack {
            Button { } label: { Image(systemName: "paperclip.circle").resizable().frame(width: 24, height: 24) }
                .buttonStyle(.borderless)
                .padding(.trailing, 5)

            Button { } label: { Image(systemName: "chart.line.uptrend.xyaxis.circle").resizable().frame(width: 24, height: 24) }
                .buttonStyle(.borderless)
                .padding(.trailing, 5)

            Picker(selection: $selection, label: Text("Visibility")) {
                Image(systemName: "globe").resizable().frame(width: 24, height: 24).tag(1)
                Image(systemName: "checklist.unchecked").resizable().frame(width: 24, height: 24).tag(2)
                Image(systemName: "lock").resizable().frame(width: 24, height: 24).tag(3)
                Image(systemName: "envelope").resizable().frame(width: 24, height: 24).tag(4)
            }
            .buttonStyle(.borderless)
            .padding(.trailing, 5)

            Toggle("Sensitive", isOn: $sensitive)

            Spacer()

            Text("\(textLength)")
                .foregroundColor(textLength > .MaxTootLength ? .red : .primary)
        }
        .padding(.all, 10)
    }

    public func postToot() {
        if let auth = sessionModel.currentSession?.auth {
            Task {
                do {
                    _ = try await auth.new(statusComponents: .init(text: text))
                    presentationMode.wrappedValue.dismiss()
                } catch {
                    mainAsync {
                        ToastView
                            .Toast(
                                type: .error,
                                message: "An error occurred when publishing the toot.",
                                error: error)
                            .show()
                    }
                }
            }
        }
    }
}

struct ComposeView_Previews: PreviewProvider {
    static var previews: some View {
        ComposeView()
    }
}
