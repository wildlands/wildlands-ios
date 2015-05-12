//
//  QuizScoreViewController.swift
//  Wildlands
//
//  Created by Jan Doornbos on 12-05-15.
//  Copyright (c) 2015 INF2A. All rights reserved.
//

import UIKit
import Socket_IO_Client_Swift

class QuizScoreViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var progressView: UIProgressView!
    
    var socket: SocketIOClient?
    
    var deelnemers = [String: Int]()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        var gradient: CAGradientLayer = CAGradientLayer()
        gradient.frame = view.bounds
        gradient.colors = [UIColor(red: 45.0/255.0, green: 100.0/255.0, blue: 0.0/255.0, alpha: 1).CGColor, UIColor(red: 22.0/255.0, green: 45.0/255.0, blue: 26.0/255.0, alpha: 1).CGColor]
        backgroundView.layer.insertSublayer(gradient, atIndex: 0)

        let delegate: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        socket = delegate.socket
        
        socket?.on("receiveAnswer", callback: answerReceived)
        
        NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: "updateProgress", userInfo: nil, repeats: true)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func answerReceived(data: NSArray?, ack: AckEmitter?) {
        
        if let naam = data?[0].objectForKey("naam") as? String, goed = data?[0].objectForKey("goed") as? Bool {
            
            if (deelnemers[naam] == nil) {
                deelnemers[naam] = 0
            }
            
            if (goed) {
                deelnemers[naam]! += 1
            }
            tableView.reloadData()
        }
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return deelnemers.count;
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier("quizScore") as! UITableViewCell
        
        var keys = Array(deelnemers.keys)
        let rowKey = keys[indexPath.row]
        
        var nameLabel: UILabel? = cell.viewWithTag(1) as? UILabel
        var scoreLabel: UILabel? = cell.viewWithTag(2) as? UILabel
        
        nameLabel?.text = rowKey
        scoreLabel?.text = "\(deelnemers[rowKey]!)/10 "
        
        return cell
        
    }
    
    func updateProgress() {
        
        var duration = Float(Utils.openObjectFromDisk("quizDuration") as! Int) * 60
        var step: Float = 1.0 / duration
        
        var newValue = self.progressView.progress - step
        progressView.setProgress(newValue, animated: true)
        
        if newValue <= 0 {
            
            self.performSegueWithIdentifier("goToQuizDidEnd", sender: self)
            
        }
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "goToQuizDidEnd" {
            
            let destController: QuizSendScoreViewController = segue.destinationViewController as! QuizSendScoreViewController
            destController.deelnemers = self.deelnemers
            
        }
        
    }

}
