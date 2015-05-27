//
//  Level.swift
//  Wildlands
//
//  Created by Jan Doornbos on 18-05-15.
//  Copyright (c) 2015 INF2A. All rights reserved.
//

import UIKit

class Level: NSObject, NSCoding {
   
    var id: Int = 0
    var name: String = ""
    
    override init() {
        super.init()
    }
    
    required init(coder aDecoder: NSCoder) {
        
        super.init()
        
        id = aDecoder.decodeObjectForKey("id") as! Int
        name = aDecoder.decodeObjectForKey("name") as! String
        
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
     
        aCoder.encodeObject(id, forKey: "id")
        aCoder.encodeObject(name, forKey: "name")
        
    }
    
}
