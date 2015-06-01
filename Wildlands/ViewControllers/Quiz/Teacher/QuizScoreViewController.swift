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
    
    var timer: NSTimer = NSTimer()
    
    var socket: SocketIOClient?
    
    var deelnemers = [String: [Score]]()
    
    var theQuestions: [Question] = []
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        backgroundView.layer.insertSublayer(WildlandsGradient.greenGradient(forBounds: view.bounds), atIndex: 0)

        let delegate: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        socket = delegate.socket
        
        socket?.on("receiveAnswer", callback: answerReceived)
        
        timer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: "updateProgress", userInfo: nil, repeats: true)
        
        let currentLevel = Utils.openObjectFromDisk(forKey: "currentLevel") as! Level
        
        if let questions = Utils.openObjectFromDisk(forKey: "questions") as? [Question] {
            
            // Filter the questions
            theQuestions = questions.filter() { $0.levelID == currentLevel.id }
            // Sort the questions
            theQuestions.sort({ $0.id < $1.id })
        
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Socket IO
    func answerReceived(data: NSArray?, ack: AckEmitter?) {
        
        if let naam = data?[0].objectForKey("naam") as? String, goed = data?[0].objectForKey("goed") as? Bool, questionID = data?[0].objectForKey("vraag") as? Int {
            
            // Make Score object
            var score: Score = Score()
            score.question = theQuestions[questionID-1]
            score.correctlyAnswerd = goed
            
            // If participant doesn't exists in our array yet
            if (deelnemers[naam] == nil) {
                deelnemers[naam] = []
            }
            
            // Append current score to the score
            var currentScore: [Score] = deelnemers[naam]!
            currentScore.append(score)
            deelnemers[naam] = currentScore

            tableView.reloadData()
        }
        
    }
    
    // MARK: - Score TableView
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return deelnemers.count;
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier("quizScore") as! UITableViewCell
        
        var keys = Array(deelnemers.keys)
        let rowKey = keys[indexPath.row]
        
        var nameLabel: UILabel? = cell.viewWithTag(1) as? UILabel
        var scoreLabel: UILabel? = cell.viewWithTag(2) as? UILabel
        
        var score: [Score] = deelnemers[rowKey]!
        var goodAnswerd = score.filter() { $0.correctlyAnswerd == true }
        
        nameLabel?.text = rowKey
        scoreLabel?.text = "\(goodAnswerd.count)/\(theQuestions.count)"
        
        return cell
        
    }
    
    // MARK: - Timer
    func updateProgress() {
        
        var duration = Float(Utils.openObjectFromDisk(forKey: "quizDuration") as! Int) * 60
        var step: Float = 1.0 / duration
        
        var newValue = self.progressView.progress - step
        progressView.setProgress(newValue, animated: true)
        
        if newValue <= 0 {
            
            // Stop the quiz timer
            timer.invalidate()
            
            // Time is over, go to the score
            self.performSegueWithIdentifier("goToQuizDidEnd", sender: self)
            
        }
        
    }
    
    // MARK: - Segues
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "goToQuizDidEnd" {
            
            let destController: QuizSendScoreViewController = segue.destinationViewController as! QuizSendScoreViewController
            destController.deelnemers = self.deelnemers
            
        }
        
    }

    // MARK: - Button actions
    @IBAction func cancelTheQuiz(sender: AnyObject) {
    
        timer.invalidate()
        
        var json = [
            "quizID" : Utils.openObjectFromDisk(forKey: "quizCode") as! String
        ]
        
        socket?.emit("abortQuiz", json)
        self.navigationController?.popViewControllerAnimated(false)
        
    }
    
}
