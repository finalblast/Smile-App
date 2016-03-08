//
//  PostStore.swift
//  Smile-App
//
//  Created by Nam (Nick) N. HUYNH on 3/3/16.
//  Copyright (c) 2016 Enclave. All rights reserved.
//

import UIKit

enum ImageResult {
    
    case Success(UIImage)
    case Failure(NSError)
    
}

class PostStore {
    
    var imageStore = ImageStore()
    
    let session: NSURLSession = {
        
        let config = NSURLSessionConfiguration.defaultSessionConfiguration()
        return NSURLSession(configuration: config)
        
        }()
    
    func fetchPosts(#method: Method, completion: (PostResult) -> Void) {
        
        var url: NSURL!
        
        switch(method) {
            
        case Method.Hot:
            
            url = _9gagAPI.hotPostsURLWithID(id: nil)
            
        case Method.Trending:
            
            url = _9gagAPI.trendingPostsURLWithID(id: nil)
            
        case Method.Fresh:
            
            url = _9gagAPI.freshPostsURLWithID(id: nil)
            
        default:
            
            break
            
        }
        
        let request = NSURLRequest(URL: url)
        
        let task = session.dataTaskWithRequest(request, completionHandler: { (data, response, error) -> Void in
            
            let result = self.processPostsRequest(data: data, error: error)
            completion(result)
            
        })
        
        task.resume()
        
    }
    
    func processPostsRequest(#data: NSData?, error: NSError?) -> PostResult {
        
        if let jsonData = data {
            
            return _9gagAPI.postsFromJSONData(data: jsonData)
            
        } else {
            
            return PostResult.Failure(error!)
            
        }
        
    }
    
    func fetchImageForPost(post: Post, completion: (ImageResult) -> Void) {
        
//        var semaphore = dispatch_semaphore_create(0)
        
        let postId = post.id
        if let image = imageStore.imageForKey(postId) {
            
            post.image = image
            completion(ImageResult.Success(image))
            return
            
        }
        
        let postImageURL = post.imageURLs
        let normalPostImageString = postImageURL["normal"] as NSString
        let normalPostImageURL = NSURL(string: normalPostImageString)!
        
        let request = NSURLRequest(URL: normalPostImageURL)
        let task = session.dataTaskWithRequest(request, completionHandler: { (data, response, error) -> Void in
            
            let result = self.processImageRequest(data: data, error: error)
            switch(result) {
                
            case let ImageResult.Success(image):

                post.image = image
                self.imageStore.setImage(image, forKey: postId)
                
            case let ImageResult.Failure(error):
                
                break
                
            }
            
//            dispatch_semaphore_signal(semaphore)
            completion(result)
            
        })
        
        task.resume()
        
//        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER)
        
    }
    
    func processImageRequest(#data: NSData?, error: NSError?) -> ImageResult {
        
        if let imageData = data {
            
            if let image = UIImage(data: imageData) {
                
                return ImageResult.Success(image)
                
            } else {
                
                return ImageResult.Failure(error!)
                
            }
            
        } else {
            
            return ImageResult.Failure(error!)
            
        }
        
    }
    
}


