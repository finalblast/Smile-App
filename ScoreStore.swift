//
//  ScoreStore.swift
//  Smile-App
//
//  Created by Nam (Nick) N. HUYNH on 3/15/16.
//  Copyright (c) 2016 Enclave. All rights reserved.
//

import UIKit

class ScoreStore {
    
    func setScore(score: Int, forKey key: String) {
        
        NSUserDefaults.standardUserDefaults().setInteger(score, forKey: key)
        NSUserDefaults.standardUserDefaults().synchronize()
        
    }
    
    func scoreForKey(key: String) -> Int {
        
        return NSUserDefaults.standardUserDefaults().integerForKey(key)
            
    }
    
}
