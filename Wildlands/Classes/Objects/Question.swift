//
//  Question.swift
//  Wildlands
//
//  Created by Jan on 18-03-15.
//  Copyright (c) 2015 INF2A. All rights reserved.
//

import Foundation

class Question : NSObject, NSCoding {
    
    var text: String = ""
    var answers: [Answer] = []
    var typeName: String = ""
    var levelID: Int = 0
    var imageURL: String = ""
    
    override init() {
        
        super.init()
        
    }
    
    func addAnswer(antwoord: Answer) {
        
        answers.append(antwoord)
        
    }
    
    required init(coder aDecoder: NSCoder) {
        
        super.init()
        
        text = aDecoder.decodeObjectForKey("text") as! String
        answers = aDecoder.decodeObjectForKey("answers") as! [Answer]
        typeName = aDecoder.decodeObjectForKey("typeName") as! String
        levelID = aDecoder.decodeObjectForKey("levelID") as! Int
        imageURL = aDecoder.decodeObjectForKey("imageURL") as! String
        
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        
        aCoder.encodeObject(text, forKey: "text")
        aCoder.encodeObject(answers, forKey: "answers")
        aCoder.encodeObject(typeName, forKey: "typeName")
        aCoder.encodeObject(levelID, forKey: "levelID")
        aCoder.encodeObject(imageURL, forKey: "imageURL")
        
    }
    
}