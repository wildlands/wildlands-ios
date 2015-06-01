//
//  ScoreCalculator.swift
//  Wildlands
//
//  Created by Jan Doornbos on 01-06-15.
//  Copyright (c) 2015 INF2A. All rights reserved.
//

import UIKit

class ScoreCalculator: NSObject {
    
    class func calculateScore(score: [Score]) -> (energieGoed: Int, energieTotaal: Int, waterGoed: Int, waterTotaal: Int, materiaalGoed: Int, materiaalTotaal: Int, biomimicryGoed: Int, biomimicryTotaal: Int, dierenwelzijnGoed: Int, dierenwelzijnTotaal: Int, totaal: Int, totaalGoed: Int) {
        
        // Make score tuples
        var energieScore = (totaal: 0, goed: 0)
        var waterScore = (totaal: 0, goed: 0)
        var materialenScore = (totaal: 0, goed: 0)
        var biomimicryScore = (totaal: 0, goed: 0)
        var dierenwelzijnScore = (totaal: 0, goed: 0)
        
        // Loop through the given answers
        for currScore in score {
            
            if currScore.question?.typeName == "Energie" {
                energieScore.totaal += 1
                if currScore.correctlyAnswerd {
                    energieScore.goed += 1
                }
            }
            if currScore.question?.typeName == "Water" {
                waterScore.totaal += 1
                if currScore.correctlyAnswerd {
                    waterScore.goed += 1
                }
            }
            if currScore.question?.typeName == "Materiaal" {
                materialenScore.totaal += 1
                if currScore.correctlyAnswerd {
                    materialenScore.goed += 1
                }
            }
            if currScore.question?.typeName == "Bio Mimicry" {
                biomimicryScore.totaal += 1
                if currScore.correctlyAnswerd {
                    biomimicryScore.goed += 1
                }
            }
            if currScore.question?.typeName == "Dierenwelzijn" {
                dierenwelzijnScore.totaal += 1
                if currScore.correctlyAnswerd {
                    dierenwelzijnScore.goed += 1
                }
            }
            
        }
        
        // Calculate total score and amount of correctly answerd questions
        let totaalScore = energieScore.totaal + waterScore.totaal + materialenScore.totaal + biomimicryScore.totaal + dierenwelzijnScore.totaal
        let goedScore = energieScore.goed + waterScore.goed + materialenScore.goed + biomimicryScore.goed + dierenwelzijnScore.goed
        
        return (energieScore.goed, energieScore.totaal, waterScore.goed, waterScore.totaal, materialenScore.goed, materialenScore.totaal, biomimicryScore.goed, biomimicryScore.totaal, dierenwelzijnScore.goed, dierenwelzijnScore.totaal, totaalScore, goedScore)
        
    }
   
}
