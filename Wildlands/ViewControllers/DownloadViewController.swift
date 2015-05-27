//
//  DownloadViewController.swift
//  Wildlands
//
//  Created by Jan Doornbos on 01-05-15.
//  Copyright (c) 2015 INF2A. All rights reserved.
//

import UIKit
import SDWebImage

class DownloadViewController: UIViewController, JSONDownloaderDelegate, JSSAlertViewDelegate {

    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var downloadStatusLabel: UILabel!
    
    var images: [String] = []
    
    var downloadCount: Int = 1
    
    let contentDownloader: JSONDownloader = JSONDownloader()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        backgroundView.layer.insertSublayer(WildlandsGradient.greenGradient(forBounds: view.bounds), atIndex: 0)
        
        contentDownloader.delegate = self
        startDownloading()
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Download functions
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
        downloadStatusLabel.text = NSLocalizedString("downloadChecksum", comment: "").uppercaseString
        
    }
    
    func downloadContent() {
        
        println("Downloaden pinpoints")
        contentDownloader.downloadJSON(DownloadType.DOWNLOAD_PINPOINTS)
        downloadStatusLabel.text = NSLocalizedString("downloadPinpoints", comment: "").uppercaseString
        
    }
    
    func downloadLevels() {
        
        println("Downloaden levels")
        contentDownloader.downloadJSON(DownloadType.DOWNLOAD_LEVELS)
        downloadStatusLabel.text = NSLocalizedString("downloadLevels", comment: "").uppercaseString
        
    }
    
    func downloadQuizQuestions() {
        
        println("Downloaden questions")
        contentDownloader.downloadJSON(DownloadType.DOWNLOAD_QUESTIONS)
        downloadStatusLabel.text = NSLocalizedString("downloadQuestions", comment: "").uppercaseString
        
    }
    
    func downloadPicture(atIndex index: Int) {
        
        println("Downloaden afbeelding \(index+1) van \(images.count)")
        downloadStatusLabel.text = NSLocalizedString("downloadPictures", comment: "").uppercaseString
        
        var currentIndex = index
        
        if images.count > 0 {
        
            let url = NSURL(string: images[index])
            SDWebImageDownloader.sharedDownloader().downloadImageWithURL(url, options: nil, progress: nil, completed: { (image: UIImage!, data: NSData!, error: NSError!, finished: Bool) in
        
                if finished {
                    
                    // Bij de laatste afbeelding, gebruiker door sturen naar startscherm
                    if currentIndex == (self.images.count - 1) {
                    
                        self.performSegueWithIdentifier("goToChooseDoelgroep", sender: self)
                        
                    } else {
                        
                        // Volgende afbeelding sturen
                        currentIndex += 1
                        self.downloadPicture(atIndex: currentIndex)
                        
                    }
                    
                }
                
            })
            
        }
        
    }

    // MARK: - JSON Downloader Delegate
    func JSONDownloaderFailed(message: String, type: DownloadType) {
        
        var image = Utils.fontAwesomeToImageWith(string: "\u{f00d}", andColor: UIColor.whiteColor())
        var alert = JSSAlertView().show(self, title : NSLocalizedString("failure", comment: "").uppercaseString, text : NSLocalizedString("downloadError", comment: ""), color : UIColorFromHex(0xc1272d, alpha: 1.0), buttonText: NSLocalizedString("again", comment: ""), cancelButtonText: NSLocalizedString("goForward", comment: ""), iconImage: image, delegate: self)
        
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
            
            
        } else if response is [Question] {
            
            let questionResponse = response as? [Question]
            Utils.saveObjectToDisk(questionResponse!, forKey: "questions")
            images = contentDownloader.imageURLs
            if images.count > 0 {
                downloadPicture(atIndex: 0)
            } else {
                self.performSegueWithIdentifier("goToChooseDoelgroep", sender: self)
            }
            
        } else {
            
            print("Onbekende response ontvangen")
            
        }
        
    }
    
    // MARK: - AlertView actions
    func JSSAlertViewButtonPressed() {
        downloadContent()
    }
    
    func JSSAlertViewCancelButtonPressed() {
        self.performSegueWithIdentifier("goToChooseDoelgroep", sender: self)
    }

}
