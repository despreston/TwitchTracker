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
  @State private var user: TwitchUser?
  @State private var loading: Bool = false
  @State private var error: String = ""
  @State private var followers: Int = 0
  
  private func onChangeUser() -> Void {
    self.loading = true
    
    TwitchRequest.user(login: self.name).then { user in
      self.user = user
      return Promise { user.id }
    }.then { id in
      return TwitchRequest.followers(id: id)
    }.then { followers in
      self.followers = followers
    }.catch { error in
      self.error = {
        switch error {
        case TwitchRequestError.UserNotFound:
          return "Unknown user."
        default:
          return "Something went wrong."
        }
      }()
    }.always {
      self.loading = false
    }
  }
  
  var body: some View {
    VStack(alignment: .leading, spacing: 0) {
      if self.user?.login != "" {
        Text("Follower count for \(name): \(followers)")
          .font(.subheadline)
          .fontWeight(.semibold)
          .padding(.horizontal, 16.0)
          .padding(.vertical, 12.0)
      }
      if self.error != "" {
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
          Text("Show follower count")
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

