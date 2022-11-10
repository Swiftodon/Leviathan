//
//  View+onRendered.swift
//  Leviathan
//
//  Created by Thomas Bonk on 09.11.22.
//  Source: https://stackoverflow.com/a/65878281/44123
//

import Foundation
import SwiftUI

struct RenderedPreferenceKey: PreferenceKey {
    static var defaultValue: Int = 0
    static func reduce(value: inout Int, nextValue: () -> Int) {
        value = value + nextValue() // sum all those remain to-be-rendered
    }
}

struct MarkRender: ViewModifier {
    @State private var toBeRendered = 1
    func body(content: Content) -> some View {
        content
            .preference(key: RenderedPreferenceKey.self, value: toBeRendered)
            .onAppear { toBeRendered = 0 }
    }
}

extension View {
    func trackRendering() -> some View {
        self.modifier(MarkRender())
    }

    func onRendered(_ perform: @escaping () -> Void) -> some View {
        self.onPreferenceChange(RenderedPreferenceKey.self) { toBeRendered in
           // invoke the callback only when all tracked have been set to 0,
           // which happens when all of their .onAppear are called
           if toBeRendered == 0 { perform() }
        }
    }
}
