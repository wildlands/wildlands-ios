//
//  Question.swift
//  Wildlands
//
//  Created by Jan on 18-03-15.
//  Copyright (c) 2015 INF2A. All rights reserved.
//

import Foundation

class Question : NSObject {
    
    var text: String
    var answers: [Answer]
    
    init(text: String) {
        self.text = text;
        self.answers = [];
    }
    
    func addAnswer(antwoord: Answer) {
        
        answers.append(antwoord)
        
    }
    
}