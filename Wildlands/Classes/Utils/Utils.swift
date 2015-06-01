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
    
    /**
        Save a object to the disk.
        
        :param: object        The object to be saved (needs to conform to NSCoding)
        :param: forKey        The key to save the object to
     */
    class func saveObjectToDisk(object: AnyObject, forKey: String) {
        
        let data: NSData = NSKeyedArchiver.archivedDataWithRootObject(object)
        let defaults: NSUserDefaults = NSUserDefaults.standardUserDefaults()
        defaults.setObject(data, forKey: forKey)
        defaults.synchronize()
        
    }
    
    /**
        Retreives a object from the disk
    
        :param: forKey          The key from the object to be retreived
        
        :returns:               An AnyObject
     */
    class func openObjectFromDisk(forKey key: String) -> AnyObject? {
        
        // Get standard UserDefaults
        let defaults: NSUserDefaults = NSUserDefaults.standardUserDefaults()
        
        // Check if requested object for key exists
        if let data = defaults.objectForKey(key) as? NSData {
            
            let object: AnyObject? = NSKeyedUnarchiver.unarchiveObjectWithData(data)
            return object
            
        } else {
            
            return nil
            
        }
        
    }
    
    /**
        Converts a string with Font Awesome Icon to UIImage
    
        :param: string        The string to be converted
        :param: color         The color for the icon
        
        :returns:             A UIImage with the icon
     */
    class func fontAwesomeToImageWith(#string: NSString, andColor color: UIColor) -> UIImage {
        
        // Calculate the size for the image
        var size = string.sizeWithAttributes([ NSFontAttributeName : Fonts.fontAwesomeFont(40.0)])
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        
        // Draw the string
        string.sizeWithAttributes([ NSFontAttributeName : Fonts.fontAwesomeFont(40.0)])
        string.drawAtPoint(CGPointMake(0, 0), withAttributes: [ NSFontAttributeName : Fonts.fontAwesomeFont(40.0),
            NSForegroundColorAttributeName : color])
        
        // Convert string to UIImage
        var image: UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image
        
    }
   
}