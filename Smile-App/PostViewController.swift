//
//  PostViewController.swift
//  Smile-App
//
//  Created by Nam (Nick) N. HUYNH on 3/4/16.
//  Copyright (c) 2016 Enclave. All rights reserved.
//

import UIKit

class PostViewController: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    
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

                    let imageRatio = image.size.height / image.size.width;
                    
                    self.scrollView.contentSize = CGSizeMake(CGRectGetWidth(self.view.bounds), CGRectGetWidth(self.view.bounds) * imageRatio)
                    self.scrollView.scrollEnabled = true
                    self.scrollView.layer.borderWidth = 1.0
                    self.scrollView.layer.borderColor = UIColor.blackColor().CGColor
                    
                    
                    let imageView = UIImageView()
                    imageView.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), CGRectGetWidth(self.view.bounds) * imageRatio)
                    imageView.layer.borderWidth = 1.0
                    imageView.layer.borderColor = UIColor.redColor().CGColor
                    self.scrollView.addSubview(imageView)
                    
                })
                
            case let ImageResult.Failure(error):
                
                println(error)
                
            }
            
        })
        
    }
    
    @IBAction func closeClicked(sender: AnyObject) {
        
        presentingViewController?.dismissViewControllerAnimated(true, completion: { () -> Void in
            
            
            
        })
        
    }
    
}
