//
//  Post.swift
//  Post
//
//  Created by Drew Seeholzer on 6/24/19.
//  Copyright © 2019 DevMtnStudent. All rights reserved.
//

import Foundation

struct Post: Codable {
    var text: String
    var timeStamp: TimeInterval
    var userName: String
    
    init(text: String, timeStamp: TimeInterval = Date().timeIntervalSince1970, userName: String) {
        self.text = text
        self.timeStamp = timeStamp
        self.userName = userName
    }
}
