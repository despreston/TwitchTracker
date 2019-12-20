//
//  ContentView.swift
//  TwitchTracker
//
//  Created by dpreston on 12/17/19.
//  Copyright © 2019 dpreston. All rights reserved.
//

import SwiftUI
import AppKit

struct ContentView: View {
  @State private var name: String = "nykx1"
  @State private var image: String = ""
  @State private var loading: Bool = false
  @State private var error: String = ""
  
  private func onChangeUser() -> Void {
    TwitchRequest.user(login: self.name) { error, user in
      if (error != nil) {
        self.error = "Shit something went wrong"
        return
      }

      self.image = user!["profile_image_url"] as! String
    }
  }
  
  var body: some View {
    VStack(alignment: .leading, spacing: 0) {
      Text("Follower count for \(name)\(image)")
        .font(.subheadline)
        .fontWeight(.semibold)
        .padding(.horizontal, 16.0)
        .padding(.vertical, 12.0)
      TextField("Twitch username", text: $name)
        .padding(.horizontal, 16.0)
        .padding(.vertical, 12.0)
      HStack {
        Button(action: onChangeUser)
        {
          Text("Change User")
            .font(.caption)
            .fontWeight(.semibold)
        }
        Button(action: { NSApplication.shared.terminate(self) })
        {
          Text("Quit App")
            .font(.caption)
            .fontWeight(.semibold)
        }
        .padding(.trailing, 16.0)
      }
      .frame(width: 360.0, alignment: .trailing)
    }
    .padding(0)
    .frame(width: 360.0, height: 200.0, alignment: .top)
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}

