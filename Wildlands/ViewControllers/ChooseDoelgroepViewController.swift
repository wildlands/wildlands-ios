//
//  ChooseDoelgroepViewController.swift
//  Wildlands
//
//  Created by Jan Doornbos on 18-05-15.
//  Copyright (c) 2015 INF2A. All rights reserved.
//

import UIKit

class ChooseDoelgroepViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UIAlertViewDelegate {

    @IBOutlet weak var chooseButton: UIButton!
    @IBOutlet weak var goVerder: UIButton!
    @IBOutlet weak var backgroundView: UIView!
    
    @IBOutlet weak var pickerViewHolder: UIView!
    @IBOutlet weak var pickerView: UIPickerView!
    
    var levels: [Level] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        var gradient: CAGradientLayer = CAGradientLayer()
        gradient.frame = view.bounds
        gradient.colors = [UIColor(red: 45.0/255.0, green: 100.0/255.0, blue: 0.0/255.0, alpha: 1).CGColor, UIColor(red: 22.0/255.0, green: 45.0/255.0, blue: 26.0/255.0, alpha: 1).CGColor]
        backgroundView.layer.insertSublayer(gradient, atIndex: 0)
        
        chooseButton = WildlandsButton.createButtonWithImage(named: "black-button", forButton: chooseButton)
        goVerder = WildlandsButton.createButtonWithImage(named: "default-button", forButton: goVerder)
        
        pickerViewHolder.transform = CGAffineTransformMakeTranslation(0, view.bounds.height + 216)
        
        pickerViewHolder.layer.shadowColor = UIColor.blackColor().CGColor
        pickerViewHolder.layer.shadowOffset = CGSizeMake(0, 0)
        pickerViewHolder.layer.shadowRadius = 12
        pickerViewHolder.layer.shadowOpacity = 1.0
        
        let gesture: UIPanGestureRecognizer = UIPanGestureRecognizer(target: self, action: "handleGesture:")
        pickerViewHolder.addGestureRecognizer(gesture)
        
        levels = Utils.openObjectFromDisk(forKey: "levels") as! [Level]
        
        let selectLevel = Level()
        selectLevel.id = 0
        selectLevel.name = NSLocalizedString("select", comment: "")
        levels.insert(selectLevel, atIndex: 0)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Gesture recognizers
    func handleGesture(panGesture: UIPanGestureRecognizer) {
        
        let point: CGPoint = panGesture.translationInView(pickerViewHolder)
        
        if point.y < -80 {
            
            pickerViewHolder.transform = CGAffineTransformMakeTranslation(0, -80)
            
        } else {
        
            pickerViewHolder.transform = CGAffineTransformMakeTranslation(0, point.y)
            
        }
        
        if panGesture.state == UIGestureRecognizerState.Ended {
            
            if point.y > 100 {
                
                UIView.animateWithDuration(1.0, delay: 0, usingSpringWithDamping: 1.2, initialSpringVelocity: 1.2, options: nil, animations: {
                    
                    self.pickerViewHolder.transform = CGAffineTransformMakeTranslation(0, self.view.bounds.height + 216)
                    
                }, completion: nil);
                
            } else {
            
                UIView.animateWithDuration(1.0, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: nil, animations: {
                    
                    self.pickerViewHolder.transform = CGAffineTransformIdentity
                    
                }, completion: nil);
            
            }
            
        }
        
    }
    
    // MARK: - PickerView
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        
        return 1
        
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        return levels.count
        
    }
    
    func pickerView(pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusingView view: UIView!) -> UIView {
        
        let view = UIView(frame: CGRectMake(0, 0, pickerView.frame.size.width, 60))
        let label = UILabel(frame: CGRectMake(0, 0, view.frame.size.width, 60))
        
        label.text = levels[row].name
        label.font = Fonts.speedletterFont(25)
        label.textAlignment = .Center
        
        view.addSubview(label)
        
        return view
        
    }
    
    func pickerView(pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        
        return 60.0
        
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        
        return levels[row].name
        
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        chooseButton.setTitle(levels[row].name.uppercaseString, forState: UIControlState.Normal)
        
    }

    // MARK: - Button functions
    @IBAction func chooseDoelgroep(sender: AnyObject) {
        
        UIView.animateWithDuration(1.0, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.8, options: nil, animations: {
           
            self.pickerViewHolder.transform = CGAffineTransformIdentity
            
        }, completion: nil);
        
    }

    @IBAction func dissmissPickerview(sender: AnyObject) {
        
        UIView.animateWithDuration(1.0, delay: 0, usingSpringWithDamping: 1.2, initialSpringVelocity: 1.2, options: nil, animations: {
            
            self.pickerViewHolder.transform = CGAffineTransformMakeTranslation(0, self.view.bounds.height + 216)
            
        }, completion: nil);
        
    }
    
    @IBAction func goVerder(sender: AnyObject) {
        
        if pickerView.selectedRowInComponent(0) == 0 {
            
            var image = Utils.fontAwesomeToImageWith(string: "\u{f007}", andColor: UIColor.whiteColor())
            var alert = JSSAlertView().show(
                self,
                title : NSLocalizedString("level", comment: "").uppercaseString,
                text : NSLocalizedString("levelNeedToSelect", comment: ""),
                color : UIColorFromHex(0x2D6400, alpha: 1.0),
                buttonText: "Oké",
                iconImage: image
            )
            alert.addAction(chooseDoelgroepAfterAlert)
            
            
        } else {
            
            Utils.saveObjectToDisk(levels[pickerView.selectedRowInComponent(0)], forKey: "currentLevel")
            self.performSegueWithIdentifier("goToHome", sender: self)
            
        }
        
    }
    
    // MARK: - AlertView
    func chooseDoelgroepAfterAlert() {
        
        chooseDoelgroep(self)
        
    }
}
