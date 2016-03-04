//
//  ImageStore.swift
//  Homepwner
//
//  Created by Nam (Nick) N. HUYNH on 2/25/16.
//  Copyright (c) 2016 Enclave. All rights reserved.
//

import UIKit

class ImageStore {
    
    let cache = NSCache()
    
    func setImage(image: UIImage, forKey key: String) {
        
        cache.setObject(image, forKey: key)
        
        let imageURL = imageURLForKey(key)
        if let data = UIImagePNGRepresentation(image) {
            
            data.writeToURL(imageURL, atomically: true)
            
        }
        
    }
    
    func imageForKey(key: String) -> UIImage? {
        
        if let existingImage = cache.objectForKey(key) as? UIImage {
            
            return existingImage
            
        }
        
        let imageURL = imageURLForKey(key)
        
        if let imageFromDisk = UIImage(contentsOfFile: imageURL.path!) {
            
            cache.setObject(imageFromDisk, forKey: key)
            return imageFromDisk
            
        }
        
        return nil
        
    }
    
    func deleteImageForKey(key: String) {
        
        cache.removeObjectForKey(key)
        
        let imageURL = imageURLForKey(key)
        let error = NSErrorPointer()
        NSFileManager.defaultManager().removeItemAtURL(imageURL, error: error)
        
    }
    
    func imageURLForKey(key: String) -> NSURL {
        
        let documentsDirectories = NSFileManager.defaultManager().URLsForDirectory(NSSearchPathDirectory.DocumentDirectory, inDomains: NSSearchPathDomainMask.UserDomainMask)
        
        let documentDirectory: AnyObject = documentsDirectories.first!
        return documentDirectory.URLByAppendingPathComponent(key)
        
    }
    
}
