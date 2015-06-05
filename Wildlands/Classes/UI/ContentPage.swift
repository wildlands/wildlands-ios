//
//  ContentPage.swift
//  Wildlands
//
//  Created by Jan Doornbos on 23-04-15.
//  Copyright (c) 2015 INF2A. All rights reserved.
//

import UIKit
import Foundation

class ContentPage: NSObject, NSCoding {
    
    var image: String = ""
    var title: String = ""
    var content: String = ""
    var level: Int = 0
    
    override init() {
        
        super.init()
        
    }
    
    required init(coder aDecoder: NSCoder) {
        
        super.init()
        
        image = aDecoder.decodeObjectForKey("image") as! String
        title = aDecoder.decodeObjectForKey("title") as! String
        content = aDecoder.decodeObjectForKey("content") as! String
        level = aDecoder.decodeObjectForKey("level") as! Int
        
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
    
        aCoder.encodeObject(image, forKey: "image")
        aCoder.encodeObject(title, forKey: "title")
        aCoder.encodeObject(content, forKey: "content")
        aCoder.encodeObject(level, forKey: "level")
        
    }
    
}