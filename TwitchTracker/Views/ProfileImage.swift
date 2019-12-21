//
//  ProfileImage.swift
//  TwitchTracker
//
//  Created by dpreston on 12/20/19.
//  Copyright © 2019 dpreston. All rights reserved.
//

import KingfisherSwiftUI
//import Kingfisher
import SwiftUI

func ProfileImage(url: String) -> some View {
  return KFImage(URL(string: url)!)
    .resizable()
    .frame(width: 100.0, height: 100.0)
    .cornerRadius(50.0)
}
