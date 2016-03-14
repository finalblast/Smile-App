//
//  9gagAPI.swift
//  Smile-App
//
//  Created by Nam (Nick) N. HUYNH on 3/3/16.
//  Copyright (c) 2016 Enclave. All rights reserved.
//

import UIKit
import CoreData

// MARK: Enums

enum Method: String {
    
    case Token = "token"
    case Hot = "hot"
    case Trending = "trending"
    case Fresh = "fresh"
    case Vote = "vote"
    
}

enum PostResult {
    
    case Success([Post])
    case Failure(NSError)
    
}

enum ImageResult {
    
    case Success(UIImage)
    case Failure(NSError)
    
}

enum TokenResult {
    
    case Success(String)
    case Failure(NSError)
    
}

enum VoteResult {
    
    case Success([String : AnyObject])
    case Failure(NSError)
    
}

struct _9gagAPI {
    
    private static let baseURLString = "http://infinigag.k3min.eu/"
    
    private static var nextPagingID: NSString?
    
    private static func _9gagURL(#method: Method, parameter: [String: String]?, isVote: Bool) -> NSURL {
        
        if let param = parameter {
            
            if isVote {
                
                let type = param["type"]!
                let id = param["id"]!
                let access_token = param["token"]!
                println("\(baseURLString)\(method.rawValue)/\(type)/\(id)?access_token=\(access_token)")
                return NSURL(string: "\(baseURLString)\(method.rawValue)/\(type)/\(id)?access_token=\(access_token)")!
                
            }
            
            let id = param["id"]!
            return NSURL(string: "\(baseURLString)\(method.rawValue)/\(id)")!
            
        }
        
        return NSURL(string: "\(baseURLString)\(method.rawValue)")!
        
    }
    
    static func getToken() -> NSURL {
        
        return _9gagURL(method: Method.Token, parameter: nil, isVote: false)
        
    }
    
    static func voteForPost(#type: Type, id: String, token: String) -> NSURL {
        
        return _9gagURL(method: Method.Vote, parameter: ["type" : type.rawValue, "id" : id, "token": token], isVote: true)
        
    }
    
    static func hotPostsURLWithID(#nextPaging: Bool?) -> NSURL {
        
        println(nextPaging)
        
        if nextPaging! {
            
            return _9gagURL(method: Method.Hot, parameter: ["id": nextPagingID!], isVote: false)
            
        } else {
            
            return _9gagURL(method: Method.Hot, parameter: nil, isVote: false)
            
        }
        
    }
    
    static func trendingPostsURLWithID(#nextPaging: Bool?) -> NSURL {
        
        if nextPaging! {
            
            return _9gagURL(method: Method.Trending, parameter: ["id": nextPagingID!], isVote: false)
            
        } else {
            
            return _9gagURL(method: Method.Trending, parameter: nil, isVote: false)
            
        }
        
    }
    
    static func freshPostsURLWithID(#nextPaging: Bool?) -> NSURL {
        
        if nextPaging! {
            
            return _9gagURL(method: Method.Fresh, parameter: ["id": nextPagingID!], isVote: false)
            
        } else {
            
            return _9gagURL(method: Method.Fresh, parameter: nil, isVote: false)
            
        }
        
    }
    
    static func tokenFromJSONData(#data: NSData) -> TokenResult {
        
        var error: NSError?
        let jsonObject: AnyObject? = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: &error)
        
        if let actualError = error {
            
            return TokenResult.Failure(actualError)
            
        } else {
            
            let jsonDic = jsonObject as [NSObject: AnyObject]
            let token = jsonDic["access_token"] as String?
            
            if let userToken = token {
                
                return TokenResult.Success(userToken)
                
            } else {
                
                return TokenResult.Failure(NSError(domain: "Unauthorized", code: 401, userInfo:nil))
                
            }
            
        }
        
    }
    
    static func voteResponseFromData(#data: NSData) -> VoteResult {
        
        var error: NSError?
        let jsonObject: AnyObject? = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: &error)
        
        if let actualError = error {
            
            return VoteResult.Failure(actualError)
            
        } else {
            
            let jsonDic = jsonObject as [String: AnyObject]?
            
            if let dic = jsonDic {
                
                return VoteResult.Success(dic)
                
            } else {
                
                return VoteResult.Failure(NSError(domain: "Unauthorized", code: 401, userInfo:nil))
                
            }
            
        }
        
    }
    
    static func pagingFromJSONData(#data: NSData) -> String? {
        
        var error: NSError?
        let jsonObject: AnyObject? = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: &error)
        if let actualError = error {
            
            return nil
            
        } else {
            
            let jsonDic = jsonObject as [NSObject: AnyObject]
            let paging = jsonDic["paging"] as [String: AnyObject]
            let pagingNext = paging["next"] as String
            
            return pagingNext
            
        }
        
    }
    
    static func postsFromJSONData(#data: NSData, inContext context: NSManagedObjectContext) -> PostResult {
        
        var error: NSError?
        let jsonObject: AnyObject? = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: &error)
        if let actualError = error {
            
            return PostResult.Failure(actualError)
            
        } else {
            
            let jsonDic = jsonObject as [NSObject: AnyObject]
            let postsArray = jsonDic["data"] as [[String: AnyObject]]
            let paging = jsonDic["paging"] as [String: AnyObject]
            nextPagingID = paging["next"] as String
            
            var finalPosts = [Post]()
            for postJSON in postsArray {
                
                if let post = postFromJSONObject(postJSON, inContext: context) {
                    
                    finalPosts.append(post)
                    
                } else {
                    
                    println("Error because postFromJSONObject returned nil")
                    
                }
                
            }
            
            return PostResult.Success(finalPosts)
            
        }
        
    }
    
    private static func postFromJSONObject(json: [String: AnyObject], inContext context: NSManagedObjectContext) -> Post? {
        
        let postId = json["id"] as String
        let caption = json["caption"] as String
        let imageURLs = json["images"] as [String: AnyObject]
        let link = json["link"] as String
        let postLink = NSURL(string: link)
        let votes = json["votes"] as [String: AnyObject]
        let comments = json["comments"] as [String: AnyObject]
        
        let fetchRequest = NSFetchRequest(entityName: "Post")
        var fetchedPhotos: [Post]!
        context.performBlockAndWait() {
            
            fetchedPhotos = context.executeFetchRequest(fetchRequest, error: nil) as [Post]
            
        }
        
        if fetchedPhotos.count > 0 {
            
            return fetchedPhotos.first
            
        }

        var post: Post!
        var mediaLinks: [String: AnyObject]!
        
        if let isMedia = json["media"] as? Bool {
            
            mediaLinks = nil
            
        } else {
            
            mediaLinks = json["media"] as [String: AnyObject]
            
        }
        context.performBlockAndWait() {
            
            post = NSEntityDescription.insertNewObjectForEntityForName("Post", inManagedObjectContext: context) as Post
            post.postID = postId
            post.caption = caption
            post.imageURLs = imageURLs
            post.link = postLink!
            post.votes = votes
            post.comments = comments
            post.mediaLinks = mediaLinks
            
        }
        
        return post
        
    }
    
}