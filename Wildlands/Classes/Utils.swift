//
//  Utils.swift
//  Wildlands
//
//  Created by Jan on 26-03-15.
//  Copyright (c) 2015 INF2A. All rights reserved.
//

import UIKit

enum WildlandsTheme: String, Printable {
    case EMPTY = ""
    case BIO_MIMICRY = "Bio Mimicry"
    case MATERIAAL = "Materiaal"
    case WATER = "Water"
    case ENERGIE = "Energie"
    case DIERENWELZIJN = "Dierenwelzijn"
    
    var description: String {
        return self.rawValue
    }

}

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