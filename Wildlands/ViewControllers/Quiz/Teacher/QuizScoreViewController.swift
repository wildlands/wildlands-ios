//
//  QuizScoreViewController.swift
//  Wildlands
//
//  Created by Jan Doornbos on 12-05-15.
//  Copyright (c) 2015 INF2A. All rights reserved.
//

import UIKit
import Socket_IO_Client_Swift

class QuizScoreViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, JSSAlertViewDelegate {

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

        // Get socket from the App delegate
        let delegate: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        socket = delegate.socket
        
        // Add socket handler
        socket?.on("receiveAnswer", callback: answerReceived)
        
        // Set a timer for the quiz
        timer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: "updateProgress", userInfo: nil, repeats: true)
        
        // Get the current level
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
    
    /**
        An answer is send by a student and received by this device.

        :param: data        The data from Socket.IO server
        :param: ack         ...
     */
    func answerReceived(data: NSArray?, ack: AckEmitter?) {
        
        // Unwrap the response
        if let naam = data?[0].objectForKey("naam") as? String, goed = data?[0].objectForKey("goed") as? Bool, questionID = data?[0].objectForKey("vraag") as? Int {
            
            // Make Score object
            var score: Score = Score()
            score.question = theQuestions[questionID]
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
        
        if score.count == theQuestions.count {
            cell.accessoryType = UITableViewCellAccessoryType.Checkmark
        }
        
        return cell
        
    }
    
    // MARK: - Timer
    
    /**
        Update the progressView, so teacher can see how many time is left for the quiz.
     */
    func updateProgress() {
        
        var duration = Float(Utils.openObjectFromDisk(forKey: "quizDuration") as! Int) * 60
        var step: Float = 1.0 / duration
        
        var newValue = self.progressView.progress - step
        
        // Make the setValue async
        dispatch_async(dispatch_get_main_queue(), {
        
            self.progressView.setProgress(newValue, animated: true)
            
        })
        
        // If there is no time left
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
            
            // Remove the receiveAnswer event
            socket?.off("receiveAnswer")
            
            let destController: QuizSendScoreViewController = segue.destinationViewController as! QuizSendScoreViewController
            destController.deelnemers = self.deelnemers
            
        }
        
    }

    // MARK: - Button actions
    
    /**
        Cancel the quiz.

        :param: sender      The button who calls this action.
     */
    @IBAction func cancelTheQuiz(sender: AnyObject) {
    
        // Show an confirm message to make sure the teacher wants to cancel the quiz
        var alertIcon: UIImage = Utils.fontAwesomeToImageWith(string: "\u{f128}", andColor: UIColor.whiteColor())
        var alert = JSSAlertView()
        alert.show(self, title: NSLocalizedString("quizAbortSureTitle", comment: "").uppercaseString, text: NSLocalizedString("quizAbortSureText", comment: ""), buttonText: NSLocalizedString("yes", comment: ""), cancelButtonText: NSLocalizedString("no", comment: ""), color: UIColorFromHex(0xc1272d, alpha: 1.0), iconImage: alertIcon, delegate: nil)
        alert.delegate = self
        alert.tag = 1
        
    }
    
    /**
        Skip the quiz and go to the score.
        
        :param: sender      The button who calls this action.
     */
    @IBAction func skipTheQuiz(sender: AnyObject) {
        
        // Show an confirm message to make sure the teacher wants to skip the quiz
        var alertIcon: UIImage = Utils.fontAwesomeToImageWith(string: "\u{f050}", andColor: UIColor.whiteColor())
        var alert = JSSAlertView()
        alert.show(self, title: NSLocalizedString("quizSkipSureTitle", comment: "").uppercaseString, text: NSLocalizedString("quizSkipSureText", comment: ""), buttonText: NSLocalizedString("yes", comment: ""), cancelButtonText: NSLocalizedString("no", comment: ""), color: UIColorFromHex(0xc1272d, alpha: 1.0), iconImage: alertIcon, delegate: nil)
        alert.delegate = self
        alert.tag = 2
        
    }
    
    // MARK: - AlertVieW Delegate
    func JSSAlertViewButtonPressed(forAlert: JSSAlertView) {
        
        // Stop the timer
        timer.invalidate()
        
        // Make a JSON object
        var json = [
            "quizID" : Utils.openObjectFromDisk(forKey: "quizCode") as! String
        ]
        
        // Abort alert
        if forAlert.tag == 1 {
            
            // Send
            socket?.emit("abortQuiz", json)
            // Go to QuizChooseViewController
            self.navigationController?.popViewControllerAnimated(false)
            
        // Skip alert
        } else if forAlert.tag == 2 {
            
            socket?.emit("skipQuiz", json)
            // Go to QuizSendScoreViewController
            self.performSegueWithIdentifier("goToQuizDidEnd", sender: self)
            
        }
        
    }
    
    func JSSAlertViewCancelButtonPressed(forAlert: JSSAlertView) {
        // Do nothing, just ignore the alert
        // This function has to be implemented, because Swift doesn't accept optional delegate functions yet
    }
    
}
