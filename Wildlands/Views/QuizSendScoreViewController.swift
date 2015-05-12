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
    
    var deelnemers = [String: Int]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let button: UIImage = UIImage(named: "element-18")!.resizableImageWithCapInsets(UIEdgeInsetsMake(6, 6, 6, 6), resizingMode: UIImageResizingMode.Stretch)
        verstuurButton.setBackgroundImage(button, forState: UIControlState.Normal)
        verstuurButton.layer.shadowColor = UIColor.blackColor().CGColor
        verstuurButton.layer.shadowOffset = CGSizeMake(0, 0);
        verstuurButton.layer.shadowOpacity = 1
        
        var gradient: CAGradientLayer = CAGradientLayer()
        gradient.frame = view.bounds
        gradient.colors = [UIColor(red: 45.0/255.0, green: 100.0/255.0, blue: 0.0/255.0, alpha: 1).CGColor, UIColor(red: 22.0/255.0, green: 45.0/255.0, blue: 26.0/255.0, alpha: 1).CGColor]
        backgroundView.layer.insertSublayer(gradient, atIndex: 0)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func goBack(sender: AnyObject) {
        
        self.navigationController?.popToRootViewControllerAnimated(false)
        self.dismissViewControllerAnimated(true, completion: nil)
        
    }

    @IBAction func sendQuizScore(sender: AnyObject) {
        
        if MFMailComposeViewController.canSendMail() {
            
            var body = "Uitslagen \n\n"
            for (naam, score) in deelnemers {
                
                body += "\(naam) : \(score) \n"
                
            }
        
            var subject = "Uitslag Wildlands Edu Quiz"
            let mailComposer = MFMailComposeViewController()
            mailComposer.mailComposeDelegate = self
            mailComposer.setSubject(subject)
            mailComposer.setMessageBody(body, isHTML: false)
            
            self.presentViewController(mailComposer, animated: true, completion: nil)
            
        }
        
    }
    

    func mailComposeController(controller: MFMailComposeViewController!, didFinishWithResult result: MFMailComposeResult, error: NSError!) {
        
        controller.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
}
