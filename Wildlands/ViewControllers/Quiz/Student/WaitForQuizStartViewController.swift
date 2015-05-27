//
//  WaitForQuizStartViewController.swift
//  Wildlands
//
//  Created by Jan Doornbos on 29-04-15.
//  Copyright (c) 2015 INF2A. All rights reserved.
//

import UIKit
import Socket_IO_Client_Swift
import AudioToolbox

class WaitForQuizStartViewController: UIViewController {

    @IBOutlet weak var animatedClock: AnalogClockView!
    @IBOutlet weak var backgroundView: UIView!
    
    var socket: SocketIOClient?
    
    var quizLevel: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        backgroundView.layer.insertSublayer(WildlandsGradient.grayGradient(forBounds: view.bounds), atIndex: 0)
        
        NSTimer.scheduledTimerWithTimeInterval(2.0, target: self, selector: "updateClock", userInfo: nil, repeats: true)
        
        let delegate: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        socket = delegate.socket
        
        if let theSocket = socket {
            if theSocket.connected {
                println("We zijn verbonden...")
            }
            theSocket.on("startTheQuiz", callback: startQuiz)
        }
        
        updateClock()
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Socket IO
    func startQuiz(data: NSArray?, ack: AckEmitter?) {
        
        if let duration = data?[0].objectForKey("duration") as? Int, level = data?[0].objectForKey("level") as? Int {
            
            Utils.saveObjectToDisk(duration, forKey: "quizDuration")
            quizLevel = level
            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
            self.performSegueWithIdentifier("goToTheQuiz", sender: self)
            socket?.off("startTheQuiz")
            
        }
        
    }
    
    // MARK: - Clock
    func updateClock() {
        
        self.animatedClock.hours = Int(arc4random() % 12);
        self.animatedClock.minutes = Int(arc4random() % 60);
        self.animatedClock.seconds = Int(arc4random() % 60);
        animatedClock.updateTime(animated: true)
        
    }
    
    // MARK: - Segues
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        let destinationController: QuizViewController = segue.destinationViewController as! QuizViewController
        destinationController.quizLevel = quizLevel
        
    }
    
    // MARK: - Button actions
    @IBAction func cancelJoining(sender: AnyObject) {
        
        self.navigationController?.popViewControllerAnimated(false)
        
    }
}
