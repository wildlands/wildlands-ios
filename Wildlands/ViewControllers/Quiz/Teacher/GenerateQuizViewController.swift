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
        
        genereerButton = WildlandsButton.createButtonWithImage(named: "default-button", forButton: genereerButton)
        
        // Get socket from the App delegate
        let delegate: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        socket = delegate.socket
        
        // Add socket handler
        socket?.on("quizCreated", callback: quizGenerateSuccess)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Socket IO
    
    /**
        A quiz has been created succesfully on the Socket.IO server.
    
        :param: data        The response from the Socket.IO server.
        :param: ack         ...
     */
    func quizGenerateSuccess(data: NSArray?, ack: AckEmitter?) {
        
        // Unwrap the response
        if let theQuizID = data?[0].objectForKey("quizid") as? String {
            Utils.saveObjectToDisk(theQuizID, forKey: "quizCode")
            self.performSegueWithIdentifier("goToStartQuiz", sender: self)
        }
        
    }
    
    // MARK: - Slider
    
    /**
        The slider for the time has been updated.
    
        :param: sender      The slider who calls this function.
     */
    @IBAction func sliderDidSlide(sender: AnyObject) {
        
        tijdLabel.text = NSString(format: "%.0f MINUTEN", round(tijdSlider.value)) as String
        
    }
    
    // MARK: - Button actions
    
    /**
        Generates a quiz.

        :param: sender      The button who calls this function.
     */
    @IBAction func genereerDeQuiz(sender: AnyObject) {
        
        // Make JSON object
        let duration = Int(round(tijdSlider.value))
        var json = [
            "quizDuration" : Int(round(tijdSlider.value))
        ]
        
        // Save quiz duration
        Utils.saveObjectToDisk(duration, forKey: "quizDuration")
        
        // Send create quiz message
        socket?.emit("createQuiz", json)
        
    }

    /**
        Go back to previous screen (in this case QuizChooseViewController).
    
        :param: sender      The button who calls this function.
     */
    @IBAction func goBack(sender: AnyObject) {
        
        self.navigationController?.popViewControllerAnimated(false)
        
    }
}
