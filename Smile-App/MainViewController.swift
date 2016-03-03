//
//  MainViewController.swift
//  Smile-App
//
//  Created by Nam (Nick) N. HUYNH on 3/3/16.
//  Copyright (c) 2016 Enclave. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var store: PostStore!
    var postDataSource = PostDataSource()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        collectionView.dataSource = postDataSource
        
        store.fetchHotPosts { (postsResult) -> Void in
            
            NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                
                switch postsResult {
                    
                case let PostResult.Success(posts):
                    
                    println("Found \(posts.count)")
                    self.postDataSource.posts = posts
                    
                    
                case let PostResult.Failure(error):
                    
                    println("Error: \(error)")
                    self.postDataSource.posts.removeAll()
                    
                }
                
                self.collectionView.reloadSections(NSIndexSet(index: 0))
                
            })
            
        }
        
    }
    
}
