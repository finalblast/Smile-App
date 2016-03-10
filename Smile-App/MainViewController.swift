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
    @IBOutlet weak var hotButton: UIButton!
    @IBOutlet weak var trendingButton: UIButton!
    @IBOutlet weak var freshButton: UIButton!
    
    var store: PostStore!
    var postDataSource = PostDataSource()
    
    var nextPaging: Bool!
    
    var methodName: Method = Method.Hot {
        
        didSet {

            fetchPosts()
            
        }
        
    }
    
    func fetchPosts() {
        
        store.fetchPosts(method: methodName, nextPaging: nextPaging) { (postsResult) -> Void in
            NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                
                self.hotButton.titleLabel?.textColor = UIColor.redColor()
                self.trendingButton.titleLabel?.textColor = UIColor.blueColor()
                self.freshButton.titleLabel?.textColor = UIColor.blueColor()
                
                switch postsResult {
                    
                case let PostResult.Success(posts):
                    
                    for post in posts {
                        
                        self.store.fetchImageForPost(post, completion: { (imageResult) -> Void in

                            
                            
                        })
                    
                    }
                    
                    if self.nextPaging! {
                        
                        self.postDataSource.posts.extend(posts)
                        
                    } else {
                        
                        self.postDataSource.posts = posts
                        self.collectionView.setContentOffset(CGPointZero, animated: true)
                        
                    }

                    self.postDataSource.store = self.store
                    
                case let PostResult.Failure(error):
                    
                    println("Error: \(error)")
                    self.postDataSource.posts.removeAll()
                    
                }
                self.collectionView.reloadData()
                self.isLoadingMore = false
                println(self.postDataSource.posts.count)
                
            })
            
        }
        
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        if let layout = collectionView?.collectionViewLayout as? _9gagLayout {
            
            layout.delegate = self
            
        }
        
        collectionView.dataSource = postDataSource
        collectionView.delegate = self
        nextPaging = false
        methodName = Method.Hot
        
    }
    
    func collectionView(collectionView: UICollectionView, didEndDisplayingCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
        
        if let cell = collectionView.cellForItemAtIndexPath(indexPath) as? PostCollecionViewCell {
            
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
                let navController = segue.destinationViewController as UINavigationController
                let destinationVC = navController.topViewController as PostViewController
                destinationVC.post = post
                destinationVC.store = store
                
            }
            
        }
        
    }
    
    // MARK: Scroll delegate

    var isLoadingMore = false
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        
        let offset = scrollView.contentOffset
        let bounds = scrollView.bounds
        let size = scrollView.contentSize
        let inset = scrollView.contentInset
        let y = offset.y + bounds.size.height - inset.bottom
        let h = size.height
        
        let min_reload_distance = CGFloat(-100)
        let max_reload_distance = CGFloat(1000)
        if !isLoadingMore && (h + min_reload_distance < y  || y > h + max_reload_distance) {
            
            println("load more rows")
            isLoadingMore = true
            
            nextPaging = true
            fetchPosts()
            
        }
        
    }
    
    // MARK: Buttons clicked
    
    @IBAction func hotClicked(sender: AnyObject) {
        
        nextPaging = false
        methodName = Method.Hot
        
    }
    
    @IBAction func trendingClicked(sender: AnyObject) {

        nextPaging = false
        methodName = Method.Trending
        
    }
    
    @IBAction func freshClicked(sender: AnyObject) {
        
        nextPaging = false
        methodName = Method.Fresh
        
    }
    
}

extension MainViewController: _9gagLayoutDelegate {
    
    func collectionView(collecitonView: UICollectionView, heightForPostAtIndexPath indexPath: NSIndexPath, withWidth width: CGFloat) -> CGFloat {
        
        var height = CGFloat(0)
        let boundingRect =  CGRect(x: 0, y: 0, width: width, height: CGFloat(MAXFLOAT))
        
        let post = postDataSource.posts[indexPath.row]
        
        store.fetchImageForPost(post, completion: { (imageResult) -> Void in
            
            switch imageResult {
                
            case let ImageResult.Success(downloadedImage):
                
                let rect  = AVMakeRectWithAspectRatioInsideRect(downloadedImage.size, boundingRect)
                height = rect.size.height
                
            case let ImageResult.Failure(error):
                
                break
                
            }
            
        })
        
        return height
        
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

