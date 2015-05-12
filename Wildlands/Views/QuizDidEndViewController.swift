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
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
}
