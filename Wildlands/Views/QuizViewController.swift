//
//  VraagViewController.swift
//  Wildlands
//
//  Created by Jan on 18-03-15.
//  Copyright (c) 2015 INF2A. All rights reserved.
//

import UIKit
import Foundation

class QuizViewController: UIViewController, JSONDownloaderDelegate, UITableViewDelegate, UITableViewDataSource, UIAlertViewDelegate {
    
    @IBOutlet var backgroudView: UIView!

    var data: NSMutableData = NSMutableData()
    var questions: [Question] = []
    var currentQuestion: Int = 0
    var goodAnswerd: Int = 0
    var tableView: UITableView = UITableView()
    
    @IBOutlet weak var vraagLabel: UILabel!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        vraagLabel.text = ""
        vraagLabel.font = Fonts.defaultFont(16)
        
        navigationController?.navigationBar.barTintColor = Colors.bruin;
        backgroudView.layer.cornerRadius = 10
        
        print(backgroudView.frame)
        
        tableView.setTranslatesAutoresizingMaskIntoConstraints(false)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = UIColor.whiteColor()
        tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        tableView.backgroundColor = UIColor.clearColor()
        
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "answerCell")
        
        backgroudView.addSubview(tableView)
        
        let bindings = ["tableView" : tableView]
        var format: String = "H:|-20-[tableView]-20-|"
        var constraints = NSLayoutConstraint.constraintsWithVisualFormat(format, options: NSLayoutFormatOptions(0), metrics: nil, views: bindings)
        
        backgroudView.addConstraints(constraints)
        
        format = "V:[tableView(200)]-20-|"
        constraints = NSLayoutConstraint.constraintsWithVisualFormat(format, options: NSLayoutFormatOptions(0), metrics: nil, views: bindings)
        
        backgroudView.addConstraints(constraints)
        
        print(tableView.frame)
        
        var questionDownload = JSONDownloader()
        questionDownload.delegate = self
        questionDownload.downloadJSON(DownloadType.DOWNLOAD_QUESTIONS)
        
        
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
        
        tableView.reloadData()
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let deVraag: Question = questions[currentQuestion] as Question;
        
        var cell:UITableViewCell = tableView.dequeueReusableCellWithIdentifier("answerCell") as! UITableViewCell
        
        let hetAntwoord: Answer = deVraag.answers[indexPath.row]
        
        cell.textLabel?.text = hetAntwoord.text
        cell.backgroundColor = UIColor.clearColor()
        cell.textLabel?.textColor = UIColor.blackColor()
        
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
        if antwoord.isRightAnswer {
            
            cell?.backgroundColor = UIColor.greenColor()
            goodAnswerd += 1
            
        } else {
            
            cell?.backgroundColor = UIColor.redColor()
            
        }
        tableView.userInteractionEnabled = false
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        currentQuestion = currentQuestion + 1
        var nextQuestion = [currentQuestion]
        var timer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: Selector("showQuestion"), userInfo: nil, repeats: false)
        
    }
    
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
        
        if buttonIndex == 0 {
            
            navigationController?.popToRootViewControllerAnimated(true)
            
        }
        
    }
    
    @IBAction func goBackButton(sender: AnyObject) {
        
        navigationController?.popToRootViewControllerAnimated(true)
        
    }
}
