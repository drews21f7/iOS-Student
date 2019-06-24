//
//  PostController.swift
//  Post
//
//  Created by Drew Seeholzer on 6/24/19.
//  Copyright © 2019 DevMtnStudent. All rights reserved.
//

import Foundation

class PostController {
    
   static let baseURL = URL(string: "http://devmtn-posts.firebaseio.com/posts")
    
    static var posts: [Post] = []
    
    static func fetchPosts(completion: @escaping() -> Void) {
        guard let url = baseURL else { completion(); return }
        let getterEndpoint = url.appendingPathExtension("json")
        var request = URLRequest(url: getterEndpoint)
        request.httpBody = nil
        request.httpMethod = "GET"
        let dataTask = URLSession.shared.dataTask(with: request) { (data, _, error) in
            if let error = error {
                print(error)
                completion()
                return
            }
            guard let data = data else { return completion()}
            
            let jDecoder = JSONDecoder()
            do {
                
                let postsDictionary = try jDecoder.decode([String:Post].self, from: data)
                var posts: [Post] = postsDictionary.compactMap({ $0.value})
                posts.sort(by: { $0.timeStamp > $1.timeStamp })
                self.posts = posts
                completion()
            } catch {
                print (error)
                completion()
                return
            }
        }
        dataTask.resume()
        }
}
