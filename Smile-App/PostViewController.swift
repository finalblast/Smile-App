//
//  PostViewController.swift
//  Smile-App
//
//  Created by Nam (Nick) N. HUYNH on 3/4/16.
//  Copyright (c) 2016 Enclave. All rights reserved.
//

import UIKit

class PostViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    
    var post: Post! {
        
        didSet {
            
            navigationItem.title = post.caption
            
        }
        
    }
    
    var store: PostStore!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        store.fetchImageForPost(post, completion: { (imageResult) -> Void in
            
            switch(imageResult) {
                
            case let ImageResult.Success(image):
                
                NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                    
                    self.imageView.image = image
                    
                })
                
            case let ImageResult.Failure(error):
                
                println(error)
                
            }
            
        })
        
    }
    
}
