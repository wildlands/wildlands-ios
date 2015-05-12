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

class QuizViewController: UIViewController, JSONDownloaderDelegate, UITableViewDelegate, UITableViewDataSource, UIAlertViewDelegate {
    
    @IBOutlet var backgroundView: UIView!
    @IBOutlet weak var bushbushView: UIImageView!

    var data: NSMutableData = NSMutableData()
    var questions: [Question] = []
    var currentQuestion: Int = 0
    var goodAnswerd: Int = 0
    
    var socket: SocketIOClient?
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var vraagLabel: UILabel!
    @IBOutlet weak var progressBar: UIProgressView!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        vraagLabel.text = ""
        vraagLabel.font = Fonts.defaultFont(16)
        
        tableView.setTranslatesAutoresizingMaskIntoConstraints(false)
        tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        tableView.backgroundColor = UIColor.clearColor()
        
        var questionDownload = JSONDownloader()
        questionDownload.delegate = self
        questionDownload.downloadJSON(DownloadType.DOWNLOAD_QUESTIONS)
        
        progressBar.progress = 1.0
        
        NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: "updateProgressbar", userInfo: nil, repeats: true)
        
        let delegate: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        socket = delegate.socket
        
    }
    
    func JSONDownloaderSuccess(response: AnyObject) {
        
        if (response is [Question]) {
            
            let questionResponse = response as? [Question]
            questions = questionResponse!
            showQuestion()
            
        } else {
            
            print("Onbekende response ontvangen")
            
        }
        
    }
    
    func JSONDownloaderFailed(message: String, type: DownloadType) {
        
        let failAlert: UIAlertView = UIAlertView(title: "Error", message: message, delegate: self, cancelButtonTitle: "Helaas")
        failAlert.show()
        
    }
    
    func showQuestion() {
        
        if currentQuestion > questions.count - 1 {
            
            let alertMessage: String = "De quiz is afgerond. U heeft \(goodAnswerd) vragen goed beantwoord."
            var alert: UIAlertView = UIAlertView(title: "Quiz beeindigd", message: alertMessage, delegate: self, cancelButtonTitle: "Oké")
            alert.show()
            return
            
        }
        
        var komtIe: Question = questions[currentQuestion] as Question
        vraagLabel.text = komtIe.text
        vraagLabel.numberOfLines = 0
        vraagLabel.sizeToFit()
        
        tableView.userInteractionEnabled = true
        
        if currentQuestion != 0 {
            
            var layer: CALayer = backgroundView.layer.valueForKey("gradient") as! CALayer
            layer.removeFromSuperlayer()
            backgroundView.layer.setValue(nil, forKey: "gradient")
            
        }
        
        var gradient: CAGradientLayer = CAGradientLayer()
        gradient.frame = view.bounds
        
        if komtIe.typeName == "Bio Mimicry" {
            bushbushView.image = UIImage(named: "element-05.png")
            gradient.colors = [UIColor(red: 174.0/255.0, green: 100.0/255.0, blue: 255.0/255.0, alpha: 1).CGColor, UIColor(red: 255.0/255.0, green: 144.0/255.0, blue: 255.0/255.0, alpha: 1).CGColor]
        }
        if komtIe.typeName == "Materiaal" {
            bushbushView.image = UIImage(named: "element-06.png")
            gradient.colors = [UIColor(red: 135.0/255.0, green: 114.0/255.0, blue: 46.0/255.0, alpha: 1).CGColor, UIColor(red: 202.0/255.0, green: 169.0/255.0, blue: 109.0/255.0, alpha: 1).CGColor]
        }
        if komtIe.typeName == "Energie" {
            bushbushView.image = UIImage(named: "element-04.png")
            gradient.colors = [UIColor(red: 255.0/255.0, green: 172.0/255.0, blue: 0.0/255.0, alpha: 1).CGColor, UIColor(red: 255.0/255.0, green: 225.0/255.0, blue: 2.0/255.0, alpha: 1).CGColor]
        }
        if komtIe.typeName == "Water" {
            bushbushView.image = UIImage(named: "element-03.png")
            gradient.colors = [UIColor(red: 0.0/255.0, green: 92.0/255.0, blue: 255.0/255.0, alpha: 1).CGColor, UIColor(red: 0.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 1).CGColor]
            
        }
        
        backgroundView.layer.insertSublayer(gradient, atIndex: 0)
        backgroundView.layer.setValue(gradient, forKey: "gradient")
        tableView.reloadData()
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let deVraag: Question = questions[currentQuestion] as Question;
        
        var cell:UITableViewCell = tableView.dequeueReusableCellWithIdentifier("answerCell") as! UITableViewCell
        cell.backgroundColor = UIColor.clearColor()
        
        let hetAntwoord: Answer = deVraag.answers[indexPath.row]
        
        var label: UILabel? = cell.viewWithTag(1) as? UILabel
        var view: UIView? = cell.viewWithTag(2)
        
        view?.layer.cornerRadius = 10
        view?.layer.shadowColor = UIColor.blackColor().CGColor
        view?.layer.shadowOffset = CGSize(width: 0, height: 0)
        view?.layer.shadowOpacity = 1
        
        
        label?.text = hetAntwoord.text?.uppercaseString
        
        return cell
        
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 1;
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if (questions.count > 1) {
            return questions[currentQuestion].answers.count
        }
        
        return 0
    
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let antwoord: Answer = questions[currentQuestion].answers[indexPath.row]
        let cell: UITableViewCell? = tableView.cellForRowAtIndexPath(indexPath)
        var goodAnswer: Bool = false
        if antwoord.isRightAnswer {
            
            goodAnswerd += 1
            goodAnswer = true
            
        }
        tableView.userInteractionEnabled = false
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        var json = [
        
            "naam" : Utils.openObjectFromDisk("quizName") as! String,
            "vraag" : (currentQuestion + 1),
            "goed" : goodAnswer,
            "quizID" : Utils.openObjectFromDisk("quizCode") as! String
        ]
        
        socket?.emit("sendAnswer", json)
        
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
    
    @IBAction func goBackButton(sender: AnyObject) {
        
        navigationController?.popToRootViewControllerAnimated(true)
        
    }
    
    func updateProgressbar() {
        
        var duration = Float(Utils.openObjectFromDisk("quizDuration") as! Int) * 60.0
        
        var step: Float = 1.0 / duration
        var newValue = self.progressBar.progress - step
        progressBar.setProgress(newValue, animated: true)
        
        if newValue <= 0 {
            
            self.performSegueWithIdentifier("quizIsOver", sender: self)
            
        }
        
    }
    
}
