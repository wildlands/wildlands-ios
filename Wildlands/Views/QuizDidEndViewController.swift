//
//  QuizDidEndViewController.swift
//  Wildlands
//
//  Created by Jan Doornbos on 12-05-15.
//  Copyright (c) 2015 INF2A. All rights reserved.
//

import UIKit

class QuizDidEndViewController: UIViewController {

    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var energieScoreLabel: UILabel!
    @IBOutlet weak var waterScoreLabel: UILabel!
    @IBOutlet weak var materialenScoreLabel: UILabel!
    @IBOutlet weak var biomimicryScoreLabel: UILabel!
    @IBOutlet weak var dierenwelzijnScoreLabel: UILabel!
    @IBOutlet weak var totaalScoreLabel: UILabel!
    
    var endScore: [Score] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        backgroundView.layer.insertSublayer(WildlandsGradient.greenGradient(forBounds: view.bounds), atIndex: 0)
        
        calculateScore()
        
    }
    
    func calculateScore() {
        
        var energieScore = (totaal: 0, goed: 0)
        var waterScore = (totaal: 0, goed: 0)
        var materialenScore = (totaal: 0, goed: 0)
        var biomimicryScore = (totaal: 0, goed: 0)
        var dierenwelzijnScore = (totaal: 0, goed: 0)
        
        for score in endScore {
            
            if score.question?.typeName == "Energie" {
                energieScore.totaal += 1
                if score.correctlyAnswerd {
                    energieScore.goed += 1
                }
            }
            if score.question?.typeName == "Water" {
                waterScore.totaal += 1
                if score.correctlyAnswerd {
                    waterScore.goed += 1
                }
            }
            if score.question?.typeName == "Materiaal" {
                materialenScore.totaal += 1
                if score.correctlyAnswerd {
                    materialenScore.goed += 1
                }
            }
            if score.question?.typeName == "Bio Mimicry" {
                biomimicryScore.totaal += 1
                if score.correctlyAnswerd {
                    biomimicryScore.goed += 1
                }
            }
            if score.question?.typeName == "Dierenwelzijn" {
                dierenwelzijnScore.totaal += 1
                if score.correctlyAnswerd {
                    dierenwelzijnScore.goed += 1
                }
            }
            
        }
        
        let totaalScore = energieScore.totaal + waterScore.totaal + materialenScore.totaal + biomimicryScore.totaal + dierenwelzijnScore.totaal
        let goedScore = energieScore.goed + waterScore.goed + materialenScore.goed + biomimicryScore.goed + dierenwelzijnScore.goed
        
        energieScoreLabel.text = "\(energieScore.goed)/\(energieScore.totaal)"
        waterScoreLabel.text = "\(waterScore.goed)/\(waterScore.totaal)"
        materialenScoreLabel.text = "\(materialenScore.goed)/\(materialenScore.totaal)"
        biomimicryScoreLabel.text = "\(biomimicryScore.goed)/\(biomimicryScore.totaal)"
        dierenwelzijnScoreLabel.text = "\(dierenwelzijnScore.goed)/\(dierenwelzijnScore.totaal)"
        
        totaalScoreLabel.text = "\(goedScore)/\(totaalScore)"
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func goBack(sender: AnyObject) {
        
        self.navigationController?.popToRootViewControllerAnimated(false)
        self.dismissViewControllerAnimated(true, completion: nil)
        
    }
}
