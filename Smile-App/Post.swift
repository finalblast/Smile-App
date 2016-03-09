//
//  Post.swift
//  Smile-App
//
//  Created by Nam (Nick) N. HUYNH on 3/3/16.
//  Copyright (c) 2016 Enclave. All rights reserved.
//

import UIKit

class Post {
    
    let id: String
    let caption: String
    let imageURLs: [String: AnyObject]
    let mediaLinks: [String: AnyObject]?
    let link: NSURL
    var image: UIImage?
    let votes: [String: AnyObject]
    let comments: [String: AnyObject]
    
    
    init(id: String, caption: String, urls: [String: AnyObject], mediaLinks: [String: AnyObject]?, link: NSURL, votes: [String: AnyObject], comments: [String: AnyObject]) {
        
        self.id = id
        self.caption = caption
        self.imageURLs = urls
        self.mediaLinks = mediaLinks
        self.link = link
        self.votes = votes
        self.comments = comments
        
    }
    
}

extension Post: Equatable {}

func ==(lhs: Post, rhs: Post) -> Bool {
    
    return lhs.id == rhs.id
    
}
