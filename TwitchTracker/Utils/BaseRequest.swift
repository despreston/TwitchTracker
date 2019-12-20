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
  var callback: (_ error: Error?, _ data: Data?) -> Void
  
  @discardableResult
  init(
    url: String,
    callback: @escaping(_ error: Error?, _ data: Data?) -> Void
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
      if (error != nil) {
        self.callback(error, data)
        return
      }

      guard let httpResponse = response as? HTTPURLResponse,
        (200...299).contains(httpResponse.statusCode) else {
          self.callback(error, data)
          return
      }
      
      self.callback(error, data)
      return
    }.resume()
  }
}
