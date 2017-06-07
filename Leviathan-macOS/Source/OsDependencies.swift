//
//  OsDependencies.swift
//  Leviathan
//
//  Created by Thomas Bonk on 05.06.17.
//
//

import AppKit
import Moya


func imageToData(_ image: Image) -> Data? {
    
    return NSBitmapImageRep(data: image.tiffRepresentation!)?
            .representation(using: .PNG, properties: [:])
}
