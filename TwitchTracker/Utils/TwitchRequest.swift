//
//  TwitchRequest.swift
//  TwitchTracker
//
//  Created by dpreston on 12/19/19.
//  Copyright © 2019 dpreston. All rights reserved.
//
import Foundation
import Promises

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
  private static let BASE_URL: String = "https://api.twitch.tv/helix/"
  
  public static func user(login: String) -> Promise<TwitchUser> {
    print("Fetching user \(login)")
    
    return BaseRequest(url: "\(BASE_URL)users?login=\(login)").doRequest()
      .then { dataResponse in
        return Promise<TwitchUser> { fulfill, reject in
          do {
            let twitchResponse = try JSONDecoder().decode(
              TwitchResponse.self,
              from: dataResponse
            )
    
            if twitchResponse.data.isEmpty {
              return reject(TwitchRequestError.UserNotFound)
            } else {
              return fulfill(twitchResponse.data[0])
            }
          } catch {
            return reject(TwitchRequestError.Unknown)
          }
        }
    }
  }
  
  public static func followers(id: String) -> Promise<Int> {
    print("Fetching follower count for \(id)")
    
    return BaseRequest(url: "\(BASE_URL)users/follows?to_id=\(id)").doRequest()
      .then { dataResponse in
        return Promise<Int> { fulfill, reject in
          do {
            let json = try JSONSerialization.jsonObject(
              with: dataResponse,
              options: []
            )
            
            guard let shit = json as? [String: Any] else { return }
            guard let total = shit["total"] as? Int else { return }

            return fulfill(total)
          } catch {
            return reject(TwitchRequestError.Unknown)
          }
        }
    }
  }
}
