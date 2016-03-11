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
    
    var postStore: PostStore!
    var tokenStore: TokenStore!
    
    override func viewWillAppear(animated: Bool) {
        
        super.viewWillAppear(animated)
        println(AppDelegate.sharedInstance.access_token)
        
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        postStore.fetchImageForPost(post, completion: { (imageResult) -> Void in
            
            switch(imageResult) {
                
            case let ImageResult.Success(image):
                
                NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in

                    let imageRatio = image.size.height / image.size.width;
                    
                    self.scrollView.contentSize = CGSizeMake(CGRectGetWidth(self.view.bounds), CGRectGetWidth(self.view.bounds) * imageRatio)
                    self.scrollView.scrollEnabled = true
                    
                    let imageView = UIImageView(image: image)
                    imageView.frame = CGRectMake(8, -64, CGRectGetWidth(self.view.bounds), CGRectGetWidth(self.view.bounds) * imageRatio + 64)
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
    
    @IBAction func likeClicked(sender: AnyObject) {
        
        if AppDelegate.sharedInstance.isLogged {

            postStore.voteForPost(post, type: "like", completion: { (voteResult) -> Void in
                
                println(voteResult)
                
            })
            
        } else {
            
            presentingLogInViewController()
            
        }
        
    }
    
    @IBAction func dislikeClicked(sender: AnyObject) {
        
        if AppDelegate().isLogged {
            
//            store.voteForPost(post)
            
        } else {
            
            presentingLogInViewController()
            
        }
        
    }
    
    @IBAction func commentsClicked(sender: AnyObject) {
        
        if AppDelegate().isLogged {
            
//            store.voteForPost(post)
            
        } else {
            
            presentingLogInViewController()
            
        }
        
    }
    
    func presentingLogInViewController() {
        
        let logInViewController = storyboard?.instantiateViewControllerWithIdentifier("LogInViewController") as LogInViewController
        logInViewController.tokenStore = tokenStore
        presentViewController(logInViewController, animated: true) { () -> Void in
            
            
            
        }
        
    }
    
}
