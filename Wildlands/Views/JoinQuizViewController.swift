//
//  JoinQuizViewController.swift
//  Wildlands
//
//  Created by Jan Doornbos on 29-04-15.
//  Copyright (c) 2015 INF2A. All rights reserved.
//

import UIKit

class JoinQuizViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var naamInputField: UITextField!
    @IBOutlet weak var quizCodeField: UITextField!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    
    private var activeTextField: UITextField?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        var gradient: CAGradientLayer = CAGradientLayer()
        gradient.frame = view.bounds
        gradient.colors = [UIColor(red: 153.0/255.0, green: 153/255.0, blue: 153.0/255.0, alpha: 1).CGColor, UIColor(red: 153.0/255.0, green: 153.0/255.0, blue: 153.0/255.0, alpha: 1).CGColor]
        backgroundView.layer.insertSublayer(gradient, atIndex: 0)
        
        let background: UIImage = UIImage(named: "element-19")!.resizableImageWithCapInsets(UIEdgeInsetsMake(6, 6, 6, 6), resizingMode: UIImageResizingMode.Stretch)
        naamInputField.background = background
        naamInputField.layer.shadowColor = UIColor.blackColor().CGColor
        naamInputField.layer.shadowOffset = CGSizeMake(0, 0);
        naamInputField.layer.shadowOpacity = 1
        
        quizCodeField.background = background
        quizCodeField.layer.shadowColor = UIColor.blackColor().CGColor
        quizCodeField.layer.shadowOffset = CGSizeMake(0, 0);
        quizCodeField.layer.shadowOpacity = 1
        
        let button: UIImage = UIImage(named: "element-18")!.resizableImageWithCapInsets(UIEdgeInsetsMake(6, 6, 6, 6), resizingMode: UIImageResizingMode.Stretch)
        startButton.setBackgroundImage(button, forState: UIControlState.Normal)
        startButton.layer.shadowColor = UIColor.blackColor().CGColor
        startButton.layer.shadowOffset = CGSizeMake(0, 0);
        startButton.layer.shadowOpacity = 1
        
        addKeyboardNotifications()
        
        var tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)
        
    }
    
    func dismissKeyboard() {
        
        activeTextField?.resignFirstResponder()
        
    }
    
    func addKeyboardNotifications() {
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillBeShown:", name: UIKeyboardDidShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillBeHidden:", name: UIKeyboardWillHideNotification, object: nil)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        if textField == naamInputField {
            quizCodeField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        
        return false
        
    }
    
    func keyboardWillBeShown(sender: NSNotification) {
        
        let info: NSDictionary = sender.userInfo!
        let value: NSValue = info.valueForKey(UIKeyboardFrameBeginUserInfoKey) as! NSValue
        let keyboardSize: CGSize = value.CGRectValue().size
        let contentInsets: UIEdgeInsets = UIEdgeInsetsMake(0.0, 0.0, keyboardSize.height + 50, 0.0)
        scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets

        var aRect: CGRect = self.view.frame
        aRect.size.height -= keyboardSize.height
        let activeTextFieldRect: CGRect? = activeTextField?.frame
        let activeTextFieldOrigin: CGPoint? = activeTextFieldRect?.origin
        if (!CGRectContainsPoint(aRect, activeTextFieldOrigin!)) {
            scrollView.scrollRectToVisible(activeTextFieldRect!, animated:true)
        }
    }

    func keyboardWillBeHidden(sender: NSNotification) {
        let contentInsets: UIEdgeInsets = UIEdgeInsetsZero
        scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        
        activeTextField = textField
        
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        
        activeTextField = nil
        
    }

}
