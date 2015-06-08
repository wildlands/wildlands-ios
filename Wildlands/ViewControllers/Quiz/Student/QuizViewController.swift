//
//  VraagViewController.swift
//  Wildlands
//
//  Created by Jan on 18-03-15.
//  Copyright (c) 2015 INF2A. All rights reserved.
//

import UIKit
import Foundation
import Socket_IO_Client_Swift
import AudioToolbox
import SDWebImage

class QuizViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, JSSAlertViewDelegate {
    
    @IBOutlet var backgroundView: UIView!
    // The view above the gradient (with bush shape)
    @IBOutlet weak var bushbushView: UIImageView!
    @IBOutlet weak var questionImageView: UIImageView!
    @IBOutlet weak var activitySpinner: UIActivityIndicatorView!

    var questions: [Question] = []
    var currentQuestion: Int = 0
    
    var socket: SocketIOClient?
    
    var quizTimer: NSTimer = NSTimer()
    
    // Placeholder for the score
    var endScore: [Score] = []
    
    var quizLevel: Int = 0
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var vraagLabel: UILabel!
    @IBOutlet weak var progressBar: UIProgressView!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        var gradient = WildlandsGradient.greenGradient(forBounds: view.bounds)
        backgroundView.layer.insertSublayer(gradient, atIndex: 0)
        backgroundView.layer.setValue(gradient, forKey: "gradient")
        
        vraagLabel.text = ""
        vraagLabel.font = Fonts.defaultFont(16)
        
        tableView.setTranslatesAutoresizingMaskIntoConstraints(false)
        tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        tableView.backgroundColor = UIColor.clearColor()
        
        questionImageView.clipsToBounds = true
        questionImageView.contentMode = .ScaleAspectFill;
        
        progressBar.progress = 1.0
        
