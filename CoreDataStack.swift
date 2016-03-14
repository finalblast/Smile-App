//
//  CoreDataStack.swift
//  Smile-App
//
//  Created by Nam (Nick) N. HUYNH on 3/14/16.
//  Copyright (c) 2016 Enclave. All rights reserved.
//

import UIKit
import CoreData

class CoreDataStack {
    
    let managedObjectModelName: String
    
    private lazy var managedObjectModel: NSManagedObjectModel = {
        
        let modelURL = NSBundle.mainBundle().URLForResource(self.managedObjectModelName, withExtension: "momd")!
        return NSManagedObjectModel(contentsOfURL: modelURL)!
        
    }()
    
    private lazy var applicationDocumentsDirectory: NSURL = {
        
       let urls = NSFileManager.defaultManager().URLsForDirectory(NSSearchPathDirectory.DocumentDirectory, inDomains: NSSearchPathDomainMask.UserDomainMask)
        return urls.first! as NSURL
        
    }()
    
    private lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        
        var coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let pathComponent = "\(self.managedObjectModelName).sqlite"
        let url = self.applicationDocumentsDirectory.URLByAppendingPathComponent(pathComponent)
        
        var error: NSError?
        let store = coordinator.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: url, options: nil, error: &error)
        if let actualError = error {
            
            println(actualError.description)
            
        }
        return coordinator
        
    }()
    
    lazy var mainQueueContext: NSManagedObjectContext = {
        
       let moc = NSManagedObjectContext(concurrencyType: NSManagedObjectContextConcurrencyType.MainQueueConcurrencyType)
        moc.persistentStoreCoordinator = self.persistentStoreCoordinator
        println("Success")
        return moc
        
    }()
    
    required init(modelName: String) {
        
        managedObjectModelName = modelName
        
    }
    
    func saveChanges() {
        
        var error: NSError?
        mainQueueContext.performBlockAndWait { () -> Void in
            
            if self.mainQueueContext.hasChanges {
                
                self.mainQueueContext.save(&error)
                
            }
            
        }
        
        if let actualError = error {
            
            println(actualError.description)
            
        }
        
    }
    
}
