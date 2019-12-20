//
//  TwitchRequest.swift
//  TwitchTracker
//
//  Created by dpreston on 12/19/19.
//  Copyright © 2019 dpreston. All rights reserved.
//
import Foundation

struct TwitchUser {
  var broadcaster_type: String
  var id: Int
  var login: String
  var display_name: String
  var type: String
  var description: String
  var profile_image_url: String
  var offline_image_url: String
  var view_count: Int
}

class TwitchRequest {
  private static let CLIENT_ID: String = "dr354rjm9tq8zayf4ccoyj8kdbwrn3"
  private static let BASE_URL: String = "https://api.twitch.tv/helix/"
  
  public static func user(
    login: String,
    callback: @escaping(_ error: Any?, _ data: [String: Any]?) -> Void
  ) -> Void {
    print("Fetching user \(login)")
    
    BaseRequest(url: "\(BASE_URL)users?login=\(login)") { error, response in
      if error != nil {
        callback(error, nil)
        return;
      }

      if let data = response["data"] as? [[String: Any]] {
        callback(nil, data[0])
      }
    }
  }
}
