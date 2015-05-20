//
//  StartViewController.swift
//  Wildlands
//
//  Created by Jan Doornbos on 28-04-15.
//  Copyright (c) 2015 INF2A. All rights reserved.
//

import UIKit
import SpriteKit

class StartViewController: UIViewController {

    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var verkenButton: UIButton!
    @IBOutlet weak var quizButton: UIButton!
    @IBOutlet weak var infoButton: UIButton!
    @IBOutlet weak var ecoAppLogo: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Custom Wildlands elementen maken
        backgroundView.layer.insertSublayer(WildlandsGradient.greenGradient(forBounds: self.view.bounds), atIndex: 0)
        verkenButton = WildlandsButton.createButtonWithImage(named: "element-18", forButton: verkenButton)
        quizButton = WildlandsButton.createButtonWithImage(named: "element-18", forButton: quizButton)
        infoButton = WildlandsButton.createButtonWithImage(named: "element-18", forButton: infoButton)
        
        /* Particles
        
        let path = NSBundle.mainBundle().pathForResource("ButtonParticles", ofType: "sks")
        var particle: SKEmitterNode = NSKeyedUnarchiver.unarchiveObjectWithFile(path!) as! SKEmitterNode
        
        var view: SKView = SKView(frame: self.view.frame)
        view.backgroundColor = UIColor.clearColor()
        view.allowsTransparency = true
        var scene: SKScene = SKScene(size: self.view.frame.size)
        scene.backgroundColor = UIColor.clearColor()
        
        scene.addChild(particle)
        
        view.presentScene(scene)
        
        self.view.addSubview(view)
        */
        
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
