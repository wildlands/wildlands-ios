//
//  ChooseSubjectViewController.swift
//  Wildlands
//
//  Created by Jan Doornbos on 24-04-15.
//  Copyright (c) 2015 INF2A. All rights reserved.
//

import UIKit

class ChooseSubjectViewController: UIViewController {

    var openType: WildlandsTheme?
    @IBOutlet weak var backgroundView: UIView!
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var energieButton: UIButton!
    @IBOutlet weak var waterButton: UIButton!
    @IBOutlet weak var materialenButton: UIButton!
    @IBOutlet weak var biomimicryButton: UIButton!
    @IBOutlet weak var dierenwelzijnButton: UIButton!
    
    var buttonsForAnimation: [UIButton] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        backgroundView.layer.insertSublayer(WildlandsGradient.greenGradient(forBounds: view.bounds), atIndex: 0)

        createButtons()
        
    }
    
    override func viewDidAppear(animated: Bool) {
        
        UIView.animateWithDuration(1.0, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.8, options: nil, animations: {
            
            self.energieButton.alpha = 1
            self.waterButton.alpha = 1
            self.materialenButton.alpha = 1
            self.biomimicryButton.alpha = 1
            self.dierenwelzijnButton.alpha = 1
            
            self.energieButton.transform = CGAffineTransformIdentity
            self.waterButton.transform = CGAffineTransformIdentity
            self.materialenButton.transform = CGAffineTransformIdentity
            self.biomimicryButton.transform = CGAffineTransformIdentity
            self.dierenwelzijnButton.transform = CGAffineTransformIdentity
            
        
        }, completion: nil)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func createButtons() {
        
        energieButton = WildlandsButton.createButtonWithImage(named: "energie-button", forButton: energieButton)
        waterButton = WildlandsButton.createButtonWithImage(named: "water-button", forButton: waterButton)
        materialenButton = WildlandsButton.createButtonWithImage(named: "materialen-button", forButton: materialenButton)
        biomimicryButton = WildlandsButton.createButtonWithImage(named: "biomimicry-button", forButton: biomimicryButton)
        dierenwelzijnButton = WildlandsButton.createButtonWithImage(named: "dierenwelzijn-button", forButton: dierenwelzijnButton)
        
        energieButton.alpha = 0
        waterButton.alpha = 0
        materialenButton.alpha = 0
        biomimicryButton.alpha = 0
        dierenwelzijnButton.alpha = 0
        
        energieButton.transform = CGAffineTransformMakeTranslation(-400, 0)
        waterButton.transform = CGAffineTransformMakeTranslation(600, 0)
        materialenButton.transform = CGAffineTransformMakeTranslation(-800, 0)
        biomimicryButton.transform = CGAffineTransformMakeTranslation(1000, 0)
        dierenwelzijnButton.transform = CGAffineTransformMakeTranslation(-1200, 0)
        
        buttonsForAnimation.append(energieButton)
        buttonsForAnimation.append(waterButton)
        buttonsForAnimation.append(materialenButton)
        buttonsForAnimation.append(biomimicryButton)
        buttonsForAnimation.append(dierenwelzijnButton)
        
    }

    // MARK: - Button functions
    @IBAction func openKaartWithEnergie(sender: AnyObject) {
        
        openType = .ENERGIE
        fadeOutButtons()
        
    }
    
    @IBAction func openKaartWithWater(sender: AnyObject) {
        
        openType = .WATER
        fadeOutButtons()
        
    }
    
    @IBAction func openKaartWithMaterialen(sender: AnyObject) {
        
        openType = .MATERIAAL
        fadeOutButtons()
        
    }
    
    @IBAction func openKaartWithBioMimicry(sender: AnyObject) {
        
        openType = .BIO_MIMICRY
        fadeOutButtons()
        
    }

    @IBAction func openKaartWithDierenwelzijn(sender: AnyObject) {
        
        openType = .DIERENWELZIJN
        fadeOutButtons()
        
    }
    
    @IBAction func goBack(sender: AnyObject) {
        
        self.navigationController?.popViewControllerAnimated(false)
        
    }
    
    // MARK: - Button animations
    func fadeOutButtons() {
        
        var delay = 0.0
        var counter = 1
        
        for button in buttonsForAnimation {
            
            if counter != buttonsForAnimation.count {
            
                UIView.animateWithDuration(0.2, delay: delay, options: nil, animations: {
                    
                    button.alpha = 0
                    
                }, completion: nil)
                
            } else {
                
                UIView.animateWithDuration(0.2, delay: delay, options: nil, animations: {
                    
                    button.alpha = 0
                    
                }, completion: { finished in
                        
                    if finished {
                    
                        self.performSegueWithIdentifier("openKaart", sender: self)
                        
                    }
                
                })
                
            }
            
            counter++
            delay += 0.1
            
        }
        
    }
    
    // MARK: - Segues
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        let kaart: KaartViewController = segue.destinationViewController as! KaartViewController
        kaart.currentType = openType
        
        
    }
    
}
