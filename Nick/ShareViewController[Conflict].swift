//
//  ShareViewController.swift
//  Nick
//
//  Created by Nam (Nick) N. HUYNH on 3/16/16.
//  Copyright (c) 2016 Enclave. All rights reserved.
//

import UIKit
import Social
import MobileCoreServices

class ShareViewController: SLComposeServiceViewController, AudienceSelectionViewControllerDelegate, NSURLSessionDelegate {

    var imageData: NSData?

    lazy var audienceConfigurationItem: SLComposeSheetConfigurationItem = {
        
       let item = SLComposeSheetConfigurationItem()
        item.title = "Audience"
        item.value = AudienceSelectionViewController.defaultAudience()
        item.tapHandler = 
        
    }()
    
    override func isContentValid() -> Bool {
        
        if let data = imageData {
            
            if countElements(contentText) > 0 {
                
                return true
                
            }
            
        }
        return false
    }
    
    override func presentationAnimationDidFinish() {
        
        super.presentationAnimationDidFinish()
        placeholder = "Your Comments"
        let content = extensionContext?.inputItems[0] as NSExtensionItem
        
        let contentType = kUTTypeImage as NSString
        for attachment in content.attachments as [NSItemProvider] {
            
            if attachment.hasItemConformingToTypeIdentifier(contentType) {
                
                let dispatchQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
                dispatch_async(dispatchQueue, { () -> Void in
                    
                    let strongSelf = self
                    attachment.loadItemForTypeIdentifier(contentType, options: nil, completionHandler: { (content, error) -> Void in
                        
                        if let data = content as? NSData {
                            
                            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                                
                                strongSelf.imageData = data
                                strongSelf.validateContent()
                                
                            })
                            
                        }
                        
                    })
                    
                })
                
            }
            
            break
            
        }
        
    }

    override func didSelectPost() {
        
        let identifier = NSBundle.mainBundle().bundleIdentifier! + "." + NSUUID().UUIDString
        let configuration = NSURLSessionConfiguration.backgroundSessionConfigurationWithIdentifier(identifier)
        let session = NSURLSession(configuration: configuration, delegate: self, delegateQueue: nil)
        let url = NSURL(string: "" + contentText)!
        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "POST"
        request.HTTPBody = imageData!
        
        let task = session.uploadTaskWithRequest(request, fromData: request.HTTPBody)
        task.resume()
        self.extensionContext!.completeRequestReturningItems([], completionHandler: nil)
        
    }

    override func configurationItems() -> [AnyObject]! {
        // To add configuration options via table cells at the bottom of the sheet, return an array of SLComposeSheetConfigurationItem here.
        return NSArray()
    }

}
