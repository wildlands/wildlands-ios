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
    
    /**
        Start downloading from the content.
     */
    func startDownloading() {
        
        let defaults: NSUserDefaults = NSUserDefaults.standardUserDefaults()
        
        // No pinpoints found so start downloading content
        if defaults.objectForKey("pinpoints") == nil {
            
            downloadContent()
            
        // Pinpoints found, so check for a new online database
        } else {
            
            checkDatabaseChecksum()
            
        }
        
    }
    
    /**
        Start downloading the online database checksum.
     */
    func checkDatabaseChecksum() {
        
        println("Downloaden checksum")
        contentDownloader.downloadJSON(DownloadType.DOWNLOAD_CHECKUM)
        downloadStatusLabel.text = NSLocalizedString("downloadChecksum", comment: "").uppercaseString
        
    }
    
    /**
        Start downloading the pinpoints from the online database.
     */
    func downloadContent() {
        
        println("Downloaden pinpoints")
        contentDownloader.downloadJSON(DownloadType.DOWNLOAD_PINPOINTS)
        downloadStatusLabel.text = NSLocalizedString("downloadPinpoints", comment: "").uppercaseString
        
    }
    
    /**
        Start downloading the levels from the online database.
     */
    func downloadLevels() {
        
        println("Downloaden levels")
        contentDownloader.downloadJSON(DownloadType.DOWNLOAD_LEVELS)
        downloadStatusLabel.text = NSLocalizedString("downloadLevels", comment: "").uppercaseString
        
    }
    
    /**
        Start downloading the quiz questions from the online database.
     */
    func downloadQuizQuestions() {
        
        println("Downloaden questions")
        contentDownloader.downloadJSON(DownloadType.DOWNLOAD_QUESTIONS)
        downloadStatusLabel.text = NSLocalizedString("downloadQuestions", comment: "").uppercaseString
        
    }
    
    /**
        Start downloading the map layers from the online database.
     */
    func downloadLayers() {
        
        println("Downloaden layers")
        contentDownloader.downloadJSON(DownloadType.DOWNLOAD_LAYERS)
        downloadStatusLabel.text = NSLocalizedString("downloadLayers", comment: "").uppercaseString
        
    }
    
    /**
        Start downloading all the picture from the database.
     */
    func downloadPicture(atIndex index: Int) {
        
        println("Downloaden afbeelding \(index+1) van \(images.count)")
        downloadStatusLabel.text = NSLocalizedString("downloadPictures", comment: "").uppercaseString + "\n(\(index+1)/\(images.count))"
        
        var currentIndex = index
        
        // Check if there are images available for download
        if images.count > 0 {
        
            let url = NSURL(string: images[index])
            
            // Download the image
            SDWebImageDownloader.sharedDownloader().downloadImageWithURL(url, options: nil, progress: nil, completed: { (image: UIImage!, data: NSData!, error: NSError!, finished: Bool) in
        
                if finished {
                    
                    // If last image is downloaded, send user to next screen
                    // (In this case ChooseDielgroepViewController)
                    if currentIndex == (self.images.count - 1) {
                    
                        self.performSegueWithIdentifier("goToChooseDoelgroep", sender: self)
                        
                    } else {
                        
                        // Download the next i,age
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
        
        // If response are Pinpoints
        if response is [Pinpoint] {
            
            let pinpointResponse = response as? [Pinpoint]
            Utils.saveObjectToDisk(pinpointResponse!, forKey: "pinpoints")
            // Start downloading levels
            downloadLevels()
            
        // If response is the online database checksum
        } else if response is ChecksumResponse {
            
            if let theResponse = response as? ChecksumResponse {
                
                if theResponse.checksum != NSUserDefaults.standardUserDefaults().objectForKey("checksum") as! Int {
                    
                    println("Nieuwe database!")
                    NSUserDefaults.standardUserDefaults().setObject(theResponse.checksum, forKey: "checksum")
                    NSUserDefaults.standardUserDefaults().synchronize()
                    downloadContent()
                    
                // There is no new database, so go to next screen
                // (In this case ChooseDoelgroepViewController)
                } else {
                    
                    self.performSegueWithIdentifier("goToChooseDoelgroep", sender: self)
                    
                }
                
            }
        
        // If the response are the levels
        } else if response is [Level] {
            
            let levelResponse = response as? [Level]
            Utils.saveObjectToDisk(levelResponse!, forKey: "levels")
            // Start downloading the quiz questions
            downloadQuizQuestions()
            
        // If the response are the quiz questions
        } else if response is [Question] {
            
            let questionResponse = response as? [Question]
            Utils.saveObjectToDisk(questionResponse!, forKey: "questions")
            // Start downloading the layers
            downloadLayers()
            
        // If the response are the map layers
        } else if response is LayerResponse {
            
            // Get the image from the JSONDownloader
            images = Array(Set(contentDownloader.imageURLs))
            
            // If there are any images available for download
            if images.count > 0 {
                // Start downloading the images
                downloadPicture(atIndex: 0)
            } else {
                // Go the next screen (in this case ChooseDoelgroepViewController)
                self.performSegueWithIdentifier("goToChooseDoelgroep", sender: self)
            }
            
        } else {
            
            print("Onbekende response ontvangen")
            
        }
        
    }
    
    // MARK: - AlertView actions
    func JSSAlertViewButtonPressed(forAlert: JSSAlertView) {
        downloadContent()
    }
    
    func JSSAlertViewCancelButtonPressed(forAlert: JSSAlertView) {
        
        // Go to the next screen (in this case ChooseDoelgroepViewController)
        self.performSegueWithIdentifier("goToChooseDoelgroep", sender: self)
    }

}
