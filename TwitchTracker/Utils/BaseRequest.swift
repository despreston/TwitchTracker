//
//  BaseRequest.swift
//  TwitchTracker
//
//  Created by dpreston on 12/19/19.
//  Copyright © 2019 dpreston. All rights reserved.
//

import Foundation
import Promises

struct BaseRequest {
  private let CLIENT_ID: String = "dr354rjm9tq8zayf4ccoyj8kdbwrn3"
  private let config: URLSessionConfiguration
  private let session: URLSession
  
  var url: URL
  
  @discardableResult
  init(url: String) {
    self.url = URL(string: url)!
    self.config = URLSessionConfiguration.default
    
    self.config.httpAdditionalHeaders = [
      "Client-ID": CLIENT_ID
    ]
    
    self.session = URLSession(configuration: config)
  }
  
  func doRequest() -> Promise<Data> {
    return Promise<Data> { fulfill, reject in
      self.session.dataTask(with: self.url) { data, response, error in
        if (error != nil) {
          return reject(error!)
        }
        
        guard let httpResponse = response as? HTTPURLResponse,
          (200...299).contains(httpResponse.statusCode) else {
            return reject(error!)
        }
        
        return fulfill(data!)
      }.resume()
    }
  }
}
