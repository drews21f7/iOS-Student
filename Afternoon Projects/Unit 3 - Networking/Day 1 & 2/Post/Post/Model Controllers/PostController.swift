//
//  PostController.swift
//  Post
//
//  Created by Drew Seeholzer on 6/24/19.
//  Copyright © 2019 DevMtnStudent. All rights reserved.
//

import Foundation

class PostController {
    
    let baseURL = URL(string: "http://devmtn-posts.firebaseio.com/posts")
    
    var posts: [Post] = []
    
    func fetchPosts(reset: Bool = true, completion: @escaping() -> Void) {
        let queryEndInterval = reset ? Date().timeIntervalSince1970:
        posts.last?.timestamp ?? Date().timeIntervalSince1970
 
        guard let url = baseURL else { completion(); return }
        let urlParameters = ["orderBy": "\"timestamp\"",
                              "endAt":"\(queryEndInterval)", "limitToLast": "15",]
        
        let queryItems = urlParameters.compactMap( { URLQueryItem(name: $0.key, value: $0.value)})
        
        var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: true)
        
        urlComponents?.queryItems = queryItems
        
        guard let url2 = urlComponents?.url else { completion();return}
        
        let getterEndpoint = url2.appendingPathExtension("json")
        var request = URLRequest(url: getterEndpoint)
        request.httpBody = nil
        request.httpMethod = "GET"
        let dataTask = URLSession.shared.dataTask(with: request) { (data, _, error) in
            if let error = error {
                print(error)
                completion()
                return
            }
            guard let data = data else { completion(); return}
            
            let jDecoder = JSONDecoder()
            do {
                
                let postsDictionary = try jDecoder.decode([String:Post].self, from: data)
                let posts: [Post] = postsDictionary.compactMap({ $0.value})
                let sortedPosts = posts.sorted(by: { $0.timestamp > $1.timestamp })
                if reset {
                    self.posts = sortedPosts
                } else {
                    self.posts.append(contentsOf: sortedPosts)
                }
                completion()
            } catch {
                print (error)
                completion()
                return
            }
        }
        dataTask.resume()
    }
    
    func addNewPostWith(username: String, text: String, completion: @escaping () -> ()) {
        let post = Post(text: text, username: username)
        var postData: Data
        do{
            let jEncoder = JSONEncoder()
           postData = try jEncoder.encode(post)
        } catch {
            print (error)
            completion()
            return
            
        }
        
        guard let url = baseURL else { completion(); return }
        
        let postEndpoint = url.appendingPathExtension("json")
        
        var request = URLRequest(url: postEndpoint)
        request.httpMethod = "POST"
        request.httpBody = postData
        let dataTask = URLSession.shared.dataTask(with: request) { (data, _, error) in
            if let error = error {
                print (error)
                completion()
                return
            }
            guard let data = data,
                let responseDataString = String(data: data, encoding: .utf8) else {
                    NSLog("Data in nil. Unable to verify if data was able to be put to endpoint.")
                    completion()
                    return }
            
            NSLog(responseDataString)
            
            self.fetchPosts {
                completion()
            }
            
        }
        dataTask.resume()
    }
}
