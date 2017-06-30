//
//  InstagramPostTableViewCell.swift
//  Instagram
//
//  Created by Xiuya Yao on 6/28/17.
//  Copyright © 2017 Xiuya Yao. All rights reserved.
//

import UIKit
import Parse
import ParseUI

class InstagramPostTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var photoAuthor: UILabel!
    @IBOutlet weak var photoView: PFImageView!
    @IBOutlet weak var photoCaption: UILabel!

    var instagramPost: PFObject! {
        didSet {
            
            let author = instagramPost["author"] as! PFUser
            self.photoAuthor.text = author.username!

            self.photoView.file = instagramPost["media"] as? PFFile
            self.photoView.loadInBackground()
            self.photoCaption.text = instagramPost["caption"] as? String
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
