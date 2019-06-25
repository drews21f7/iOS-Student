//
//  PostListViewController.swift
//  Post
//
//  Created by Drew Seeholzer on 6/24/19.
//  Copyright © 2019 DevMtnStudent. All rights reserved.
//

import UIKit

class PostListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    
    let postController = PostController()
    
    var refreshControl = UIRefreshControl()

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.estimatedRowHeight = 45
        tableView.rowHeight = UITableView.automaticDimension
        
        tableView.refreshControl = refreshControl
        
        refreshControl.addTarget(self, action: #selector(refreshControlPulled), for: .valueChanged)

        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        postController.fetchPosts {
            self.reloadTableView()
        }
        // Do any additional setup after loading the view.
    }
    
    @IBAction func addButtonTapped(_ sender: Any) {
        presentNewPostAlert()
    }
    
    @objc func refreshControlPulled() {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        postController.fetchPosts {
            self.reloadTableView()
            DispatchQueue.main.async { self.refreshControl.endRefreshing()}
        }
        
        
    }
    
    func presentNewPostAlert() {
        let alertContoller = UIAlertController(title: "New message", message: nil, preferredStyle: .alert)
        
        var userNameTextField = UITextField()
        alertContoller.addTextField { (userName) in
            userName.placeholder = "Enter username..."
            userNameTextField = userName
        }
        
        var messageTextField = UITextField()
        alertContoller.addTextField { (message) in
            message.placeholder = "Enter message..."
            messageTextField = message
        }
        
        let postAction = UIAlertAction(title: "Post", style: .default) { (postAction) in
            guard let username = userNameTextField.text, !username.isEmpty,
                let text = messageTextField.text, !text.isEmpty else {
                    return
            }
            self.postController.addNewPostWith(username: username, text: text, completion: {
                self.reloadTableView()
            })
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alertContoller.addAction(postAction)
        alertContoller.addAction(cancelAction)
        
        self.present(alertContoller, animated: true, completion: nil)
    }
    
    func reloadTableView() {
        DispatchQueue.main.async {
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            self.tableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return postController.posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "postCell", for: indexPath)
        
        let post = postController.posts[indexPath.row]
        
        cell.textLabel?.text = post.text
        cell.detailTextLabel?.text = "\(post.username) - \(Date(timeIntervalSince1970: post.timestamp))"
        
        return cell
    }

}
