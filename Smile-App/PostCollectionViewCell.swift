//
//  PostCollectionViewCell.swift
//  Smile-App
//
//  Created by Nam (Nick) N. HUYNH on 3/4/16.
//  Copyright (c) 2016 Enclave. All rights reserved.
//

import UIKit

class PostCollecionViewCell: UICollectionViewCell {
    
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var spinner: UIActivityIndicatorView!
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        updateWithImage(nil)
        
    }
    
    override func prepareForReuse() {
        
        super.prepareForReuse()
        updateWithImage(nil)
        
    }
 
    func updateWithImage(image: UIImage?) {
        
        if let imageToDisplay = image {
            
            spinner.stopAnimating()
            imageView.image = imageToDisplay
            
        } else {
            
            spinner.startAnimating()
            imageView.image = nil
            
        }
        
    }
    
}
