//
//  MainViewController.swift
//  Smile-App
//
//  Created by Nam (Nick) N. HUYNH on 3/3/16.
//  Copyright (c) 2016 Enclave. All rights reserved.
//

import UIKit

class MainViewController: UIViewController, UICollectionViewDelegate {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var store: PostStore!
    var postDataSource = PostDataSource()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        collectionView.dataSource = postDataSource
        collectionView.delegate = self
        
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
    
    func collectionView(collectionView: UICollectionView, willDisplayCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
        
        let post = postDataSource.posts[indexPath.row]
        store.fetchImageForPost(post, completion: { (imageResult) -> Void in
            
            NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                
                let postIndex = find(self.postDataSource.posts, post)!
                let postIndexPath = NSIndexPath(forRow: postIndex, inSection: 0)
                
                if let cell = collectionView.cellForItemAtIndexPath(postIndexPath) as? PostCollecionViewCell {
                    
                    cell.updateWithImage(post.image)
                    
                }
                
            })
            
        })
        
    }
    
}
