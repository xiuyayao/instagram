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
    
    @IBOutlet weak var photoView: PFImageView!

    var instagramPost: PFObject! {
        didSet {
            self.photoView.file = instagramPost["media"] as? PFFile
            self.photoView.loadInBackground()
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
