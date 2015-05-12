//
//  WaitForQuizStartViewController.swift
//  Wildlands
//
//  Created by Jan Doornbos on 29-04-15.
//  Copyright (c) 2015 INF2A. All rights reserved.
//

import UIKit
import Socket_IO_Client_Swift

class WaitForQuizStartViewController: UIViewController {

    @IBOutlet weak var animatedClock: AnalogClockView!
    @IBOutlet weak var backgroundView: UIView!
    
    var socket: SocketIOClient?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        var gradient: CAGradientLayer = CAGradientLayer()
        gradient.frame = view.bounds
        gradient.colors = [UIColor(red: 153.0/255.0, green: 153/255.0, blue: 153.0/255.0, alpha: 1).CGColor, UIColor(red: 153.0/255.0, green: 153.0/255.0, blue: 153.0/255.0, alpha: 1).CGColor]
        backgroundView.layer.insertSublayer(gradient, atIndex: 0)
        
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
    
    func startQuiz(data: NSArray?, ack: AckEmitter?) {
        
        if let duration = data?[0].objectForKey("duration") as? Int {
            
            Utils.saveObjectToDisk(duration, forKey: "quizDuration")
            self.performSegueWithIdentifier("goToTheQuiz", sender: self)
            
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func updateClock() {
        
        self.animatedClock.hours = Int(arc4random() % 12);
        self.animatedClock.minutes = Int(arc4random() % 60);
        self.animatedClock.seconds = Int(arc4random() % 60);
        animatedClock.updateTime(animated: true)
        
    }
    
}
