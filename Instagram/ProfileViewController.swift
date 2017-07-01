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

class ProfileViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UIScrollViewDelegate {
    
    @IBAction func logoutUser(_ sender: UIButton) {
        
        // NotificationCenter.default.post(name: NSNotification.Name("didLogout"), object: nil)

        PFUser.logOutInBackground { (error: Error?) in
        }
            
            // PFUser.currentUser() will now be nil
            print("User logged out successfully")
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let loginViewController = storyboard.instantiateViewController(withIdentifier: "LoginViewController")
        present(loginViewController, animated: true)  {
            
        }

            // go back to login by dismissing modal view
            // self.dismiss(animated: true, completion: nil)
            
            // go back to login by segue
            // self.performSegue(withIdentifier: "logoutSegue", sender: nil)
    }
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var posts: [PFObject] = []
    // PULL TO REFRESH DOES NOT WORK FOR COLLECTION VIEW
    var refreshControl: UIRefreshControl!
    
    // Create a flag
    var isMoreDataLoading = false
    var loadingMoreView: InfiniteScrollActivityView?
    
    func refresh(withLimit limit: Int = 15) {
        
        let query = PFQuery(className: "Post")
        query.whereKey("author", equalTo: PFUser.current()!)
        query.order(byDescending: "createdAt")
        query.includeKey("author")
        // HELP: WHEN TO USE createdAt and _created_at
        // query.includeKey("_created_at")
        query.limit = limit
        
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
                print("Number of posts in Home Feed: \(posts.count)")
                // let post = posts[0]
                
                // Stop the loading indicator
                self.loadingMoreView?.stopAnimating()
                // Update flag
                self.isMoreDataLoading = false
                // Reload the tableView now that there is new data
                self.collectionView.reloadData()
                
            } else {
                print(error!.localizedDescription)
            }
            self.refreshControl.endRefreshing()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.posts.count
        /*
        if let posts = self.posts {
            return posts.count
        } else {
            return 0
        }
        */
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProfileCollectionViewCell", for: indexPath) as! ProfileCollectionViewCell
        let post = self.posts[indexPath.row] // posts is an optional and could be nil
        cell.instagramPost = post
        
        return cell
    }
    
    func didPullToRefresh(_ refreshControl: UIRefreshControl) {
        refresh()
        self.collectionView.reloadData()
        // self.refreshControl.endRefreshing()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (!isMoreDataLoading) {
            // Calculate the position of one screen length before the bottom of the results
            let scrollViewContentHeight = collectionView.contentSize.height
            let scrollOffsetThreshold = scrollViewContentHeight - collectionView.bounds.size.height
            
            // When the user has scrolled past the threshold, start requesting
            if(scrollView.contentOffset.y > scrollOffsetThreshold && collectionView.isDragging) {
                isMoreDataLoading = true
                
                // Update position of loadingMoreView, and start loading indicator
                let frame = CGRect(x: 0, y: collectionView.contentSize.height, width: collectionView.bounds.size.width, height: InfiniteScrollActivityView.defaultHeight)
                loadingMoreView?.frame = frame
                loadingMoreView!.startAnimating()
                
                // Code to load more results
                refresh(withLimit: self.posts.count + 15)
            }
        }
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        collectionView.delegate = self
        collectionView.dataSource = self
        
        refreshControl = UIRefreshControl()
        
        // If it had an event, who is it going to notify?
        refreshControl.addTarget(self, action: #selector(ProfileViewController.didPullToRefresh(_:)), for: .valueChanged)
        collectionView.insertSubview(refreshControl, at: 0)
        
        // Set up Infinite Scroll loading indicator
        let frame = CGRect(x: 0, y: collectionView.contentSize.height, width: collectionView.bounds.size.width, height: InfiniteScrollActivityView.defaultHeight)
        loadingMoreView = InfiniteScrollActivityView(frame: frame)
        loadingMoreView!.isHidden = true
        collectionView.addSubview(loadingMoreView!)
        
        var insets = collectionView.contentInset
        insets.bottom += InfiniteScrollActivityView.defaultHeight
        collectionView.contentInset = insets
        
        refresh()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let cell = sender as! UICollectionViewCell
        
        if let indexPath = collectionView.indexPath(for: cell) {
            
            let post = posts[indexPath.row]
            let detailViewController = segue.destination as! DetailViewController
            detailViewController.instagramPost = post
        }
    }
    
    class InfiniteScrollActivityView: UIView {
        var activityIndicatorView: UIActivityIndicatorView = UIActivityIndicatorView()
        static let defaultHeight:CGFloat = 60.0
        
        required init?(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)
            setupActivityIndicator()
        }
        
        override init(frame aRect: CGRect) {
            super.init(frame: aRect)
            setupActivityIndicator()
        }
        
        override func layoutSubviews() {
            super.layoutSubviews()
            activityIndicatorView.center = CGPoint(x: self.bounds.size.width/2, y: self.bounds.size.height/2)
        }
        
        func setupActivityIndicator() {
            activityIndicatorView.activityIndicatorViewStyle = .gray
            activityIndicatorView.hidesWhenStopped = true
            self.addSubview(activityIndicatorView)
        }
        
        func stopAnimating() {
            self.activityIndicatorView.stopAnimating()
            self.isHidden = true
        }
        
        func startAnimating() {
            self.isHidden = false
            self.activityIndicatorView.startAnimating()
        }
    }
}
