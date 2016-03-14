//
//  Post.swift
//  Smile-App
//
//  Created by Nam (Nick) N. HUYNH on 3/14/16.
//  Copyright (c) 2016 Enclave. All rights reserved.
//

import UIKit
import CoreData

@objc(Post)
class Post: NSManagedObject {
    
    var image: UIImage?
    @NSManaged var postID: String
    @NSManaged var caption: String
    @NSManaged var imageURLs: [String: AnyObject]
    @NSManaged var mediaLinks: [String: AnyObject]?
    @NSManaged var link: NSURL
    @NSManaged var votes: [String: AnyObject]
    @NSManaged var comments: [String: AnyObject]
    
    override func awakeFromInsert() {
        
        super.awakeFromInsert()
        caption = ""
        postID = ""
        imageURLs = [String: AnyObject]()
        mediaLinks = nil
        link = NSURL()
        votes = [String: AnyObject]()
        comments = [String: AnyObject]()
        
    }
    
}
