//
//  DownloadViewController.swift
//  Wildlands
//
//  Created by Jan Doornbos on 01-05-15.
//  Copyright (c) 2015 INF2A. All rights reserved.
//

import UIKit

class DownloadViewController: UIViewController, JSONDownloaderDelegate {

    @IBOutlet weak var backgroundView: UIView!
    
    let contentDownloader: JSONDownloader = JSONDownloader()
    var pinpoints: [Pinpoint] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        var gradient: CAGradientLayer = CAGradientLayer()
        gradient.frame = view.bounds
        gradient.colors = [UIColor(red: 45.0/255.0, green: 100.0/255.0, blue: 0.0/255.0, alpha: 1).CGColor, UIColor(red: 22.0/255.0, green: 45.0/255.0, blue: 26.0/255.0, alpha: 1).CGColor]
        backgroundView.layer.insertSublayer(gradient, atIndex: 0)
        
        contentDownloader.delegate = self
        
        let defaults: NSUserDefaults = NSUserDefaults.standardUserDefaults()
        if defaults.objectForKey("pinpoints") == nil {
            
            downloadContent()
            
        } else {
            
            checkDatabaseChecksum()
            
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func checkDatabaseChecksum() {
        
        contentDownloader.downloadJSON(DownloadType.DOWNLOAD_CHECKUM)
        
    }
    
    func downloadContent() {
        
        contentDownloader.downloadJSON(DownloadType.DOWNLOAD_PINPOINTS)
        
    }
    
    func JSONDownloaderFailed(message: String, type: DownloadType) {
        
        let failAlert: UIAlertView = UIAlertView(title: "Error", message: message, delegate: self, cancelButtonTitle: "Helaas")
        failAlert.show()
        
    }
    
    func JSONDownloaderSuccess(response: AnyObject) {
        
        if response is [Pinpoint] {
            
            let pinpointResponse = response as? [Pinpoint]
            pinpoints = pinpointResponse!
            Utils.saveObjectToDisk(pinpoints, forKey: "pinpoints")
            self.performSegueWithIdentifier("goToHome", sender: self)
            
        } else if response is Int {
            
            if response as! Int != NSUserDefaults.standardUserDefaults().objectForKey("checksum") as! Int {
                
                println("Nieuwe database!")
                NSUserDefaults.standardUserDefaults().setObject(response, forKey: "checksum")
                NSUserDefaults.standardUserDefaults().synchronize()
                downloadContent()
                
            } else {
                
                self.performSegueWithIdentifier("goToHome", sender: self)
                
            }
            
        } else {
            
            print("Onbekende response ontvangen")
            
        }
        
    }
    

}
