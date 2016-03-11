//
//  TokenStore.swift
//  Smile-App
//
//  Created by Nam (Nick) N. HUYNH on 3/11/16.
//  Copyright (c) 2016 Enclave. All rights reserved.
//

import UIKit

class TokenStore {
    
    let session: NSURLSession = {
        
       let config = NSURLSessionConfiguration.defaultSessionConfiguration()
        return NSURLSession(configuration: config)
        
    }()
    
    func gettingToken(#data: [String: String!], completion: (TokenResult) -> Void) {
        
        var err: NSError?
        let url = _9gagAPI.getToken()
        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "POST"
        
        let email = data["username"]!
        let password = data["password"]!
        
        let postString = "username=\(email)&password=\(password)"
        request.HTTPBody = postString.dataUsingEncoding(NSUTF8StringEncoding)
        
        let task = session.dataTaskWithRequest(request, completionHandler: { (data, response, error) -> Void in
            
            let result = self.processGettingToken(data: data, error: error)
            completion(result)
            
        })
        
        task.resume()
        
    }
    
    private func processGettingToken(#data: NSData?, error: NSError?) -> TokenResult {
        
        if let jsonData = data {
            
            return _9gagAPI.tokenFromJSONData(data: jsonData)
            
        } else {
            
            return TokenResult.Failure(error!)
            
        }
        
    }
    
}



