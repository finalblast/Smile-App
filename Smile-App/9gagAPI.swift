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
    
        let components = NSURLComponents(string: baseURLString)!
        var queryItems = [NSURLQueryItem]()
        
        let baseParams = [
                            "method": method.rawValue,
                            "format": "json"
                        ]
        
        for (key, value) in baseParams {
            
            let item = NSURLQueryItem(name: key, value: value)
            queryItems.append(item)
            
        }
        
        if let additionalParams = parameter {
            
            for (key, value) in additionalParams {
                
                let item = NSURLQueryItem(name: key, value: value)
                queryItems.append(item)
                
            }
            
        }
        
        components.queryItems = queryItems
        
        return components.URL!
    
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
//        let isMedia = json["media"] as Bool
        let link = json["link"] as String
        let postLink = NSURL(string: link)

        return Post(id: postId, caption: caption, urls: imageURLs, link: postLink!)
        
    }
    
}