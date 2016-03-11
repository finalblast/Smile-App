//
//  LogInViewController.swift
//  Smile-App
//
//  Created by Nam (Nick) N. HUYNH on 3/11/16.
//  Copyright (c) 2016 Enclave. All rights reserved.
//

import UIKit

class LogInViewController: UIViewController {
    
    @IBOutlet weak var emailField: UITextField!
    
    @IBOutlet weak var passwordField: UITextField!
    
    var tokenStore: TokenStore!
    
    @IBAction func closeClicked(sender: AnyObject) {
        
        presentingViewController?.dismissViewControllerAnimated(true, completion: { () -> Void in
            
            
            
        })
        
    }
    
    @IBAction func logInClicked(sender: AnyObject) {
        
        let email = emailField.text
        let password = passwordField.text
        
        let data = ["username" : email, "password" : password]
        
        tokenStore.gettingToken(data: data) { (tokenResult) -> Void in
            
            switch tokenResult {
                
            case let TokenResult.Success(token):
                
                let userDefault = NSUserDefaults.standardUserDefaults()
                userDefault.setObject(token, forKey: "Token")
                userDefault.synchronize()
                
                let postViewController = self.presentingViewController as PostViewController
                self.presentingViewController?.dismissViewControllerAnimated(true, completion: { () -> Void in
                    
                    AppDelegate.sharedInstance.isLogged = true
                    AppDelegate.sharedInstance.access_token = token
                    postViewController.viewWillAppear(true)
                    
                })
                
            case let TokenResult.Failure(error):
                
                NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                    
                    let alertView = UIAlertView(title: "Unauthorized", message: error.description, delegate: nil, cancelButtonTitle: "Got it!")
                    alertView.show()
                    
                })
                
            }
            
        }
        
    }
    
}
