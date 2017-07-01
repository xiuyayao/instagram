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

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    var posts: [PFObject] = []
    var refreshControl: UIRefreshControl!
    
    // Create a flag
    var isMoreDataLoading = false
    var loadingMoreView: InfiniteScrollActivityView?
    
    
    func refresh(withLimit limit: Int = 15) {
        
        let query = PFQuery(className: "Post")
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
                self.tableView.reloadData()
                
            } else {
                print(error!.localizedDescription)
            }
            self.refreshControl.endRefreshing()
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.posts.count
        /*
        if let posts = self.posts {
            return posts.count
        } else {
            return 0
        }
        */
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Hey go find thing with the identifier InstagramPostTableViewCell and cast it as InstagramPostTableViewCell
        let cell = tableView.dequeueReusableCell(withIdentifier: "InstagramPostTableViewCell", for: indexPath) as! InstagramPostTableViewCell
        let post = self.posts[indexPath.row] // posts is an optional and could be nil
        cell.instagramPost = post
        
        return cell
    }
    

    func didPullToRefresh(_ refreshControl: UIRefreshControl) {
        refresh()
        self.tableView.reloadData()
        // self.refreshControl.endRefreshing()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (!isMoreDataLoading) {
            // Calculate the position of one screen length before the bottom of the results
            let scrollViewContentHeight = tableView.contentSize.height
            let scrollOffsetThreshold = scrollViewContentHeight - tableView.bounds.size.height
            
            // When the user has scrolled past the threshold, start requesting
            if(scrollView.contentOffset.y > scrollOffsetThreshold && tableView.isDragging) {
                isMoreDataLoading = true
                
                // Update position of loadingMoreView, and start loading indicator
                let frame = CGRect(x: 0, y: tableView.contentSize.height, width: tableView.bounds.size.width, height: InfiniteScrollActivityView.defaultHeight)
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
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        // tableView.separatorStyle = .singleLine
        // tableView.separatorInset = UIEdgeInsets.zero
        
        tableView.setNeedsLayout()
        tableView.layoutIfNeeded()
        tableView.estimatedRowHeight = 80
        tableView.rowHeight = UITableViewAutomaticDimension
        
        refreshControl = UIRefreshControl()
        
        // If it had an event, who is it going to notify?
        refreshControl.addTarget(self, action: #selector(HomeViewController.didPullToRefresh(_:)), for: .valueChanged)
        tableView.insertSubview(refreshControl, at: 0)
        
        // Set up Infinite Scroll loading indicator
        let frame = CGRect(x: 0, y: tableView.contentSize.height, width: tableView.bounds.size.width, height: InfiniteScrollActivityView.defaultHeight)
        loadingMoreView = InfiniteScrollActivityView(frame: frame)
        loadingMoreView!.isHidden = true
        tableView.addSubview(loadingMoreView!)
        
        var insets = tableView.contentInset
        insets.bottom += InfiniteScrollActivityView.defaultHeight
        tableView.contentInset = insets
        
        refresh()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // pass object through segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        // let cell = sender as! UITableViewCell
        
        let cell = sender as! InstagramPostTableViewCell
        
        if let indexPath = tableView.indexPath(for: cell) {
            
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
