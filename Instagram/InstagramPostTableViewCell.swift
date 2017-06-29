//
//  InstagramPostTableViewCell.swift
//  Instagram
//
//  Created by Xiuya Yao on 6/28/17.
//  Copyright © 2017 Xiuya Yao. All rights reserved.
//

import UIKit
import ParseUI

class InstagramPostTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var photoAuthor: UILabel!
    
    @IBOutlet weak var photoView: PFImageView!
    
    @IBOutlet weak var photoCaption: UILabel!

    var instagramPost: PFObject! {
        didSet {
            // AUTHOR PART DOES NOT WORK... HOW TO DISPLAY USERNAME
            self.photoAuthor.text = instagramPost["_p_author"] as? String
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
