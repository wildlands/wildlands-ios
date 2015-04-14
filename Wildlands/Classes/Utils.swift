//
//  Utils.swift
//  Wildlands
//
//  Created by Jan on 26-03-15.
//  Copyright (c) 2015 INF2A. All rights reserved.
//

import UIKit

class Utils: NSObject {
    
    class func saveObjectToDisk(object: AnyObject, forKey: String) {
        
        let data: NSData = NSKeyedArchiver.archivedDataWithRootObject(object)
        let defaults: NSUserDefaults = NSUserDefaults.standardUserDefaults()
        defaults.setObject(data, forKey: forKey)
        defaults.synchronize()
        
    }
    
    class func openObjectFromDisk(forKey: String) -> AnyObject {
        
        let defaults: NSUserDefaults = NSUserDefaults.standardUserDefaults()
        let data: NSData = defaults.objectForKey(forKey) as! NSData
        let object: AnyObject? = NSKeyedUnarchiver.unarchiveObjectWithData(data)
        
        return object!
        
    }
   
}