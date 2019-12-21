//
//  StatusBarController.swift
//  TwitchTracker
//
//  Created by dpreston on 12/19/19.
//  Copyright © 2019 dpreston. All rights reserved.
//

import AppKit

class StatusBarController
{
  private var statusBar: NSStatusBar
  private var statusItem: NSStatusItem
  private var popover: NSPopover
  private var statusBarButton: NSStatusBarButton
  private var eventMonitor: EventMonitor?
  
  init(_ popover: NSPopover)
  {
    statusBar = NSStatusBar.init()
    statusItem = statusBar.statusItem(withLength: 28.0)
    statusBarButton = statusItem.button!
    self.popover = popover
    
    statusBarButton.action = #selector(togglePopover(sender:))
    statusBarButton.target = self
    statusBarButton.title = "🎮"
    
    eventMonitor = EventMonitor(mask: [.leftMouseDown, .rightMouseDown], handler: mouseEventHandler)
  }
  
  @objc func togglePopover(sender: AnyObject)
  {
    if(popover.isShown)
    {
      hidePopover(sender)
    }
    else
    {
      showPopover(sender)
    }
  }
  
  func showPopover(_ sender: AnyObject)
  {
    popover.show(relativeTo: statusBarButton.bounds, of: statusBarButton, preferredEdge: NSRectEdge.maxY)
    eventMonitor?.start()
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
