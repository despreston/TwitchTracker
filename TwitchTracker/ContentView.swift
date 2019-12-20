//
//  ContentView.swift
//  TwitchTracker
//
//  Created by dpreston on 12/17/19.
//  Copyright © 2019 dpreston. All rights reserved.
//

import SwiftUI
import AppKit
import Promises

struct ContentView: View {
  //nykx1
  @State private var name: String = ""
  @State private var image: String = ""
  @State private var loading: Bool = false
  @State private var error: Error? = nil
  @State private var followers: Int = 0
  @State private var id: String = ""
  
  private func onChangeUser() -> Void {
    self.loading = true
    
    TwitchRequest.user(login: self.name) { error, user in
      if (error != nil) {
        self.error = error
        return
      }
      
      self.id = user?.id ?? ""
      self.image = user?.profile_image_url ?? ""
      
      TwitchRequest.followers(id: self.id) { error, total in
        if (error != nil) {
          self.error = error
          return
        }
        
        self.followers = total
      }
    }
  }
  
  var body: some View {
    VStack(alignment: .leading, spacing: 0) {
      if self.name != "" {
        Text("Follower count for \(name): \(followers)")
          .font(.subheadline)
          .fontWeight(.semibold)
          .padding(.horizontal, 16.0)
          .padding(.vertical, 12.0)
      }
      if self.error != nil {
        Text(self.error)
          .font(.subheadline)
          .fontWeight(.semibold)
          .padding(.horizontal, 16.0)
          .padding(.vertical, 12.0)
          .foregroundColor(Color.red)
      }
      TextField("Twitch username", text: $name)
        .padding(.horizontal, 16.0)
        .padding(.vertical, 12.0)
      HStack {
        Button(action: onChangeUser)
        {
          Text("Follow User")
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

