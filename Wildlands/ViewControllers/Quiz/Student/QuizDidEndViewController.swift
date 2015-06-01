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
        
        // Only calculate score if there are any answered questions
        if endScore.count > 0 {
        
            calculateScore()
            
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Score functions
    
    /**
        Calculate the score for the student and put them in the labels
     */
    func calculateScore() {
        
        var score = ScoreCalculator.calculateScore(endScore)
        
        // Put the score into the labels (example: 5/6)
        energieScoreLabel.text = "\(score.energieGoed)/\(score.energieTotaal)"
        waterScoreLabel.text = "\(score.waterGoed)/\(score.waterTotaal)"
        materialenScoreLabel.text = "\(score.materiaalGoed)/\(score.materiaalTotaal)"
        biomimicryScoreLabel.text = "\(score.biomimicryGoed)/\(score.biomimicryTotaal)"
        dierenwelzijnScoreLabel.text = "\(score.dierenwelzijnGoed)/\(score.dierenwelzijnTotaal)"
        
        totaalScoreLabel.text = "\(score.totaalGoed)/\(score.totaal)"
        
        // Calculate the wrong answers, so we can tell the user where he made the most mistakes
        let energie = (title: "Energie", diff: Int(score.energieTotaal-score.energieGoed))
        let water = (title: "Water", diff: Int(score.waterTotaal-score.waterGoed))
        let materiaal = (title: "Materiaal", diff: Int(score.materiaalTotaal-score.materiaalGoed))
        let biomimicry = (title: "Bio Mimicry", diff: Int(score.biomimicryTotaal-score.biomimicryGoed))
        let dierenwelzijn = (title: "Dierenwelzijn", diff: Int(score.dierenwelzijnTotaal-score.dierenwelzijnGoed))
        
        var scoresForAlert = [energie, water, materiaal, biomimicry, dierenwelzijn]
        // Sort the scores
        scoresForAlert.sort({ $0.diff < $1.diff })
        
        var badCategories = "\(scoresForAlert[scoresForAlert.count-1].title) en \(scoresForAlert[scoresForAlert.count-2].title)."
        
        // Show an alert about the score
        showAlert(goed: score.totaalGoed, totaal: score.totaal, badCategories: badCategories)
        
    }
    
    /**
        Show alert message about the score.

        :param: goed            Amount of correctly answerd questions
        :param: totaal          Total amount of questions
        :param: badCategories   A string with the bad categories
     */
    func showAlert(#goed: Int, totaal: Int, badCategories: String) {
        
        // Calculate percentage
        var percent: Double = (Double(goed) / Double(totaal)) * Double(100.0)
      
        // Placeholders
        var alertTitle: String = ""
        var alertText: String = ""
        var alertColor: UIColor = UIColor.clearColor()
        var alertIcon: UIImage = UIImage()
        
        // Make alert object
        var alert = JSSAlertView()
        
        // Generate message depending on the score
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
        
        // Add the bad categories string to the message
        alertText += badCategories
        
        // Show the message
        alert.show(self, title: alertTitle, text: alertText, buttonText: NSLocalizedString("oke", comment: ""), cancelButtonText: nil, color: alertColor, iconImage: alertIcon, delegate: nil)
        
    }

    // MARK: - Button actions
    
    /**
        Go back to the previous screen (in this case QuizChooseViewController)
     */
    @IBAction func goBack(sender: AnyObject) {
        
        self.navigationController?.popToRootViewControllerAnimated(false)
        self.dismissViewControllerAnimated(true, completion: nil)
        
    }
}
