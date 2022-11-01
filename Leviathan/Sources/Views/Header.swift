//
//  Header.swift
//  Leviathan
//
//  Created by Thomas Bonk on 31.10.22.
//

import SwiftUI

struct Header<Content>: View where Content: View {
  
  // MARK: - Public Properties
  
  var body: some View {
    NavigationStack {
      content()
        .navigationTitle(title)
        .toolbar {
          ToolbarItem(placement: .navigation) {
            Button {
              
            } label: {
              // TODO: Use the image of the user here
              Image(systemName: "person.circle")
                .resizable()
                .frame(width: 24, height: 24)
            }
            .buttonStyle(.borderless)
          }
        
          ToolbarItem(placement: .automatic) {
            Button {
              
            } label: {
              Image(systemName: "filemenu.and.selection")
                .resizable()
                .frame(width: 24, height: 24)
            }
            .buttonStyle(.borderless)
          }
        }
    }
  }
  
  
  // MARK: - Initialization
  
  init(title: LocalizedStringKey, @ViewBuilder content: @escaping () -> Content) {
    self.title = title
    self.content = content
  }
  
  var title: LocalizedStringKey
  var content: () -> Content
}

struct Header_Previews: PreviewProvider {
  static var previews: some View {
    Header(title: "Header", content: { Text("Content") })
  }
}
