//
//  QuizSendScoreViewController.swift
//  Wildlands
//
//  Created by Jan Doornbos on 12-05-15.
//  Copyright (c) 2015 INF2A. All rights reserved.
//

import UIKit
import MessageUI

class QuizSendScoreViewController: UIViewController, MFMailComposeViewControllerDelegate {

    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var verstuurButton: UIButton!
    
    var deelnemers = [String: [Score]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        verstuurButton = WildlandsButton.createButtonWithImage(named: "default-button", forButton: verstuurButton)
        
        backgroundView.layer.insertSublayer(WildlandsGradient.greenGradient(forBounds: view.bounds), atIndex: 0)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Button actions
    
    /**
        Go back to the previous screen (in this case: QuizChooseViewController).

        :param: sender      The button who calls this action.
     */
    @IBAction func goBack(sender: AnyObject) {
        
        self.navigationController?.popToRootViewControllerAnimated(false)
        self.dismissViewControllerAnimated(true, completion: nil)
        
    }

    /**
        Send the quiz scores by email.
        
        :param: sender      The button who calls this action.
     */
    @IBAction func sendQuizScore(sender: AnyObject) {
        
        // Check if device can send an email
        if MFMailComposeViewController.canSendMail() {
            
            // Compose the email
            var body = "Uitslagen \n\n"
            for (naam, score) in deelnemers {
                
                var theScore = ScoreCalculator.calculateScore(score)
                
                body += "\(naam) \n"
                body += "Energie: \(theScore.energieGoed) van \(theScore.energieTotaal) \n"
                body += "Water: \(theScore.waterGoed) van \(theScore.waterTotaal) \n"
                body += "Materiaal: \(theScore.materiaalGoed) van \(theScore.materiaalTotaal) \n"
                body += "Bio Mimicry: \(theScore.biomimicryGoed) van \(theScore.biomimicryTotaal) \n"
                body += "Dierenwelzijn: \(theScore.dierenwelzijnGoed) van \(theScore.dierenwelzijnTotaal) \n"
                body += "TOTAAL: \(theScore.totaalGoed) van \(theScore.totaal) \n\n"
                
            }
        
            var subject = "Uitslag Wildlands Edu Quiz"
            let mailComposer = MFMailComposeViewController()
            mailComposer.mailComposeDelegate = self
            mailComposer.setSubject(subject)
            mailComposer.setMessageBody(body, isHTML: false)
            
            // Show the mail ViewController
            self.presentViewController(mailComposer, animated: true, completion: nil)
            
        }
        
    }
    
    // MARK: - Mail composer
    func mailComposeController(controller: MFMailComposeViewController!, didFinishWithResult result: MFMailComposeResult, error: NSError!) {
        
        controller.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
}
