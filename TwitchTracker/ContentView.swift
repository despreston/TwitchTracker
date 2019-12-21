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
      self.name = ""
      self.error = ""
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
  
  var Header: some View {
    VStack(alignment: .center, spacing: 0) {
      ProfileImage(url: self.user!.profile_image_url)
        .padding(.bottom, 5.0)
      Text("\(self.user!.login)")
        .font(.subheadline)
        .fontWeight(.semibold)
      HStack {
        Text("Followers: \(followers)")
          .font(.caption)
        Text("Views: \(self.user!.view_count)")
          .font(.caption)
      }
      .padding(.horizontal, 5.0)
      .padding(.vertical, 2.0)
      TwitchURL(login: self.user!.login)
    }
    .frame(width: 360.0)
  }
  
  var ErrMessage: some View {
    Text(self.error)
      .font(.subheadline)
      .fontWeight(.semibold)
      .padding(.horizontal, 16.0)
      .padding(.vertical, 12.0)
      .foregroundColor(Color.red)
  }
  
  var body: some View {
    VStack(alignment: .center, spacing: 0) {
      if self.loading {
        Text("Loading...")
      }
      
      if !self.loading {
        if self.user?.login != nil && self.error == "" {
          Header
        }
        
        if self.error != "" {
          ErrMessage
        }
      }
      
      TextField("Twitch username", text: $name, onCommit: onChangeUser)
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
    .padding(10)
    .frame(width: 360.0, alignment: .top)
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}

