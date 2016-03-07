//
//  MediaStore.swift
//  Smile-App
//
//  Created by Nam (Nick) N. HUYNH on 3/7/16.
//  Copyright (c) 2016 Enclave. All rights reserved.
//

import UIKit

class MediaStore {
    
    let cache = NSCache()
    
    func setMedia(data: NSData, forKey key: String) {
        
        cache.setObject(data, forKey: key)
        let mediaURL = mediaURLForKey(key)
        
        data.writeToURL(mediaURL, atomically: true)
        
    }
    
    func mediaForKey(key: String) -> NSData? {
        
        if let existingMedia = cache.objectForKey(key) as? NSData {
            
            return existingMedia
            
        }
        
        let mediaURL = mediaURLForKey(key)
        if let mediaFromDisk = NSData(contentsOfFile: mediaURL.path!) {
            
            cache.setObject(mediaFromDisk, forKey: key)
            return mediaFromDisk
            
        }
        
        return nil
        
    }
    
    func mediaURLForKey(key: String) -> NSURL {
        
        let documentDirectories = NSFileManager.defaultManager().URLsForDirectory(NSSearchPathDirectory.DocumentDirectory, inDomains: NSSearchPathDomainMask.UserDomainMask)
        
        let documentDirectory: AnyObject = documentDirectories.first!
        
        return documentDirectory.URLByAppendingPathComponent(key)
        
    }
    
}
