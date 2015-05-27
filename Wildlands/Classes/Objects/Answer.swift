//
//  Answer.swift
//  Wildlands
//
//  Created by Jan on 18-03-15.
//  Copyright (c) 2015 INF2A. All rights reserved.
//

import Foundation

class Answer: NSObject, NSCoding {

    var text: String = ""
    var isRightAnswer: Bool = false
    
    override init() {
        
        super.init()
        
    }
    
    required init(coder aDecoder: NSCoder) {
        
        super.init()
        
        text = aDecoder.decodeObjectForKey("text") as! String
        isRightAnswer = aDecoder.decodeObjectForKey("isRightAnswer") as! Bool
        
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        
        aCoder.encodeObject(text, forKey: "text")
        aCoder.encodeObject(isRightAnswer, forKey: "isRightAnswer")
        
    }
    
}
