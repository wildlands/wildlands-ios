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
    @IBOutlet weak var quizCodeLabelBackground: UIImageView!
    @IBOutlet weak var startQuizButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    var socket: SocketIOClient?
    var deelnemers: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        backgroundView.layer.insertSublayer(WildlandsGradient.grayGradient(forBounds: view.bounds), atIndex: 0)
        
        var int = Utils.openObjectFromDisk(forKey: "quizCode") as! String
        quizCodeLabel.text = int
        
        let background: UIImage = UIImage(named: "black-button")!.resizableImageWithCapInsets(UIEdgeInsetsMake(6, 6, 6, 6), resizingMode: UIImageResizingMode.Stretch)
        quizCodeLabelBackground.image = background
        
        startQuizButton = WildlandsButton.createButtonWithImage(named: "default-button", forButton: startQuizButton)
        
        let delegate: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        socket = delegate.socket
        
        socket?.on("somebodyJoined", callback: somebodyJoined)
        socket?.on("somebodyLeaved", callback: somebodyLeaved)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Socket IO
    func somebodyJoined(data: NSArray?, ack: AckEmitter?) {
        
        if let naam = data?[0].objectForKey("naam") as? String {
            deelnemers.append(naam)
            tableView.reloadData()
        }
        
    }
    
    func somebodyLeaved(data: NSArray?, ack: AckEmitter?) {
        
        if let naam = data?[0].objectForKey("naam") as? String {
            
            // Loop through all the participants so far
            for (index, deelnemer) in enumerate(deelnemers) {
                if deelnemer == naam {
                    deelnemers.removeAtIndex(index)
                    break;
                }
            }
            
            tableView.reloadData()
        }
        
    }
    
    // MARK: - Button actions
    @IBAction func startTheQuiz(sender: AnyObject) {
        
        let currentLevel = Utils.openObjectFromDisk(forKey: "currentLevel") as! Level
        
        var json = [
            "quizID" : Utils.openObjectFromDisk(forKey: "quizCode")!,
            "duration" : Utils.openObjectFromDisk(forKey: "quizDuration")!,
            "level" : currentLevel.id
        ]
        
        socket?.emit("startQuiz", json)
        self.performSegueWithIdentifier("goToQuizScore", sender: self)
        
    }
    
    @IBAction func cancelQuiz(sender: AnyObject) {
        
        self.navigationController?.popViewControllerAnimated(false)
        
    }
    
    // MARK: - Leerlingen TableView
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
