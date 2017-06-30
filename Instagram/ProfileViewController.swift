//
//  ProfileViewController.swift
//  Instagram
//
//  Created by Xiuya Yao on 6/27/17.
//  Copyright © 2017 Xiuya Yao. All rights reserved.
//

import UIKit
import Parse
import ParseUI

class ProfileViewController: UIViewController, UICollectionViewDataSource {
    
    @IBAction func logoutUser(_ sender: UIButton) {
        
        PFUser.logOutInBackground { (error: Error?) in
            
            // PFUser.currentUser() will now be nil
            print("User logged out successfully")

            // go back to login by dismissing modal view
            // self.dismiss(animated: true, completion: nil)
            
            // go back to login by segue
            self.performSegue(withIdentifier: "logoutSegue", sender: nil)
        }
    }
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var posts: [PFObject]?
    // PULL TO REFRESH DOES NOT WORK FOR COLLECTION VIEW
    // var refreshControl: UIRefreshControl!
    
    func refresh() {
        
        let query = PFQuery(className: "Post")
        query.whereKey("author", equalTo: PFUser.current()!)
        query.order(byDescending: "createdAt")
        query.includeKey("author")
        // HELP: FOR SAME REASONS AS HOMEVIEWCONTROLLER
        // query.includeKey("_created_at")
        query.limit = 20
        
        // for infinite scrolling
        // query.skip = self.count
        // self.count = self.count + 20
        
        // fetch data asynchronously
        query.findObjectsInBackground { (posts: [PFObject]?, error: Error?) in
            if let posts = posts {
                
                // do something with array of objects returned by cell
                /*
                 if self.posts != nil {
                 self.posts!.append(contentsOf: posts)
                 } else {
                 self.posts = posts
                 }
                 */
                
                self.posts = posts
                
                // for debugging
                print("Number of posts by User: \(posts.count)")
                // let post = posts[0]
                
                // print("Created at: \(post.createdAt)")
                // self.loadingMoreView!.stopAnimating
                // self.isMoreDataLoading = false
                self.collectionView.reloadData()
                
            } else {
                print(error!.localizedDescription)
            }
            
            // self.refreshControl.endRefreshing()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let posts = self.posts {
            return posts.count
        } else {
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProfileCollectionViewCell", for: indexPath) as! ProfileCollectionViewCell
        let post = self.posts![indexPath.row] // posts is an optional and could be nil
        cell.instagramPost = post
        
        return cell
    }
    
    // PULL TO REFRESH DOES NOT WORK FOR COLLECTION VIEW
    /*
    func didPullToRefresh(_ refreshControl: UIRefreshControl) {
        refresh()
        self.collectionView.reloadData()
        // self.refreshControl.endRefreshing()
    }
    */

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        collectionView.delegate = self as? UICollectionViewDelegate
        collectionView.dataSource = self
        
        // refreshControl = UIRefreshControl()
        
        // If it had an event, who is it going to notify?
        // refreshControl.addTarget(self, action: #selector(ProfileViewController.didPullToRefresh(_:)), for: .valueChanged)
        // collectionView.insertSubview(refreshControl, at: 0)
        
        refresh()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let cell = sender as! UICollectionViewCell
        
        if let indexPath = collectionView.indexPath(for: cell) {
            
            let post = posts?[indexPath.row]
            let detailViewController = segue.destination as! DetailViewController
            detailViewController.instagramPost = post
        }
    }
}
