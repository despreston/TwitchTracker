//
//  StatusBarController.swift
//  TwitchTracker
//
//  Created by dpreston on 12/19/19.
//  Copyright © 2019 dpreston. All rights reserved.
//

import AppKit
import Cocoa

private var _shared: StatusBarController?

class StatusBarController
{
  private var statusBar: NSStatusBar
  private var statusItem: NSStatusItem
  private var popover: NSPopover
  private var statusBarButton: NSStatusBarButton
  private var eventMonitor: EventMonitor?
  
  static var shared: StatusBarController {
    return _shared!
  }
  
  init(_ popover: NSPopover)
  {
    statusBar = NSStatusBar.init()
    let variableLength: CGFloat = NSStatusItem.variableLength
    statusItem = statusBar.statusItem(withLength: variableLength)
    statusBarButton = statusItem.button!
    self.popover = popover
    
    statusBarButton.action = #selector(togglePopover(sender:))
    statusBarButton.target = self
    
    let icon = NSImage(named: "StatusBarIcon")
    icon?.isTemplate = true
    statusBarButton.image = icon
    statusBarButton.imagePosition = NSControl.ImagePosition.imageLeft;
    
    eventMonitor = EventMonitor(
      mask: [.leftMouseDown, .rightMouseDown], handler: mouseEventHandler
    )
    
    _shared = self
  }
  
  func setFollowerCount(count: Int) -> Void {
    self.statusBarButton.title = "\(count)"
    
    if (popover.isShown) {
      self.showPopover()
    }
  }
  
  func showPopover() -> Void {
    popover.show(
      relativeTo: statusBarButton.bounds,
      of: statusBarButton,
      preferredEdge: .minY
    )
  }
  
  @objc func togglePopover(sender: AnyObject)
  {
    if(popover.isShown)
    {
      hidePopover(sender)
    }
    else
    {
      showPopover()
      eventMonitor?.start()
    }
  }
  
  func hidePopover(_ sender: AnyObject)
  {
    popover.performClose(sender)
    eventMonitor?.stop()
  }
  
  func mouseEventHandler(_ event: NSEvent?)
  {
    if(popover.isShown)
    {
      hidePopover(event!)
    }
  }
}
