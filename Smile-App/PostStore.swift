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
    
    let session: NSURLSession = {
        
        let config = NSURLSessionConfiguration.defaultSessionConfiguration()
        return NSURLSession(configuration: config)
        
        }()
    
    func fetchHotPosts(#completion: (PostResult) -> Void) {
        
        let url = _9gagAPI.hotPostsURLWithID(id: nil)
        
        let request = NSURLRequest(URL: url)
        
        let task = session.dataTaskWithRequest(request, completionHandler: { (data, response, error) -> Void in
            
            let result = self.processHotPostsRequest(data: data, error: error)
            completion(result)
            
        })
        
        task.resume()
        
    }
    
    func processHotPostsRequest(#data: NSData?, error: NSError?) -> PostResult {
        
        if let jsonData = data {
            
            return _9gagAPI.postsFromJSONData(data: jsonData)
            
        } else {
            
            return PostResult.Failure(error!)
            
        }
        
    }
    
    func fetchImageForPost(post: Post, completion: (ImageResult) -> Void) {
        
        if let image = post.image {
            
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
                
            case let ImageResult.Failure(error):
                
                break
                
            }
            
            completion(result)
            
        })
        
        task.resume()
        
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


