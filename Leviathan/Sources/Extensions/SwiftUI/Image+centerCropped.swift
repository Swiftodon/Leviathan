//
//  Image+centerCropped.swift
//  Leviathan
//
//  Created by Thomas Bonk on 13.11.22.
//  Source: https://stackoverflow.com/questions/63651077/how-to-center-crop-an-image-in-swiftui/63651228#63651228
//

import SwiftUI

extension Image {
    func centerCropped() -> some View {
        GeometryReader { geo in
            self
                .resizable()
                .scaledToFill()
                .frame(width: geo.size.width, height: geo.size.width)
                .clipped()
        }
    }
}
