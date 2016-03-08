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

        
        collectionView.dataSource = postDataSource
        collectionView.delegate = self
        
        store.fetchPosts(method: Method.Fresh) { (postsResult) -> Void in
            NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                
                switch postsResult {
                    
                case let PostResult.Success(posts):
                    
                    self.postDataSource.posts = posts
                    self.postDataSource.store = self.store
                    println("Found \(posts.count)")
                    
                case let PostResult.Failure(error):
                    
                    println("Error: \(error)")
                    self.postDataSource.posts.removeAll()
                    
                }
                
                self.collectionView.reloadSections(NSIndexSet(index: 0))
                
            })
            
        }
        
    }
    
    func collectionView(collectionView: UICollectionView, didEndDisplayingCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
        
        let post = postDataSource.posts[indexPath.row]
        let postIndex = find(self.postDataSource.posts, post)!
        let postIndexPath = NSIndexPath(forRow: postIndex, inSection: 0)
        
        if let cell = collectionView.cellForItemAtIndexPath(postIndexPath) as? PostCollecionViewCell {
            
            if let player = cell.avPlayer {
                
                cell.stopPlaymedia(player)
                
            }
            
        }
        
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        let post = postDataSource.posts[indexPath.row]
        let postIndex = find(self.postDataSource.posts, post)!
        let postIndexPath = NSIndexPath(forRow: postIndex, inSection: 0)
        
        if let cell = collectionView.cellForItemAtIndexPath(postIndexPath) as? PostCollecionViewCell {
            
            if let dicMediaURL = post.mediaLinks {
                
                let mediaURLString = dicMediaURL["mp4"] as String
                let mediaURL = NSURL(string: mediaURLString)!
                cell.playMedia(mediaURL)
                
            }
            
        }
        
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
            println(rect.size.height)
            return rect.size.height
            
        } else {
            
            return CGFloat(310)
            
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

