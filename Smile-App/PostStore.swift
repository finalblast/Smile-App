//
//  PostStore.swift
//  Smile-App
//
//  Created by Nam (Nick) N. HUYNH on 3/3/16.
//  Copyright (c) 2016 Enclave. All rights reserved.
//

import UIKit
import CoreData

class PostStore {
    
    let coreDataStack = CoreDataStack(modelName: "Smile-App")
    var imageStore = ImageStore()
    
    let session: NSURLSession = {
        
        let config = NSURLSessionConfiguration.defaultSessionConfiguration()
        return NSURLSession(configuration: config)
        
        }()
    
    func fetchPosts(#method: Method, nextPaging: Bool,completion: (PostResult) -> Void) {
        
        var url: NSURL!
        
        switch(method) {
            
        case Method.Hot:
            
            url = _9gagAPI.hotPostsURLWithID(nextPaging: nextPaging)
            
        case Method.Trending:
            
            url = _9gagAPI.trendingPostsURLWithID(nextPaging: nextPaging)
            
        case Method.Fresh:
            
            url = _9gagAPI.freshPostsURLWithID(nextPaging: nextPaging)
            
        default:
            
            break
            
        }
        
        let request = NSURLRequest(URL: url)
        
        let task = session.dataTaskWithRequest(request, completionHandler: { (data, response, error) -> Void in
            
            var result = self.processPostsRequest(data: data, error: error)
            switch result {
                
            case let PostResult.Success(posts):
                let mainQueueContext = self.coreDataStack.mainQueueContext
                var error: NSError?
                mainQueueContext.obtainPermanentIDsForObjects(posts, error: &error)
                let objectIDs = posts.map{ $0.objectID }
                let predicate = NSPredicate(format: "self IN %@", objectIDs)
                self.coreDataStack.saveChanges()
                let mainQueuePosts = self.fetchMainQueuePosts(predicate: predicate, sortDescriptors: nil)
                result = PostResult.Success(mainQueuePosts)
                
            case let PostResult.Failure(error):
                println(error.description)
                break
                
            }
            completion(result)
            
        })
        
        task.resume()
        
    }
    
    private func processPostsRequest(#data: NSData?, error: NSError?) -> PostResult {
        
        if let jsonData = data {
            
            return _9gagAPI.postsFromJSONData(data: jsonData, inContext: self.coreDataStack.mainQueueContext)
            
        } else {
            
            return PostResult.Failure(error!)
            
        }
        
    }
    
    func fetchMainQueuePosts(predicate: NSPredicate? = nil, sortDescriptors: [NSSortDescriptor]? = nil) -> [Post] {
        
        let fetchRequest = NSFetchRequest(entityName: "Post")
        
        let mainQueueContext = self.coreDataStack.mainQueueContext
        var mainQueuePosts: [Post]?
        var fetchRequestError: NSError?
        mainQueueContext.performBlockAndWait { () -> Void in
            
            mainQueuePosts = mainQueueContext.executeFetchRequest(fetchRequest, error: &fetchRequestError) as? [Post]
            
        }
        
        if let actualError = fetchRequestError {
            
            println(actualError.description)
            
        }
        
        return mainQueuePosts!
        
    }
    
    func fetchImageForPost(post: Post, completion: (ImageResult) -> Void) {
        
        var semaphore = dispatch_semaphore_create(0)
        
        let postId = post.postID
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
            
            dispatch_semaphore_signal(semaphore)
            completion(result)
            
        })
        
        task.resume()
        
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER)
        
    }
    
    private func processImageRequest(#data: NSData?, error: NSError?) -> ImageResult {
        
        if let imageData = data {
            
            if let image = UIImage(data: imageData) {
                
                return ImageResult.Success(image)
                
            }
                
            return ImageResult.Failure(error!)
            
        } else {
            
            return ImageResult.Failure(error!)
            
        }
        
    }
    
    func voteForPost(post: Post, type: Type, token: String, completion: (VoteResult) -> Void) {
        
        let url = _9gagAPI.voteForPost(type: type, id: post.postID, token: token)
        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "POST"
        
        let task = session.dataTaskWithRequest(request, completionHandler: { (data, response, error) -> Void in
            
            let result = self.processVoteRequest(data: data, error: error)
            completion(result)
            
        })
        
        task.resume()
        
    }
    
    private func processVoteRequest(#data: NSData?, error: NSError?) -> VoteResult {
        
        if let jsonData = data {
            
            return _9gagAPI.voteResponseFromData(data: jsonData)
            
        } else {
            
            return VoteResult.Failure(error!)
            
        }
        
    }
    
}


