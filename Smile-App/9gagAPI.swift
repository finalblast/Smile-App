//
//  9gagAPI.swift
//  Smile-App
//
//  Created by Nam (Nick) N. HUYNH on 3/3/16.
//  Copyright (c) 2016 Enclave. All rights reserved.
//

import UIKit

// MARK: Enums

enum Method: String {
    
    case Token = "token"
    case Hot = "hot"
    case Trending = "trending"
    case Fresh = "fresh"
    
}

enum PostResult {
    
    case Success([Post])
    case Failure(NSError)
    
}

struct _9gagAPI {
    
    private static let baseURLString = "http://infinigag.k3min.eu/"
    
    static var apiToken: String!

    private static func _9gagURL(#method: Method, parameter: [String: String]?) -> NSURL {
    
        println("\(baseURLString)\(method.rawValue)")
        return NSURL(string: "\(baseURLString)\(method.rawValue)")!
    
    }
    
    static func getToken() -> NSURL {
        
        return _9gagURL(method: Method.Token, parameter: nil)
        
    }
    
    static func hotPostsURLWithID(#id: String?) -> NSURL {
        
        if let paramId = id {
            
            return _9gagURL(method: Method.Hot, parameter: ["id": paramId])
            
        } else {
            
            return _9gagURL(method: Method.Hot, parameter: nil)
            
        }
        
    }
    
    static func trendingPostsURLWithID(#id: String?) -> NSURL {
        
        if let paramId = id {
            
            return _9gagURL(method: Method.Trending, parameter: ["id": paramId])
            
        } else {
            
            return _9gagURL(method: Method.Trending, parameter: nil)
            
        }
        
    }
    
    static func freshPostsURLWithID(#id: String?) -> NSURL {
        
        if let paramId = id {
            
            return _9gagURL(method: Method.Fresh, parameter: ["id": paramId])
            
        } else {
            
            return _9gagURL(method: Method.Fresh, parameter: nil)
            
        }
        
    }
    
    static func postsFromJSONData(#data: NSData) -> PostResult {
        
        var error: NSError?
        let jsonObject: AnyObject? = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: &error)
        if let actualError = error {
            
            return PostResult.Failure(actualError)
            
        } else {
            
            let jsonDic = jsonObject as [NSObject: AnyObject]
            let postsArray = jsonDic["data"] as [[String: AnyObject]]
            
            var finalPosts = [Post]()
            for postJSON in postsArray {
                
                if let post = postFromJSONObject(postJSON) {
                
                    finalPosts.append(post)
                    
                } else {
                    
                    println("Error because postFromJSONObject returned nil")
                    
                }
                
            }
            
            return PostResult.Success(finalPosts)
            
        }
        
    }
    
    private static func postFromJSONObject(json: [String: AnyObject]) -> Post? {
        
        let postId = json["id"] as String
        let caption = json["caption"] as String
        let imageURLs = json["images"] as [String: AnyObject]
        let link = json["link"] as String
        let postLink = NSURL(string: link)
        
        if let isMedia = json["media"] as? Bool {

            return Post(id: postId, caption: caption, urls: imageURLs, mediaLinks: nil, link: postLink!)
            
        } else {
            
            let mediaLinks = json["media"] as [String: AnyObject]
            return Post(id: postId, caption: caption, urls: imageURLs, mediaLinks: mediaLinks, link: postLink!)
            
        }

    }
    
}