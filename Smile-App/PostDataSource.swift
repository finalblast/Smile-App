//
//  PostDataSource.swift
//  Smile-App
//
//  Created by Nam (Nick) N. HUYNH on 3/3/16.
//  Copyright (c) 2016 Enclave. All rights reserved.
//

import UIKit

class PostDataSource: NSObject, UICollectionViewDataSource {
    
    var posts = [Post]()
    var store: PostStore!
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return posts.count
        
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let post = posts[indexPath.row]
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("UICollectionViewCell", forIndexPath: indexPath) as PostCollecionViewCell
        
        store.fetchImageForPost(post, completion: { (imageResult) -> Void in
            
            switch imageResult {
                
            case let ImageResult.Success(downloadedImage):
                
                post.image = downloadedImage
                NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                    
                        cell.updateWithPost(post)

                })
                
            case let ImageResult.Failure(error):
                
                break
                
            }
            
        })

        collectionView.reloadItemsAtIndexPaths([indexPath])
        collectionView.performBatchUpdates({ () -> Void in
            
            collectionView.collectionViewLayout.invalidateLayout()
            
        }, completion: { (bool) -> Void in
            
            collectionView.collectionViewLayout.invalidateLayout()
            
        })
        
        return cell
        
    }
    
}
