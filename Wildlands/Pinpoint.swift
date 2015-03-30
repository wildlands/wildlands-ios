//
//  Pinpoint.swift
//  Wildlands
//
//  Created by Jan on 24-03-15.
//  Copyright (c) 2015 INF2A. All rights reserved.
//

import Foundation
import UIKit

class Pinpoint : NSObject, NSCoding {
    
    var xPos: CGFloat = 0
    var yPos: CGFloat = 0
    var id: Int = 0;
    var image: String = ""
    var name: String = ""
    var pinDescription: String = ""
    var typeName: String = ""
    
    override init() {
        
        super.init()
        
    }
    
    required init(coder aDecoder: NSCoder) {
        
        super.init()
        
        xPos = aDecoder.decodeObjectForKey("xPos") as CGFloat
        yPos = aDecoder.decodeObjectForKey("yPos") as CGFloat
        id = aDecoder.decodeObjectForKey("id") as Int
        image = aDecoder.decodeObjectForKey("image") as String
        name = aDecoder.decodeObjectForKey("name") as String
        pinDescription = aDecoder.decodeObjectForKey("pinDescription") as String
        typeName = aDecoder.decodeObjectForKey("typeName") as String
        
        
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        
        aCoder.encodeObject(xPos, forKey: "xPos")
        aCoder.encodeObject(yPos, forKey: "yPos")
        aCoder.encodeObject(id, forKey: "id")
        aCoder.encodeObject(image, forKey: "image")
        aCoder.encodeObject(name, forKey: "name")
        aCoder.encodeObject(pinDescription, forKey: "pinDescription")
        aCoder.encodeObject(typeName, forKey: "typeName")
        
    }
    
}
