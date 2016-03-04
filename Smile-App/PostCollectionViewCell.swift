//
//  PostCollectionViewCell.swift
//  Smile-App
//
//  Created by Nam (Nick) N. HUYNH on 3/4/16.
//  Copyright (c) 2016 Enclave. All rights reserved.
//

import UIKit

class PostCollecionViewCell: UICollectionViewCell {
    
    @IBOutlet var captionLabel: UILabel!
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var spinner: UIActivityIndicatorView!
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        updateWithPost(nil)
        
    }
    
    override func prepareForReuse() {
        
        super.prepareForReuse()
        updateWithPost(nil)
        
    }
 
    func updateWithPost(post: Post?) {
        
        captionLabel.text = post?.caption
        
        if let imageToDisplay = post?.image {
            
            spinner.stopAnimating()
            imageView.image = imageToDisplay
            
        } else {
            
            spinner.startAnimating()
            imageView.image = nil
            
        }
        
    }
    
}
