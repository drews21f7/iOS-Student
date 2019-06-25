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
    var timestamp: TimeInterval
    var username: String
    
    init(text: String, timestamp: TimeInterval = Date().timeIntervalSince1970, username: String) {
        self.text = text
        self.timestamp = timestamp
        self.username = username
    }
}
