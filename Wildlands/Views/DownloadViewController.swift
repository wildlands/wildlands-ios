//
//  DownloadViewController.swift
//  Wildlands
//
//  Created by Jan Doornbos on 01-05-15.
//  Copyright (c) 2015 INF2A. All rights reserved.
//

import UIKit

class DownloadViewController: UIViewController, JSONDownloaderDelegate, UIAlertViewDelegate {

    @IBOutlet weak var backgroundView: UIView!
    
    let contentDownloader: JSONDownloader = JSONDownloader()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        backgroundView.layer.insertSublayer(WildlandsGradient.greenGradient(forBounds: view.bounds), atIndex: 0)
        
        contentDownloader.delegate = self
        startDownloading()
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func startDownloading() {
        
        let defaults: NSUserDefaults = NSUserDefaults.standardUserDefaults()
        if defaults.objectForKey("pinpoints") == nil {
            
            downloadContent()
            
        } else {
            
            checkDatabaseChecksum()
            
        }
        
    }
    
    func checkDatabaseChecksum() {
        
        println("Downloaden checksum")
        contentDownloader.downloadJSON(DownloadType.DOWNLOAD_CHECKUM)
        
    }
    
    func downloadContent() {
        
        println("Downloaden pinpoints")
        contentDownloader.downloadJSON(DownloadType.DOWNLOAD_PINPOINTS)
        
    }
    
    func downloadLevels() {
        
        println("Downloaden levels")
        contentDownloader.downloadJSON(DownloadType.DOWNLOAD_LEVELS)
        
    }
    
    func downloadQuizQuestions() {
        
        println("Downloaden questions")
        contentDownloader.downloadJSON(DownloadType.DOWNLOAD_QUESTIONS)
        
    }
    
    func JSONDownloaderFailed(message: String, type: DownloadType) {
        
        let failAlert: UIAlertView = UIAlertView(title: "Error", message: message, delegate: self, cancelButtonTitle: "Helaas")
        failAlert.show()
        
    }
    
    func JSONDownloaderSuccess(response: AnyObject) {
        
        if response is [Pinpoint] {
            
            let pinpointResponse = response as? [Pinpoint]
            Utils.saveObjectToDisk(pinpointResponse!, forKey: "pinpoints")
            downloadLevels()
            
        } else if response is Int {
            
            if response as! Int != NSUserDefaults.standardUserDefaults().objectForKey("checksum") as! Int {
                
                println("Nieuwe database!")
                NSUserDefaults.standardUserDefaults().setObject(response, forKey: "checksum")
                NSUserDefaults.standardUserDefaults().synchronize()
                downloadContent()
                
            } else {
                
                self.performSegueWithIdentifier("goToChooseDoelgroep", sender: self)
                
            }
            
        } else if response is [Level] {
            
            let levelResponse = response as? [Level]
            Utils.saveObjectToDisk(levelResponse!, forKey: "levels")
            downloadQuizQuestions()
            
            
        } else if (response is [Question]) {
            
            let questionResponse = response as? [Question]
            Utils.saveObjectToDisk(questionResponse!, forKey: "questions")
            self.performSegueWithIdentifier("goToChooseDoelgroep", sender: self)
            
        } else {
            
            print("Onbekende response ontvangen")
            
        }
        
    }
    
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
        
        startDownloading()
        
    }

}
