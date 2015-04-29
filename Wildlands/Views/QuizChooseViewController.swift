//
//  QuizChooseViewController.swift
//  Wildlands
//
//  Created by Jan Doornbos on 29-04-15.
//  Copyright (c) 2015 INF2A. All rights reserved.
//

import UIKit

class QuizChooseViewController: UIViewController {

    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var leerlingButton: UIButton!
    @IBOutlet weak var docentButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        var gradient: CAGradientLayer = CAGradientLayer()
        gradient.frame = view.bounds
        gradient.colors = [UIColor(red: 153.0/255.0, green: 153/255.0, blue: 153.0/255.0, alpha: 1).CGColor, UIColor(red: 153.0/255.0, green: 153.0/255.0, blue: 153.0/255.0, alpha: 1).CGColor]
        backgroundView.layer.insertSublayer(gradient, atIndex: 0)
        
        let button: UIImage = UIImage(named: "element-18")!.resizableImageWithCapInsets(UIEdgeInsetsMake(6, 6, 6, 6), resizingMode: UIImageResizingMode.Stretch)
        leerlingButton.setBackgroundImage(button, forState: UIControlState.Normal)
        leerlingButton.layer.shadowColor = UIColor.blackColor().CGColor
        leerlingButton.layer.shadowOffset = CGSizeMake(0, 0);
        leerlingButton.layer.shadowOpacity = 1
        
        docentButton.setBackgroundImage(button, forState: UIControlState.Normal)
        docentButton.layer.shadowColor = UIColor.blackColor().CGColor
        docentButton.layer.shadowOffset = CGSizeMake(0, 0);
        docentButton.layer.shadowOpacity = 1
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func goBack(sender: AnyObject) {
        
        self.dismissViewControllerAnimated(true, completion: nil)
        
    }

    @IBAction func goToJoinQuiz(sender: AnyObject) {
        
        self.performSegueWithIdentifier("goToJoinQuiz", sender: self)
        
    }

    @IBAction func goToGenerateQuiz(sender: AnyObject) {
        
        self.performSegueWithIdentifier("goToGenerateQuiz", sender: self)
        
    }
}
