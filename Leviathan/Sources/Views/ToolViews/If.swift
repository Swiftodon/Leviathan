//
//  If.swift
//  Leviathan
//
//  Created by Thomas Bonk on 18.11.22.
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

struct If<IfContent: View>: View {

    // MARK: - Public Properties

    var body: some View {
        Alternative(condition) {
            ifContent()
        } ifFalse: {
            EmptyView()
        }
    }


    // MARK: - Private Properties

    let condition: Bool
    let ifContent: () -> IfContent


    // MARK: - Initialization

    init(_ condition: Bool, @ViewBuilder show: @escaping () -> IfContent) {

        self.condition = condition
        self.ifContent = show
    }
}

struct Alternative<TrueContent: View, FalseContent: View>: View {

    // MARK: - Public Properties

    var body: some View {
        if condition {
            trueContent()
        } else {
            falseContent()
        }
    }


    // MARK: - Private Properties

    let condition: Bool
    let trueContent: () -> TrueContent
    let falseContent: () -> FalseContent


    // MARK: - Initialization

    init(
        _ condition: Bool,
        @ViewBuilder ifTrue: @escaping () -> TrueContent,
        @ViewBuilder ifFalse: @escaping () -> FalseContent) {

        self.condition = condition
        self.trueContent = ifTrue
        self.falseContent = ifFalse
    }
}
