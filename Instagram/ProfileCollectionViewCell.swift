//
//  ProfileCollectionViewCell.swift
//  Instagram
//
//  Created by Xiuya Yao on 6/29/17.
//  Copyright © 2017 Xiuya Yao. All rights reserved.
//

import UIKit
import Parse
import ParseUI

class ProfileCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var photoView: PFImageView!
    
    var instagramPost: PFObject! {
        didSet {

            // let author = instagramPost["author"] as! PFUser
            // self.photoAuthor.text = author.username!
            
            self.photoView.file = instagramPost["media"] as? PFFile
            self.photoView.loadInBackground()
            // self.photoCaption.text = instagramPost["caption"] as? String
        }
    }
}
