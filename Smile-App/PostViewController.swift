//
//  PostViewController.swift
//  Smile-App
//
//  Created by Nam (Nick) N. HUYNH on 3/4/16.
//  Copyright (c) 2016 Enclave. All rights reserved.
//

import UIKit

enum Type: String {
    
    case Like = "like"
    case Dislike = "dislike"
    case Unlike = "unlike"
    
}

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
        
        if let isLogged = AppDelegate.sharedInstance.isLogged {

            postStore.voteForPost(post, type: Type.Like, token: AppDelegate.sharedInstance.access_token!, completion: { (voteResult) -> Void in
                
                println(voteResult)
                
            })
            
        } else {
            
            presentingLogInViewController()
            
        }
        
    }
    
    @IBAction func dislikeClicked(sender: AnyObject) {
        
        if AppDelegate().isLogged! {
            
//            store.voteForPost(post)
            
        } else {
            
            presentingLogInViewController()
            
        }
        
    }
    
    @IBAction func commentsClicked(sender: AnyObject) {
        
        if AppDelegate().isLogged! {
            
//            store.voteForPost(post)
            
        } else {
            
            presentingLogInViewController()
            
        }
        
    }
    
    func presentingLogInViewController() {
        
        let logInViewController = storyboard?.instantiateViewControllerWithIdentifier("LogInViewController") as LogInViewController
        logInViewController.tokenStore = tokenStore
        logInViewController.delegate = self
        presentViewController(logInViewController, animated: true) { () -> Void in
            
            
            
        }
        
    }
    
}

extension PostViewController: LogInDelegate {
    
    func loggedIn() {
        
        if let token = AppDelegate.sharedInstance.access_token {
            
            postStore.voteForPost(post, type: Type.Like, token: token, completion: { (voteResult) -> Void in
                
                switch voteResult {
                    
                case let VoteResult.Success(test):
                    
                    let score: AnyObject? = test["score"]
                    if let scoreNum = score as? NSNumber {
                        
                        
                    }
                    
                case let VoteResult.Failure(error):
                    
                    break
                    
                }
                
            })
            
        }
        
    }
    
}
