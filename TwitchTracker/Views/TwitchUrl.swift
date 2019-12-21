//
//  TwitchUrl.swift
//  TwitchTracker
//
//  Created by dpreston on 12/20/19.
//  Copyright © 2019 dpreston. All rights reserved.
//

import SwiftUI
import Cocoa

private func handler(_ login: String) -> Void {
  let url = URL(string: "https://twitch.tv/\(login)")!
  NSWorkspace.shared.open(url)
}

func TwitchURL(login: String) -> some View {
  return (
    Button(action: { handler(login) })
    {
      Text("Homepage")
    }
    .buttonStyle(LinkButtonStyle())
  )
}
