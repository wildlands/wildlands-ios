//
//  GenerateQuizViewController.swift
//  Wildlands
//
//  Created by Jan Doornbos on 29-04-15.
//  Copyright (c) 2015 INF2A. All rights reserved.
//

import UIKit
import Socket_IO_Client_Swift

class GenerateQuizViewController: UIViewController {

    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var tijdLabel: UILabel!
    @IBOutlet weak var tijdSlider: UISlider!
    @IBOutlet weak var genereerButton: UIButton!
    
    var socket: SocketIOClient?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        var gradient: CAGradientLayer = CAGradientLayer()
        gradient.frame = view.bounds
        gradient.colors = [UIColor(red: 153.0/255.0, green: 153/255.0, blue: 153.0/255.0, alpha: 1).CGColor, UIColor(red: 153.0/255.0, green: 153.0/255.0, blue: 153.0/255.0, alpha: 1).CGColor]
        backgroundView.layer.insertSublayer(gradient, atIndex: 0)
        
        let button: UIImage = UIImage(named: "element-18")!.resizableImageWithCapInsets(UIEdgeInsetsMake(6, 6, 6, 6), resizingMode: UIImageResizingMode.Stretch)
        genereerButton.setBackgroundImage(button, forState: UIControlState.Normal)
        genereerButton.layer.shadowColor = UIColor.blackColor().CGColor
        genereerButton.layer.shadowOffset = CGSizeMake(0, 0);
        genereerButton.layer.shadowOpacity = 1
        
        let delegate: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        socket = delegate.socket
        
        socket?.on("quizCreated", callback: quizGenerateSuccess)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func quizGenerateSuccess(data: NSArray?, ack: AckEmitter?) {
        
        if let theQuizID = data?[0].objectForKey("quizid") as? String {
            Utils.saveObjectToDisk(theQuizID, forKey: "quizCode")
            self.performSegueWithIdentifier("goToStartQuiz", sender: self)
        }
        
    }
    
    @IBAction func sliderDidSlide(sender: AnyObject) {
        
        tijdLabel.text = NSString(format: "%.0f MINUTEN", round(tijdSlider.value)) as String
        
    }
    
    @IBAction func genereerDeQuiz(sender: AnyObject) {
        
        let duration = Int(round(tijdSlider.value))
        var json = [
            "quizDuration" : Int(round(tijdSlider.value))
        ]
        Utils.saveObjectToDisk(duration, forKey: "quizDuration")
        socket?.emit("createQuiz", json)
        
    }

    @IBAction func goBack(sender: AnyObject) {
        
        self.navigationController?.popViewControllerAnimated(false)
        
    }
}
