//
//  JoinQuizViewController.swift
//  Wildlands
//
//  Created by Jan Doornbos on 29-04-15.
//  Copyright (c) 2015 INF2A. All rights reserved.
//

import UIKit
import Socket_IO_Client_Swift

class JoinQuizViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var naamInputField: UITextField!
    @IBOutlet weak var quizCodeField: UITextField!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    
    var socket: SocketIOClient?
    
    private var activeTextField: UITextField?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        backgroundView.layer.insertSublayer(WildlandsGradient.grayGradient(forBounds: view.bounds), atIndex: 0)
        
        // Make up the textfields
        let background: UIImage = UIImage(named: "black-button")!.resizableImageWithCapInsets(UIEdgeInsetsMake(6, 6, 6, 6), resizingMode: UIImageResizingMode.Stretch)
        naamInputField.background = background
        naamInputField.layer.shadowColor = UIColor.blackColor().CGColor
        naamInputField.layer.shadowOffset = CGSizeMake(0, 0);
        naamInputField.layer.shadowOpacity = 1
        naamInputField.layer.shadowRadius = 15
        
        quizCodeField.background = background
        quizCodeField.layer.shadowColor = UIColor.blackColor().CGColor
        quizCodeField.layer.shadowOffset = CGSizeMake(0, 0);
        quizCodeField.layer.shadowOpacity = 1
        quizCodeField.layer.shadowRadius = 15
        
        startButton = WildlandsButton.createButtonWithImage(named: "default-button", forButton: startButton)
        startButton.enabled = false
        
        addKeyboardNotifications()
        
        var tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)
        
        let delegate: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        socket = delegate.socket
        
        socket?.on("joinSuccess", callback: successReceived)
        socket?.on("joinFailed", callback: failReceived)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Socket IO
    func successReceived(data: NSArray?, ack: AckEmitter?) {
        
        Utils.saveObjectToDisk(naamInputField.text, forKey: "quizName")
        Utils.saveObjectToDisk(quizCodeField.text, forKey: "quizCode")
        self.performSegueWithIdentifier("goToWaitForStart", sender: self)
        
    }
    
    func failReceived(data: NSArray?, ack: AckEmitter?) {
        
        if let error = data?[0].objectForKey("error") as? String {
        
            var image = Utils.fontAwesomeToImageWith(string: "\u{f119}", andColor: UIColor.whiteColor())
            var alert = JSSAlertView().show(self, title : NSLocalizedString("quiz", comment: "").uppercaseString, text : error, color : UIColorFromHex(0xc1272d, alpha: 1.0), buttonText: NSLocalizedString("helaas", comment: "Helaas"), iconImage: image)
            
        }
        
    }
    
    // MARK: - Keyboard functions
    func dismissKeyboard() {
        
        activeTextField?.resignFirstResponder()
        
    }
    
    func addKeyboardNotifications() {
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillBeShown:", name: UIKeyboardDidShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillBeHidden:", name: UIKeyboardWillHideNotification, object: nil)
        
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
        
        if let fieldOrigin = activeTextFieldOrigin {
        
            if (!CGRectContainsPoint(aRect, fieldOrigin)) {
                scrollView.scrollRectToVisible(activeTextFieldRect!, animated:true)
            }
            
        }
    
    }

    func keyboardWillBeHidden(sender: NSNotification) {
        let contentInsets: UIEdgeInsets = UIEdgeInsetsZero
        scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets
    }
    
    // MARK: - Textfields
    func textFieldDidBeginEditing(textField: UITextField) {
        
        activeTextField = textField
        
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        
        activeTextField = nil
        
    }
    
    /**
       Limit the amount of characters to four on the Quiz Code field.
     */
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        
        // Make sure the App doesn't crash on a Paste action
        if range.length + range.location > textField.text.length {
            return false
        }
        
        let newLength: Int = textField.text.length + string.length - range.length
        
        // Enable Start button if Quiz code has four characters
        if textField == quizCodeField {
            startButton.enabled = (newLength == 4)
        }
        
        // The name field needs less then 40 characters
        if textField == naamInputField {
            return newLength <= 25
        }
        
        return newLength <= 4
        
    }

    // MARK: - Button actions
    @IBAction func goBack(sender: AnyObject) {
        
        self.navigationController?.popViewControllerAnimated(false)
        
    }
    
    @IBAction func startTheQuiz(sender: AnyObject) {
        
        // Check if Quiz code and Name aren't empty
        if quizCodeField.text.length != 0 && naamInputField.text.length != 0 {
            
            var socketJson = [
                "quizID" : quizCodeField.text!,
                "naam" : naamInputField.text!
            ]
            socket?.emit("joinQuiz", socketJson)
            
        } else {
            
            var image = Utils.fontAwesomeToImageWith(string: "\u{f119}", andColor: UIColor.whiteColor())
            var alert = JSSAlertView().show(self, title : NSLocalizedString("quiz", comment: "").uppercaseString, text : NSLocalizedString("quizNoName", comment: ""), color : UIColorFromHex(0xc1272d, alpha: 1.0), buttonText: NSLocalizedString("helaas", comment: "Helaas"), iconImage: image)
            
        }
        
    }
}
