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
        
        if endScore.count > 0 {
        
            calculateScore()
            
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Score functions
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
        
        showAlert(goed: goedScore, totaal: totaalScore)
        
    }
    
    func showAlert(#goed: Int, totaal: Int) {
        
        var percent: Double = (Double(goed) / Double(totaal)) * Double(100.0)
        println(percent)
        var alertTitle: String = ""
        var alertText: String = ""
        var alertColor: UIColor = UIColor.clearColor()
        var alertIcon: UIImage = UIImage()
        
        var alert = JSSAlertView()
        
        if percent < 30 {
            
            alertTitle = NSLocalizedString("scoreTitle1", comment: "").uppercaseString
            alertText = NSLocalizedString("scoreText1", comment: "")
            alertColor = UIColorFromHex(0xc1272d, alpha: 1.0)
            alertIcon = Utils.fontAwesomeToImageWith(string: "\u{f165}", andColor: UIColor.whiteColor())
            
        } else if percent >= 30 && percent <= 55 {
            
            alertTitle = NSLocalizedString("scoreTitle2", comment: "").uppercaseString
            alertText = NSLocalizedString("scoreText2", comment: "")
            alertIcon = Utils.fontAwesomeToImageWith(string: "\u{f165}", andColor: UIColor.whiteColor())
            alertColor = UIColorFromHex(0xf7931e, alpha: 1.0)
            
        } else if percent > 55 && percent <= 80 {
            
            alertTitle = NSLocalizedString("scoreTitle3", comment: "").uppercaseString
            alertText = NSLocalizedString("scoreText3", comment: "")
            alertIcon = Utils.fontAwesomeToImageWith(string: "\u{f00c}", andColor: UIColor.whiteColor())
            alertColor = UIColorFromHex(0xfcee21, alpha: 1.0)
            
        } else if percent > 80 && percent <= 100 {
            
            alertTitle = NSLocalizedString("scoreTitle4", comment: "").uppercaseString
            alertText = NSLocalizedString("scoreText4", comment: "")
            alertIcon = Utils.fontAwesomeToImageWith(string: "\u{f00c}", andColor: UIColor.whiteColor())
            alertColor = UIColorFromHex(0x8cc63f, alpha: 1.0)
            
        } else {
            
            alertTitle = NSLocalizedString("scoreTitle5", comment: "").uppercaseString
            alertText = NSLocalizedString("scoreText5", comment: "")
            alertIcon = Utils.fontAwesomeToImageWith(string: "\u{f091}", andColor: UIColor.whiteColor())
            alertColor = UIColorFromHex(0x39b54a, alpha: 1.0)
            
        }
        
        alert.show(self, title: alertTitle, text: alertText, buttonText: NSLocalizedString("oke", comment: ""), cancelButtonText: nil, color: alertColor, iconImage: alertIcon, delegate: nil)
        
    }

    // MARK: - Button actions
    @IBAction func goBack(sender: AnyObject) {
        
        self.navigationController?.popToRootViewControllerAnimated(false)
        self.dismissViewControllerAnimated(true, completion: nil)
        
    }
}
