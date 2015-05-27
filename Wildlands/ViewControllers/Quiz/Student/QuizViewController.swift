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
    @IBOutlet weak var bushbushView: UIImageView!
    @IBOutlet weak var questionImageView: UIImageView!

    var data: NSMutableData = NSMutableData()
    var questions: [Question] = []
    var currentQuestion: Int = 0
    var goodAnswerd: Int = 0
    
    var socket: SocketIOClient?
    
    var quizTimer: NSTimer?
    
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
        questionImageView.contentMode = .ScaleAspectFit;
        
        progressBar.progress = 1.0
        
        quizTimer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: "updateProgressbar", userInfo: nil, repeats: true)
        
        let delegate: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        socket = delegate.socket
        
        // Controleren of er vragen zijn
        if Utils.openObjectFromDisk(forKey: "questions") as? [Question] != nil {
            
            var sortQuestions = Utils.openObjectFromDisk(forKey: "questions") as! [Question]
            
            for theQuestion in sortQuestions {
                
                if theQuestion.levelID == quizLevel {
                    questions.append(theQuestion)
                }
                
            }
            
            showQuestion()
            
        } else {
            
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
    
    // MARK: - Quiz functions
    func showQuestion() {
        
        if currentQuestion > questions.count - 1 {
            
            self.performSegueWithIdentifier("quizIsOver", sender: self)
            return
            
        }
        
        var komtIe: Question = questions[currentQuestion] as Question
        vraagLabel.text = komtIe.text
        vraagLabel.numberOfLines = 0
        vraagLabel.sizeToFit()
        
        tableView.userInteractionEnabled = true
            
        var layer: CALayer = backgroundView.layer.valueForKey("gradient") as! CALayer
        layer.removeFromSuperlayer()
        backgroundView.layer.setValue(nil, forKey: "gradient")
        
        var gradient: CAGradientLayer = CAGradientLayer()
        gradient.frame = view.bounds
        
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
        
        backgroundView.layer.insertSublayer(gradient, atIndex: 0)
        backgroundView.layer.setValue(gradient, forKey: "gradient")
        tableView.reloadData()
        
        questionImageView.sd_setImageWithURL(NSURL(string: komtIe.imageURL))
        
    }
    
    // MARK: - Answer TableView
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let deVraag: Question = questions[currentQuestion] as Question;
        
        var cell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier("answerCell") as! UITableViewCell
        cell.backgroundColor = UIColor.clearColor()
        
        let hetAntwoord: Answer = deVraag.answers[indexPath.row]
        
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
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let antwoord: Answer = questions[currentQuestion].answers[indexPath.row]
        var cell: UITableViewCell? = tableView.cellForRowAtIndexPath(indexPath)
        
        var view: UIView? = cell!.viewWithTag(2)
        
        UIView.animateWithDuration(0.5, animations: {
            
            view?.backgroundColor = Colors.geel
            
        })
        
        var goodAnswer: Bool = false
        if antwoord.isRightAnswer {
            
            goodAnswerd += 1
            goodAnswer = true
            
        } else {
            
            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
            
        }
        tableView.userInteractionEnabled = false
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        var json = [
        
            "naam" : Utils.openObjectFromDisk(forKey: "quizName") as! String,
            "vraag" : (currentQuestion + 1),
            "goed" : goodAnswer,
            "quizID" : Utils.openObjectFromDisk(forKey: "quizCode") as! String
        ]
        
        socket?.emit("sendAnswer", json)
        
        // Maak nieuwe Score object aan voor uitslag
        let score = Score()
        score.question = questions[currentQuestion]
        score.correctlyAnswerd = goodAnswer
        endScore.append(score)
        
        currentQuestion = currentQuestion + 1
        var nextQuestion = [currentQuestion]
        var timer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: Selector("showQuestion"), userInfo: nil, repeats: false)
        
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        return 55.0
        
    }
    
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
        
        if buttonIndex == 0 {
            
            navigationController?.popToRootViewControllerAnimated(true)
            
        }
        
    }
    
    // MARK: - Button functions
    @IBAction func goBackButton(sender: AnyObject) {
        
        navigationController?.popToRootViewControllerAnimated(true)
        
    }
    
    // MARK: - Timer Bar
    func updateProgressbar() {
        
        var duration = Float(Utils.openObjectFromDisk(forKey: "quizDuration") as! Int) * 60.0
        
        var step: Float = 1.0 / duration
        var newValue = self.progressBar.progress - step
        progressBar.setProgress(newValue, animated: true)
        
        if newValue <= 0 {
            
            self.performSegueWithIdentifier("quizIsOver", sender: self)
            quizTimer?.invalidate()
            
        }
        
    }
    
    // MARK: - AlertView actions
    func JSSAlertViewButtonPressed() {
        self.performSegueWithIdentifier("quizIsOver", sender: self)
    }
    
    func JSSAlertViewCancelButtonPressed() {
    }
    
    // MARK: - Segues
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        var destinationViewController = segue.destinationViewController as! QuizDidEndViewController
        destinationViewController.endScore = self.endScore
        
    }
    
}
