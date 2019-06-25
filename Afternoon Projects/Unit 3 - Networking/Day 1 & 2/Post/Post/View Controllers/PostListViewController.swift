//
//  PostListViewController.swift
//  Post
//
//  Created by Drew Seeholzer on 6/24/19.
//  Copyright © 2019 DevMtnStudent. All rights reserved.
//

import UIKit

class PostListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return postController.posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "postCell", for: indexPath)
        
        let post = postController.posts[indexPath.row]
        
        cell.textLabel?.text = post.text
        cell.detailTextLabel?.text = "\(post.userName) - \(Date(timeIntervalSince1970: post.timeStamp))"
        
        return cell
    }
    
    let postController = PostController()
    
    var refreshControl = UIRefreshControl()

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.refreshControl = refreshControl
        tableView.delegate = self
        tableView.dataSource = self
        postController.fetchPosts {
            self.reloadTableView()
        }
        
        tableView.estimatedRowHeight = 45
        tableView.rowHeight = UITableView.automaticDimension
        
        refreshControl.addTarget(self, action: #selector(refreshControlPulled), for: .valueChanged)

        // Do any additional setup after loading the view.
    }
    
    @objc func refreshControlPulled() {
        postController.fetchPosts {
            DispatchQueue.main.async { self.refreshControl.endRefreshing()}
            self.reloadTableView()
        }
        
        
    }
    func reloadTableView() {
        DispatchQueue.main.async {
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            self.tableView.reloadData()
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
