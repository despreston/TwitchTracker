//
//  BaseRequest.swift
//  TwitchTracker
//
//  Created by dpreston on 12/19/19.
//  Copyright © 2019 dpreston. All rights reserved.
//

import Foundation

struct BaseRequest {
  private let CLIENT_ID: String = "dr354rjm9tq8zayf4ccoyj8kdbwrn3"
  private let config: URLSessionConfiguration
  private let session: URLSession
  
  var url: URL
  var callback: (_ error: Any?, _ data: [String: Any]) -> Void
  
  @discardableResult
  init(
    url: String,
    callback: @escaping(_ error: Any?, _ data: [String: Any]) -> Void
  ) {
    self.url = URL(string: url)!
    self.config = URLSessionConfiguration.default
    
    self.config.httpAdditionalHeaders = [
      "Client-ID": CLIENT_ID
    ]
    
    self.session = URLSession(configuration: config)
    self.callback = callback
    
    self.doRequest()
  }
  
  private func doRequest() {
    self.session.dataTask(with: self.url) { data, response, error in
      guard let data = data, error == nil else {
        self.callback(error, [:])
        return
      }

      guard let httpResponse = response as? HTTPURLResponse,
        (200...299).contains(httpResponse.statusCode) else {
          self.callback(error, [:])
          return
      }
      
      do {
        if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
          self.callback(nil, json)
        }
      } catch {
        print("JSON error: \(error.localizedDescription)")
      }
    }.resume()
  }
}
