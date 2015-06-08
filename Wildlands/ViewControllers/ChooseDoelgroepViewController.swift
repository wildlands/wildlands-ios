//
//  ChooseDoelgroepViewController.swift
//  Wildlands
//
//  Created by Jan Doornbos on 18-05-15.
//  Copyright (c) 2015 INF2A. All rights reserved.
//

import UIKit

class ChooseDoelgroepViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UIAlertViewDelegate, JSSAlertViewDelegate {

    @IBOutlet weak var chooseButton: UIButton!
    @IBOutlet weak var goVerder: UIButton!
    @IBOutlet weak var backgroundView: UIView!
    
    @IBOutlet weak var pickerViewHolder: UIView!
    @IBOutlet weak var pickerView: UIPickerView!
    
    var levels: [Level] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        backgroundView.layer.insertSublayer(WildlandsGradient.greenGradient(forBounds: view.bounds), atIndex: 0)
        
        chooseButton = WildlandsButton.createButtonWithImage(named: "black-button", forButton: chooseButton)
        goVerder = WildlandsButton.createButtonWithImage(named: "default-button", forButton: goVerder)
        
        // Place the pickerView out of the screen
        pickerViewHolder.transform = CGAffineTransformMakeTranslation(0, view.bounds.height + 216)
        
        // Give a shadow to the pickerViewHolder
        pickerViewHolder.layer.shadowColor = UIColor.blackColor().CGColor
        pickerViewHolder.layer.shadowOffset = CGSizeMake(0, 0)
        pickerViewHolder.layer.shadowRadius = 12
        pickerViewHolder.layer.shadowOpacity = 1.0
        
        // Add a drag gesture to the pickerViewHolder
        let gesture: UIPanGestureRecognizer = UIPanGestureRecognizer(target: self, action: "handleGesture:")
        pickerViewHolder.addGestureRecognizer(gesture)
        
        // Get all the available levels
        levels = Utils.openObjectFromDisk(forKey: "levels") as! [Level]
        
        // Make a placeholder level for the 'Selecteer...' option
        let selectLevel = Level()
        selectLevel.id = 0
        selectLevel.name = NSLocalizedString("select", comment: "")
        levels.insert(selectLevel, atIndex: 0)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Gesture recognizers
    
    /**
        Make the pickerViewHolder dragable for some funny animations
     */
    func handleGesture(panGesture: UIPanGestureRecognizer) {
        
        let point: CGPoint = panGesture.translationInView(pickerViewHolder)
        
        // Stop the drag animation at an y of -80
        if point.y < -80 {
            
            pickerViewHolder.transform = CGAffineTransformMakeTranslation(0, -80)
            
        } else {
        
            pickerViewHolder.transform = CGAffineTransformMakeTranslation(0, point.y)
            
        }
        
        // User stoped dragging
        if panGesture.state == UIGestureRecognizerState.Ended {
            
            // User moved more than 100 points, so move pickerViewHolder out of screen
            if point.y > 100 {
                
                UIView.animateWithDuration(1.0, delay: 0, usingSpringWithDamping: 1.2, initialSpringVelocity: 1.2, options: nil, animations: {
                    
                    self.pickerViewHolder.transform = CGAffineTransformMakeTranslation(0, self.view.bounds.height + 216)
                    
                }, completion: nil);
                
            } else {
            
                // Bounce back into the screen, to origional position
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
    
    /**
        Fallback function if viewForRow failes...
     */
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        
        return levels[row].name
        
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        chooseButton.setTitle(levels[row].name.uppercaseString, forState: UIControlState.Normal)
        
    }

    // MARK: - Button functions
    
    /**
        Animate the pickerViewHolder into the screen.
    
        :param: sender          The button that calls this action.
    */
    @IBAction func chooseDoelgroep(sender: AnyObject) {
        
        UIView.animateWithDuration(1.0, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.8, options: nil, animations: {
           
            self.pickerViewHolder.transform = CGAffineTransformIdentity
            
        }, completion: nil);
        
    }

    /**
        Animate the pickerViewHolder out the screen.

        :param: sender          The button that calls this action.
     */
    @IBAction func dissmissPickerview(sender: AnyObject) {
        
        UIView.animateWithDuration(1.0, delay: 0, usingSpringWithDamping: 1.2, initialSpringVelocity: 1.2, options: nil, animations: {
            
            self.pickerViewHolder.transform = CGAffineTransformMakeTranslation(0, self.view.bounds.height + 216)
            
        }, completion: nil);
        
    }
    
    /**
        Go to the next screen if the user has selected a valid level.

        :param: sender          The button that calls this action.
     */
    @IBAction func goVerder(sender: AnyObject) {
        
        // If the user didn't select a valid level
        if pickerView.selectedRowInComponent(0) == 0 {
            
            // Show an alert
            var image = Utils.fontAwesomeToImageWith(string: "\u{f007}", andColor: UIColor.whiteColor())
            var alert = JSSAlertView().show(
                self,
                title : NSLocalizedString("level", comment: "").uppercaseString,
                text : NSLocalizedString("levelNeedToSelect", comment: ""),
                color : UIColorFromHex(0x2D6400, alpha: 1.0),
                buttonText: "Oké",
                iconImage: image
            )
            alert.delegate = self
            
            
        // User selected a valid level
        } else {
            
            // Save the level
            Utils.saveObjectToDisk(levels[pickerView.selectedRowInComponent(0)], forKey: "currentLevel")
            // Go to the next screen (in this case StartViewController)
            self.performSegueWithIdentifier("goToHome", sender: self)
            
        }
        
    }
    
    // MARK: - AlertView
    
    func JSSAlertViewButtonPressed(forAlert: JSSAlertView) {
    
        // Open the pickerView
        chooseDoelgroep(self)
        
    }
    
    func JSSAlertViewCancelButtonPressed(forAlert: JSSAlertView) {
        // Doesn't do anthing, but has to be implemented.
    }
}
