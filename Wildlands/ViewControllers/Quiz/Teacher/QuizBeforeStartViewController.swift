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
        
        // Get socket from the App delegate
        let delegate: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        socket = delegate.socket
        
        // Add socket handlers
        socket?.on("somebodyJoined", callback: somebodyJoined)
        socket?.on("somebodyLeaved", callback: somebodyLeaved)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Socket IO
    
    /**
        A student joined the quiz.

        :param: data           Response from Socket.IO server.
        :param: ack            ... 
     */
    func somebodyJoined(data: NSArray?, ack: AckEmitter?) {
        
        // Unwrap the response
        if let naam = data?[0].objectForKey("naam") as? String {
            deelnemers.append(naam)
            tableView.reloadData()
        }
        
    }
    
    /**
        A student leaved the quiz.
    
        :param: data            Response from Socket.IO sever.
        :param: ack             ...
     */
    func somebodyLeaved(data: NSArray?, ack: AckEmitter?) {
        
        // Unwrap the response
        if let naam = data?[0].objectForKey("naam") as? String {
            
            // Loop through all the participants so far
            for (index, deelnemer) in enumerate(deelnemers) {
                if deelnemer == naam {
                    deelnemers.removeAtIndex(index)
                    break;
                }
            }
            
            // Reload the tableView with the new data
            tableView.reloadData()
        }
        
    }
    
    // MARK: - Button actions
    
    /**
        Start the quiz on every device who joined the quiz.
    
        :param: sender          The button who calls this function.
     */
    @IBAction func startTheQuiz(sender: AnyObject) {
        
        // Get the current level from the teacher and set this as level 
        // for the quiz
        let currentLevel = Utils.openObjectFromDisk(forKey: "currentLevel") as! Level
        
        // Make a JSON object
        var json = [
            "quizID" : Utils.openObjectFromDisk(forKey: "quizCode")!,
            "duration" : Utils.openObjectFromDisk(forKey: "quizDuration")!,
            "level" : currentLevel.id
        ]
        
        // Send socket message
        socket?.emit("startQuiz", json)
        // Go the next screen (in this case: QuizScoreViewController)
        self.performSegueWithIdentifier("goToQuizScore", sender: self)
        
    }
    
    /**
        Cancel the quiz.

        :param: sender          The button who calls this function.
     */
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
