//
//  StartViewController.swift
//  Wildlands
//
//  Created by Jan Doornbos on 28-04-15.
//  Copyright (c) 2015 INF2A. All rights reserved.
//

import UIKit

class StartViewController: UIViewController {

    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var verkenButton: UIButton!
    @IBOutlet weak var quizButton: UIButton!
    @IBOutlet weak var ecoAppLogo: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        var gradient: CAGradientLayer = CAGradientLayer()
        gradient.frame = view.bounds
        gradient.colors = [UIColor(red: 45.0/255.0, green: 100.0/255.0, blue: 0.0/255.0, alpha: 1).CGColor, UIColor(red: 22.0/255.0, green: 45.0/255.0, blue: 26.0/255.0, alpha: 1).CGColor]
        backgroundView.layer.insertSublayer(gradient, atIndex: 0)
    
        let button: UIImage = UIImage(named: "element-18")!.resizableImageWithCapInsets(UIEdgeInsetsMake(6, 6, 6, 6), resizingMode: UIImageResizingMode.Stretch)
        verkenButton.setBackgroundImage(button, forState: UIControlState.Normal)
        verkenButton.layer.shadowColor = UIColor.blackColor().CGColor
        verkenButton.layer.shadowOffset = CGSizeMake(0, 0);
        verkenButton.layer.shadowOpacity = 1
        
        quizButton.setBackgroundImage(button, forState: UIControlState.Normal)
        quizButton.layer.shadowColor = UIColor.blackColor().CGColor
        quizButton.layer.shadowOffset = CGSizeMake(0, 0);
        quizButton.layer.shadowOpacity = 1
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        
        UIView.animateWithDuration(1.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.8, options: nil, animations: {
            
            self.verkenButton.transform = CGAffineTransformIdentity
            self.quizButton.transform = CGAffineTransformIdentity
            self.verkenButton.alpha = 1
            self.quizButton.alpha = 1
            self.ecoAppLogo.alpha = 1
            
        }, completion: nil)
        
    }
    

    @IBAction func verkenPress(sender: AnyObject) {
        
        UIView.animateWithDuration(1.0, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.8, options: nil, animations: {
            
            self.verkenButton.transform = CGAffineTransformMakeTranslation(-400, 0)
            self.quizButton.transform = CGAffineTransformMakeTranslation(400, 0)
            self.verkenButton.alpha = 0
            self.quizButton.alpha = 0
            self.ecoAppLogo.alpha = 0
            
            
        }, completion: { completed in
                
            self.performSegueWithIdentifier("goToVerken", sender: self);
                
        })
        
    }
}
