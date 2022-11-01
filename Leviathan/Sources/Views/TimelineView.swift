//
//  TimelineView.swift
//  Leviathan
//
//  Created by Thomas Bonk on 31.10.22.
//

import SwiftUI

struct TimelineView: View {
  
  // MARK: - Public Properties
  
  var body: some View {
    Header(title: title) {
      Text(title)
    }
  }
  
  var title: LocalizedStringKey
  @ObservedObject
  var model: TimelineModel
}

struct TimelineView_Previews: PreviewProvider {
  static var previews: some View {
    TimelineView(title: "Timeline", model: TimelineModel())
  }
}
