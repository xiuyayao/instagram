//
//  HomeViewController.swift
//  Instagram
//
//  Created by Xiuya Yao on 6/27/17.
//  Copyright © 2017 Xiuya Yao. All rights reserved.
//

import UIKit
import Parse
import ParseUI

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet weak var tableView: UITableView!
    
    var posts: [PFObject]?
    
    
    func refresh() {
        let query = PFQuery(className: "Post")
        query.order(byDescending: "createdAt")
        query.includeKey("_p_author")
        query.includeKey("_created_at")
        query.limit = 20
        
        // for infinite scrolling
        // query.skip = self.count
        // self.count = self.count + 20
        
        // fetch data asynchronously
        query.findObjectsInBackground { (posts: [PFObject]?, error: Error?) in
            if let posts = posts {
                // do something with array of objects returned by cell
                if self.posts != nil {
                    self.posts!.append(contentsOf: posts)
                } else {
                    self.posts = posts
                }
                // for debugging
                print("Number of posts: \(posts.count)")
                // let post = posts[0]
                
                // print("Created at: \(post.createdAt)")
                // self.loadingMoreView!.stopAnimating
                // self.isMoreDataLoading = false
                self.tableView.reloadData()
            } else {
                print(error!.localizedDescription)
            }
        }
        
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let posts = self.posts {
            return posts.count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Hey go find thing with the identifier InstagramPostTableViewCell and cast it as InstagramPostTableViewCell
        let cell = tableView.dequeueReusableCell(withIdentifier: "InstagramPostTableViewCell", for: indexPath) as! InstagramPostTableViewCell
        let post = self.posts![indexPath.row] // posts is an optional and could be nil
        cell.instagramPost = post
        
        return cell
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
        
        refresh()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
