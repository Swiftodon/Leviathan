//
//  String+HTML.swift
//  Leviathan
//
//  Created by Thomas Bonk on 04.11.22.
//  Source: https://gist.github.com/hashaam/31f51d4044a03473c18a168f4999f063?permalink_comment_id=3137487#gistcomment-3137487
//

import Foundation
import SwiftUI

extension String {
    
    public var attributedString: AttributedString? {
        let plain = self.replacingOccurrences(of: "<p>", with: "").replacingOccurrences(of: "</p>", with: "")
        let data = self.data(using: plain.fastestEncoding)!
        
        guard let attrStr = try? NSMutableAttributedString(
            data: data,
            options: [.documentType: NSAttributedString.DocumentType.html],
            documentAttributes: nil) else {
            
            return nil
        }
        
        attrStr.enumerateAttribute(.font, in: NSMakeRange(0, attrStr.length)) { value, range, _ in
            attrStr.addAttributes([.font: Font.platformBody], range: range)
        }
        
        return AttributedString(attrStr)
    }

    public func trimHTMLTags() -> String? {
        guard let htmlStringData = self.data(using: String.Encoding.utf8) else {
            return nil
        }
        
        let options: [NSAttributedString.DocumentReadingOptionKey : Any] = [
            .documentType: NSAttributedString.DocumentType.html,
            .characterEncoding: String.Encoding.utf8.rawValue
        ]
        
        let attributedString = try? NSAttributedString(data: htmlStringData, options: options, documentAttributes: nil)
        return attributedString?.string
    }
    
}
