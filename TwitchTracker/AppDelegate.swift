//
//  AppDelegate.swift
//  TwitchTracker
//
//  Created by dpreston on 12/17/19.
//  Copyright © 2019 dpreston. All rights reserved.
//

import Cocoa
import SwiftUI

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

  var popover = NSPopover.init()
  var statusBar: StatusBarController?

  func applicationDidFinishLaunching(_ aNotification: Notification) {
    // Create the SwiftUI view that provides the window contents.
    let contentView = ContentView()

    // Set the SwiftUI's ContentView to the Popover's ContentViewController
    popover.contentViewController = MainViewController()
    popover.contentSize = NSSize(width: 360, height: 360)
    popover.contentViewController?.view = NSHostingView(rootView: contentView)
    
    statusBar = StatusBarController.init(popover);
  }

  func applicationWillTerminate(_ aNotification: Notification) {
    // Insert code here to tear down your application
  }


}

