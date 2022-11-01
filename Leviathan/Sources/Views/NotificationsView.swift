//
//  NotificationsView.swift
//  Leviathan
//
//  Created by Thomas Bonk on 31.10.22.
//

import SwiftUI

struct NotificationsView: View {
  
  // MARK: - Public Properties
  
  var body: some View {
    Header(title: "Notifications") {
      Text("Notifications")
    }
  }
  
  @ObservedObject
  var model: NotificationsModel
}

struct NotificationsView_Previews: PreviewProvider {
  static var previews: some View {
    NotificationsView(model: NotificationsModel())
  }
}
