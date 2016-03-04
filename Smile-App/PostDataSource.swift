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
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return posts.count
        
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("UICollectionViewCell", forIndexPath: indexPath) as PostCollecionViewCell
        
        let post = posts[indexPath.row]
        cell.updateWithImage(post.image)
        
        return cell
        
    }
    
}
