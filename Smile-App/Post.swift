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
//    let isMedia: Bool
    let link: NSURL
    var image: UIImage?
    
    init(id: String, caption: String, urls: [String: AnyObject], link: NSURL) {
        
        self.id = id
        self.caption = caption
        self.imageURLs = urls
//        self.isMedia = isMedia
        self.link = link
        
    }
    
}
