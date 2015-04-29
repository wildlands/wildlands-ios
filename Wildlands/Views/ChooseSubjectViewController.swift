//
//  ChooseSubjectViewController.swift
//  Wildlands
//
//  Created by Jan Doornbos on 24-04-15.
//  Copyright (c) 2015 INF2A. All rights reserved.
//

import UIKit

class ChooseSubjectViewController: UIViewController {

    var openType: PinpointType?
    @IBOutlet weak var backgroundView: UIView!
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var energieButton: UIButton!
    @IBOutlet weak var waterButton: UIButton!
    @IBOutlet weak var materialenButton: UIButton!
    @IBOutlet weak var biomimicryButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var gradient: CAGradientLayer = CAGradientLayer()
        gradient.frame = view.bounds
        gradient.colors = [UIColor(red: 45.0/255.0, green: 100.0/255.0, blue: 0.0/255.0, alpha: 1).CGColor, UIColor(red: 22.0/255.0, green: 45.0/255.0, blue: 26.0/255.0, alpha: 1).CGColor]
        backgroundView.layer.insertSublayer(gradient, atIndex: 0)

        createButtons()
        
    }
    
    override func viewDidAppear(animated: Bool) {
        
        UIView.animateWithDuration(1.0, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.8, options: nil, animations: {
            
            self.energieButton.alpha = 1
            self.waterButton.alpha = 1
            self.materialenButton.alpha = 1
            self.biomimicryButton.alpha = 1
            
            self.energieButton.transform = CGAffineTransformIdentity
            self.waterButton.transform = CGAffineTransformIdentity
            self.materialenButton.transform = CGAffineTransformIdentity
            self.biomimicryButton.transform = CGAffineTransformIdentity
            
        
        }, completion: nil)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func createButtons() {
        
        let energie: UIImage = UIImage(named: "element-14")!.resizableImageWithCapInsets(UIEdgeInsetsMake(6, 6, 6, 6), resizingMode: UIImageResizingMode.Stretch)
        let water: UIImage = UIImage(named: "element-15")!.resizableImageWithCapInsets(UIEdgeInsetsMake(6, 6, 6, 6), resizingMode: UIImageResizingMode.Stretch)
        let materialen: UIImage = UIImage(named: "element-16")!.resizableImageWithCapInsets(UIEdgeInsetsMake(6, 6, 6, 6), resizingMode: UIImageResizingMode.Stretch)
        let bio: UIImage = UIImage(named: "element-17")!.resizableImageWithCapInsets(UIEdgeInsetsMake(6, 6, 6, 6), resizingMode: UIImageResizingMode.Stretch)
        
        energieButton.setBackgroundImage(energie, forState: UIControlState.Normal)
        energieButton.layer.shadowColor = UIColor.blackColor().CGColor
        energieButton.layer.shadowOffset = CGSizeMake(0, 0);
        energieButton.layer.shadowOpacity = 1
        
        waterButton.setBackgroundImage(water, forState: UIControlState.Normal)
        waterButton.layer.shadowColor = UIColor.blackColor().CGColor
        waterButton.layer.shadowOffset = CGSizeMake(0, 0);
        waterButton.layer.shadowOpacity = 1
        
        materialenButton.setBackgroundImage(materialen, forState: UIControlState.Normal)
        materialenButton.layer.shadowColor = UIColor.blackColor().CGColor
        materialenButton.layer.shadowOffset = CGSizeMake(0, 0);
        materialenButton.layer.shadowOpacity = 1
        
        biomimicryButton.setBackgroundImage(bio, forState: UIControlState.Normal)
        biomimicryButton.layer.shadowColor = UIColor.blackColor().CGColor
        biomimicryButton.layer.shadowOffset = CGSizeMake(0, 0);
        biomimicryButton.layer.shadowOpacity = 1
        
        energieButton.alpha = 0
        waterButton.alpha = 0
        materialenButton.alpha = 0
        biomimicryButton.alpha = 0
        
        energieButton.transform = CGAffineTransformMakeTranslation(-400, 0)
        waterButton.transform = CGAffineTransformMakeTranslation(600, 0)
        materialenButton.transform = CGAffineTransformMakeTranslation(-800, 0)
        biomimicryButton.transform = CGAffineTransformMakeTranslation(1000, 0)
        
    }

    @IBAction func openKaartWithEnergie(sender: AnyObject) {
        
        openType = .ENERGIE
        self.performSegueWithIdentifier("openKaart", sender: self)
        
    }
    
    @IBAction func openKaartWithWater(sender: AnyObject) {
        
        openType = .WATER
        self.performSegueWithIdentifier("openKaart", sender: self)
        
    }
    
    @IBAction func openKaartWithMaterialen(sender: AnyObject) {
        
        openType = .MATERIAAL
        self.performSegueWithIdentifier("openKaart", sender: self)
        
    }
    
    @IBAction func openKaartWithBioMimicry(sender: AnyObject) {
        
        openType = .BIO_MIMICRY
        self.performSegueWithIdentifier("openKaart", sender: self)
        
    }

    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        let kaart: KaartViewController = segue.destinationViewController as! KaartViewController
        kaart.currentType = openType
        
        
    }
    
    @IBAction func goBack(sender: AnyObject) {
        
        self.navigationController?.popViewControllerAnimated(false)
        
    }
}
