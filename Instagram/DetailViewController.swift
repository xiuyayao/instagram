//
//  DetailViewController.swift
//  Instagram
//
//  Created by Xiuya Yao on 6/29/17.
//  Copyright © 2017 Xiuya Yao. All rights reserved.
//

import UIKit
import Parse
import ParseUI

class DetailViewController: UIViewController {
    
    @IBOutlet weak var photoAuthor: UILabel!
    @IBOutlet weak var detailImageView: PFImageView!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var captionLabel: UILabel!
    
    var instagramPost: PFObject!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        detailImageView.file = instagramPost["media"] as? PFFile
        captionLabel.text = instagramPost["caption"] as? String
        
        let author = instagramPost["author"] as! PFUser
        photoAuthor.text = author.username
        // authorLabel.text = "Username: " + author.username!
        authorLabel.text = author.username

        if let date = instagramPost.createdAt {
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .medium
            dateFormatter.timeStyle = .short
            let dateString = dateFormatter.string(from: date)
            // dateLabel.text = "Date: " + dateString
            dateLabel.text = "Posted on " + dateString
            print(dateString) // Prints: Jun 28, 2017, 2:08 PM
        }
        
        detailImageView.loadInBackground()
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
