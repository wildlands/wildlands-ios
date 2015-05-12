//
//  QuizBeforeStartViewController.swift
//  Wildlands
//
//  Created by Jan Doornbos on 11-05-15.
//  Copyright (c) 2015 INF2A. All rights reserved.
//

import UIKit
import Socket_IO_Client_Swift

class QuizBeforeStartViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var quizCodeLabel: UILabel!
    @IBOutlet weak var startQuizButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    var socket: SocketIOClient?
    var deelnemers: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        var gradient: CAGradientLayer = CAGradientLayer()
        gradient.frame = view.bounds
        gradient.colors = [UIColor(red: 153.0/255.0, green: 153/255.0, blue: 153.0/255.0, alpha: 1).CGColor, UIColor(red: 153.0/255.0, green: 153.0/255.0, blue: 153.0/255.0, alpha: 1).CGColor]
        backgroundView.layer.insertSublayer(gradient, atIndex: 0)
        
        var int = Utils.openObjectFromDisk("quizCode") as! String
        quizCodeLabel.text = int
        
        let button: UIImage = UIImage(named: "element-18")!.resizableImageWithCapInsets(UIEdgeInsetsMake(6, 6, 6, 6), resizingMode: UIImageResizingMode.Stretch)
        startQuizButton.setBackgroundImage(button, forState: UIControlState.Normal)
        startQuizButton.layer.shadowColor = UIColor.blackColor().CGColor
        startQuizButton.layer.shadowOffset = CGSizeMake(0, 0);
        startQuizButton.layer.shadowOpacity = 1
        
        let delegate: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        socket = delegate.socket
        
        socket?.on("somebodyJoined", callback: somebodyJoined)
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func somebodyJoined(data: NSArray?, ack: AckEmitter?) {
        
        if let naam = data?[0].objectForKey("naam") as? String {
            deelnemers.append(naam)
            tableView.reloadData()
        }
        
    }
    
    @IBAction func startTheQuiz(sender: AnyObject) {
        
        var json = [
            "quizID" : Utils.openObjectFromDisk("quizCode"),
            "duration" : Utils.openObjectFromDisk("quizDuration")
        ]
        
        socket?.emit("startQuiz", json)
        self.performSegueWithIdentifier("goToQuizScore", sender: self)
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return deelnemers.count
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier("quizParticipant") as! UITableViewCell
        
        var label: UILabel? = cell.viewWithTag(1) as? UILabel
        
        label?.text = deelnemers[indexPath.row]
        
        return cell
        
    }

}
