//
//  MainViewController.swift
//  Smile-App
//
//  Created by Nam (Nick) N. HUYNH on 3/3/16.
//  Copyright (c) 2016 Enclave. All rights reserved.
//

import UIKit
import AVFoundation

class MainViewController: UIViewController, UICollectionViewDelegate {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var store: PostStore!
    var postDataSource = PostDataSource()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        if let layout = collectionView?.collectionViewLayout as? _9gagLayout {
            
            layout.delegate = self
            
        }
        
        collectionView.dataSource = postDataSource
        collectionView.delegate = self
        
        store.fetchPosts(method: Method.Fresh) { (postsResult) -> Void in
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
                    
                    cell.updateWithPost(post)
                    
                }
                
            })
            
        })
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "ShowPost" {
            
            if let selectedIndexPath = collectionView.indexPathsForSelectedItems()?.first as? NSIndexPath {
                
                let post = postDataSource.posts[selectedIndexPath.row]
                let destinationVC = segue.destinationViewController as PostViewController
                destinationVC.post = post
                destinationVC.store = store
                
            }
            
        }
        
    }
    
}

extension MainViewController: _9gagLayoutDelegate {

    func collectionView(collecitonView: UICollectionView, heightForPostAtIndexPath indexPath: NSIndexPath, withWidth width: CGFloat) -> CGFloat {
    
        let post = postDataSource.posts[indexPath.row]
        let boundingRect =  CGRect(x: 0, y: 0, width: width, height: CGFloat(MAXFLOAT))
        if let image = post.image {

            let rect  = AVMakeRectWithAspectRatioInsideRect(post.image!.size, boundingRect)
            return rect.size.height
            
        } else {
            
            return CGFloat(0)
            
        }
    
    }
    
    func collectionView(collecitonView: UICollectionView, heightForAnnotationAtIndexPath indexPath: NSIndexPath, withWidth width: CGFloat) -> CGFloat {
        
        let annotationPadding = CGFloat(4)
        let annotationHeaderHeight = CGFloat(17)
        let post = postDataSource.posts[indexPath.row]
        let commentHeight = CGFloat(106)
        let height = annotationPadding + annotationHeaderHeight + commentHeight + annotationPadding
        return height
        
    }

}

