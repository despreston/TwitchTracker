//
//  FollowerLoop.swift
//  TwitchTracker
//
//  Created by dpreston on 12/23/19.
//  Copyright © 2019 dpreston. All rights reserved.
//

import Foundation

class FollowerLoop {
  public var id: String?
  public var callback: ((Int) -> Void)?
  private var timer: Timer?
  
  func reset(_ id: String, callback: @escaping((Int) -> Void)) {
    self.id = id
    self.callback = callback
    self.timer?.invalidate()
    
    self.timer = Timer.scheduledTimer(
      timeInterval: 10,
      target: self,
      selector: #selector(shits),
      userInfo: nil,
      repeats: true
    )
  }
  
  @objc private func shits() {
    guard let id: String = self.id else { return }
    guard let callback: (Int) -> Void = self.callback else { return }
    
    TwitchRequest.followers(id: id).then(callback)
  }
}
