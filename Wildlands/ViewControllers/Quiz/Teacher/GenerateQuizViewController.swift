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

        backgroundView.layer.insertSublayer(WildlandsGradient.grayGradient(forBounds: view.bounds), atIndex: 0)
        
        genereerButton = WildlandsButton.createButtonWithImage(named: "element-18", forButton: genereerButton)
        
        let delegate: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        socket = delegate.socket
        
        socket?.on("quizCreated", callback: quizGenerateSuccess)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Socket IO
    func quizGenerateSuccess(data: NSArray?, ack: AckEmitter?) {
        
        if let theQuizID = data?[0].objectForKey("quizid") as? String {
            Utils.saveObjectToDisk(theQuizID, forKey: "quizCode")
            self.performSegueWithIdentifier("goToStartQuiz", sender: self)
        }
        
    }
    
    // MARK: - Slider
    @IBAction func sliderDidSlide(sender: AnyObject) {
        
        tijdLabel.text = NSString(format: "%.0f MINUTEN", round(tijdSlider.value)) as String
        
    }
    
    // MARK: - Button actions
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
