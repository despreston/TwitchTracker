//
//  StatusBar.swift
//  TwitchTracker
//
//  Created by dpreston on 12/23/19.
//  Copyright © 2019 dpreston. All rights reserved.
//

import Foundation
import Cocoa

class StatusBar {
  
  var shared: StatusBarController?
  
  init(_ popover: NSPopover) {
    shared = StatusBarController.init(popover)
  }
}
