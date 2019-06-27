//
//  RepresentativeController.swift
//  Representative
//
//  Created by Drew Seeholzer on 6/27/19.
//  Copyright © 2019 DevMtnStudent. All rights reserved.
//

import Foundation

class RepresentativeController {
    
    static let sharedInstance = RepresentativeController()
    
    static let baseURL = URL(string: "http://whoismyrepresentative.com/getall_reps_bystate.php")
    
    static func searchRepresentatives(forState state: String, completion: @escaping([Representative]) -> Void ) {
        guard let url = baseURL else {completion([]); return}
        
        guard var components = URLComponents(url: url, resolvingAgainstBaseURL: true) else {completion([]); return}
        let searchQueryItems = URLQueryItem(name: "state", value: state)
        let jsonQueryItem = URLQueryItem(name: "output", value: "json")
        components.queryItems = [searchQueryItems, jsonQueryItem]
        guard let finalURL = components.url else {completion([]); return}
        
        URLSession.shared.dataTask(with: finalURL) { (data, _, error) in
            if let error = error {
                print ("There was an error \(error.localizedDescription)")
                completion([])
                return
            }
            
            guard let data = data  else {completion([]); return}
            
            guard let newData = String(data: data, encoding: .ascii)?.data(using: .utf8) else {completion([]); return}
            
            do {
                let decoder = JSONDecoder()
                let topLevelDictionary = try decoder.decode(TopLevelDictionary.self, from: newData)
                completion(topLevelDictionary.results)
            } catch {
                print("Error decoding data: \(error.localizedDescription)")
                completion([])
                return
            }
            
        }.resume()
    }
}



