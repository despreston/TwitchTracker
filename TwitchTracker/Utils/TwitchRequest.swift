//
//  TwitchRequest.swift
//  TwitchTracker
//
//  Created by dpreston on 12/19/19.
//  Copyright © 2019 dpreston. All rights reserved.
//
import Foundation

struct TwitchUser:Codable {
  var broadcaster_type: String
  var id: String
  var login: String
  var display_name: String
  var type: String
  var description: String
  var profile_image_url: String
  var offline_image_url: String
  var view_count: Int
}

struct TwitchResponse:Codable {
  var data: [TwitchUser]
}

enum TwitchRequestError: Error {
  case UserNotFound
  case Unknown
}

class TwitchRequest {
  private static let CLIENT_ID: String = "dr354rjm9tq8zayf4ccoyj8kdbwrn3"
  private static let BASE_URL: String = "https://api.twitch.tv/helix/"
  
  public static func user(
    login: String,
    callback: @escaping(_ error: Error?, _ data: TwitchUser?) -> Void
  ) -> Void {
    print("Fetching user \(login)")
    
    BaseRequest(url: "\(BASE_URL)users?login=\(login)") { error, data in
      guard let dataResponse = data, error == nil else {
        callback(TwitchRequestError.Unknown, nil)
        return
      }

      do {
        let twitchResponse = try JSONDecoder().decode(
          TwitchResponse.self,
          from: dataResponse
        )
        
        if twitchResponse.data.isEmpty {
          callback(TwitchRequestError.UserNotFound, nil)
        } else {
          callback(nil, twitchResponse.data[0])
        }
      } catch {
        callback(TwitchRequestError.Unknown, nil)
      }
    }
  }
  
  public static func followers(
    id: String,
    callback: @escaping(_ error: Error?, _ data: Int) -> Void
  ) -> Void {
    print("Fetching follower count for \(id)")
    
    BaseRequest(url: "\(BASE_URL)users/follows?to_id=\(id)") { error, data in
      guard let dataResponse = data, error == nil else {
        callback(TwitchRequestError.Unknown, 0)
        return
      }
      
      do {
        let json = try JSONSerialization.jsonObject(
          with: dataResponse,
          options: []
        )
        
        guard let shit = json as? [String: Any] else { return }
        guard let total = shit["total"] as? Int else { return }
        callback(nil, total)
      } catch {
        callback(TwitchRequestError.Unknown, 0)
      }
    }
  }
}
