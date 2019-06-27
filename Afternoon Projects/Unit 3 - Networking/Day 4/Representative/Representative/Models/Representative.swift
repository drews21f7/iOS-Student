//
//  Representative.swift
//  Representative
//
//  Created by Drew Seeholzer on 6/27/19.
//  Copyright © 2019 DevMtnStudent. All rights reserved.
//

import Foundation

struct TopLevelDictionary: Codable {
    let results: [Representative]
}

struct Representative: Codable {
    let name: String
    let party: String
    let state: String
    let district: String
    let phone: String
    let office: String
    let link: String
}