        // Set the quiz timer
        quizTimer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: "updateProgressbar", userInfo: nil, repeats: true)
        
        // Get Socket from the delegate
        let delegate: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        socket = delegate.socket
        
        socket?.on("quizAborted", callback: quizAborted)
        socket?.on("quizSkiped", callback: quizSkiped)
        
        // Check if there are any Questions on the disk
        if let sortQuestions = Utils.openObjectFromDisk(forKey: "questions") as? [Question] {
            
            // Select the questions with the same level is the quiz
            questions = sortQuestions.filter() { $0.levelID == self.quizLevel }
            // Sort the questions by ID
            questions.sort({ $0.id < $1.id })
            
            // Lets go!
            showQuestion()
            
        } else {
            
            // No questions have been found, show a alert
            var image: UIImage = Utils.fontAwesomeToImageWith(string: "\u{f00d}", andColor: UIColor.whiteColor())
            var alert = JSSAlertView().show(
                self,
                title : NSLocalizedString("failure", comment: "").uppercaseString,
                text : NSLocalizedString("quizNoQuestionsFound", comment: ""),
                buttonText : NSLocalizedString("helaas", comment: ""),
                color: UIColorFromHex(0xc1272d, alpha: 1.0),
                iconImage: image
            )
            
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Socket.IO
    
    /**
        Function is called by Socket.IO if quiz is aborted.

        :param: data        Data send by the Socket
        :param: ack         Acknowledgend
     */
    func quizAborted(data: NSArray?, ack: AckEmitter?) {
        
        // Alert
        var alert = JSSAlertView()
        let icon = Utils.fontAwesomeToImageWith(string: "\u{f127}", andColor: UIColor.whiteColor())
        alert.show(self, title: NSLocalizedString("quizAbortedTitle", comment: "").uppercaseString, text: NSLocalizedString("quizAbortedText", comment: ""), buttonText: NSLocalizedString("helaas", comment: ""), cancelButtonText: nil, color: UIColorFromHex(0xc1272d, alpha: 1), iconImage: icon, delegate: nil)
        alert.delegate = self
        alert.tag = 1
        
    }
    
    /**
        Function is called by Socket.IO if teacher finishes the quiz.
    
        :param: data        Data send by the Socket
        :param: ack         Acknowledgend
     */
    func quizSkiped(data: NSArray?, ack: AckEmitter?) {
        
        self.performSegueWithIdentifier("quizIsOver", sender: self)
        
    }
    
    // MARK: - Quiz functions
    
    /**
        Shows the next question
     */
    func showQuestion() {
        
        // End the quiz if it is the last question
        if currentQuestion > questions.count - 1 {
            
            quizTimer.invalidate()
            
            // Go to QuizDidEndViewController
            self.performSegueWithIdentifier("quizIsOver", sender: self)
            
            // Stop the function
            return
            
        }
        
        // Put the current question in the label
        var komtIe: Question = questions[currentQuestion] as Question
        vraagLabel.text = komtIe.text
        vraagLabel.numberOfLines = 0
        vraagLabel.sizeToFit()
        
        // Enable the tableView again so the user can give an answer
        tableView.userInteractionEnabled = true
        
        // Remove the current background gradient
        var layer: CALayer = backgroundView.layer.valueForKey("gradient") as! CALayer
        layer.removeFromSuperlayer()
        backgroundView.layer.setValue(nil, forKey: "gradient")
        
        var gradient: CAGradientLayer = CAGradientLayer()
        gradient.frame = view.bounds
        
        // Color the background depending on the question theme
        if komtIe.typeName == "Bio Mimicry" {
            bushbushView.image = UIImage(named: "element-05.png")
            gradient.colors = WildlandsGradient.biomimicryColors()
        }
        if komtIe.typeName == "Materiaal" {
            bushbushView.image = UIImage(named: "element-06.png")
            gradient.colors = WildlandsGradient.materiaalColors()
        }
        if komtIe.typeName == "Energie" {
            bushbushView.image = UIImage(named: "element-04.png")
            gradient.colors = WildlandsGradient.energieColors()
        }
        if komtIe.typeName == "Water" {
            bushbushView.image = UIImage(named: "element-03.png")
            gradient.colors = WildlandsGradient.waterColors()
            
        }
        if komtIe.typeName == "Dierenwelzijn" {
            bushbushView.image = UIImage(named: "element-dierenwelzijn.png")
            gradient.colors = WildlandsGradient.dierenwelzijnColors()
        }
        
        // Add the gradient to the background
        backgroundView.layer.insertSublayer(gradient, atIndex: 0)
        backgroundView.layer.setValue(gradient, forKey: "gradient")
        
        // Reload the answers in the tableView
        tableView.reloadData()
        
        // Get the question image
        activitySpinner.startAnimating()
        questionImageView.sd_setImageWithURL(NSURL(string: komtIe.imageURL), completed: { (image: UIImage!, error: NSError!, cacheType: SDImageCacheType, url: NSURL!) -> Void in
            
            self.activitySpinner.stopAnimating()
            
        })
        
    }
    
    // MARK: - Answer TableView
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let deVraag: Question = questions[currentQuestion] as Question;
        
        var cell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier("answerCell") as! UITableViewCell
        cell.backgroundColor = UIColor.clearColor()
        
        let hetAntwoord: Answer = deVraag.answers[indexPath.row]
        
        // Get labels from the custom cell
        var label: UILabel? = cell.viewWithTag(1) as? UILabel
        var view: UIView? = cell.viewWithTag(2)
        
        view?.backgroundColor = UIColor.whiteColor()
        view?.layer.cornerRadius = 10
        view?.layer.shadowColor = UIColor.blackColor().CGColor
        view?.layer.shadowOffset = CGSize(width: 0, height: 0)
        view?.layer.shadowOpacity = 1
        
        label?.text = hetAntwoord.text.uppercaseString
        
        return cell
        
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 1;
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if questions.count >= 1 {
            return questions[currentQuestion].answers.count
        }
        
        return 0
    
    }
    
    /**
        Answer is pressed.
     */
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let antwoord: Answer = questions[currentQuestion].answers[indexPath.row]
        var cell: UITableViewCell? = tableView.cellForRowAtIndexPath(indexPath)
        
        var view: UIView? = cell!.viewWithTag(2)
        
        // Make the choosen cell yellow
        UIView.animateWithDuration(0.5, animations: {
            
            view?.backgroundColor = Colors.geel
            
        })
        
        var goodAnswer: Bool = false
        if antwoord.isRightAnswer {
            
            goodAnswer = true
            
        } else {
            
            // Wrong answer, viberate the iPhone
            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
            
        }
        
        // Disable tableView, so user can't give more than one answers
        tableView.userInteractionEnabled = false
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        // Make a JSON object for sending
        var json = [
        
            "naam" : Utils.openObjectFromDisk(forKey: "quizName") as! String,
            "vraag" : currentQuestion,
            "goed" : goodAnswer,
            "quizID" : Utils.openObjectFromDisk(forKey: "quizCode") as! String
        ]
        
        // Send the JSON object to the teacher
        socket?.emit("sendAnswer", json)
        
        // Make an new Score object
        let score = Score()
        score.question = questions[currentQuestion]
        score.correctlyAnswerd = goodAnswer
        endScore.append(score)
        
        currentQuestion = currentQuestion + 1
        var nextQuestion = [currentQuestion]
        
        // Wait 1 second before going to the next question
        var timer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: Selector("showQuestion"), userInfo: nil, repeats: false)
        
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        return 55.0
        
    }
    
    // MARK: - Button functions
    
    /**
        Go back to the previous ViewController (in this case QuizChooseViewController).
     */
    @IBAction func goBackButton(sender: AnyObject) {
        
        quizTimer.invalidate()
        navigationController?.popToRootViewControllerAnimated(true)
        
    }
    
    // MARK: - Timer Bar
    
    /**
        Update the progressBar, so the user can see how many time is left.
     */
    func updateProgressbar() {
        
        // Get duration from quiz
        var duration = Float(Utils.openObjectFromDisk(forKey: "quizDuration") as! Int) * 60.0
        
        // Calculate bar length
        var step: Float = 1.0 / duration
        var newValue = self.progressBar.progress - step
        progressBar.setProgress(newValue, animated: true)
        
        // There is no time left
        if newValue <= 0 {
            
            // Disable timer
            quizTimer.invalidate()
            
            // Go the QuizDidEndViewController
            self.performSegueWithIdentifier("quizIsOver", sender: self)
            
        }
        
    }
    
    // MARK: - AlertView actions
    func JSSAlertViewButtonPressed(forAlert: JSSAlertView) {
        
        // Alert for a aborted quiz
        if forAlert.tag == 1 {
        
            self.navigationController?.popViewControllerAnimated(true)
            
        }
        
    }
    
    func JSSAlertViewCancelButtonPressed(forAlert: JSSAlertView) {
    }
    
    // MARK: - Segues
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "quizIsOver" {
        
            socket?.off("quizAborted")
            socket?.off("quizSkiped")
        
            var destinationViewController = segue.destinationViewController as! QuizDidEndViewController
            destinationViewController.endScore = self.endScore
            
        }
        
    }
    
}
