//
//  KaartViewController.swift
//  Wildlands
//
//  Created by Jan on 24-03-15.
//  Copyright (c) 2015 INF2A. All rights reserved.
//

import UIKit

class KaartViewController: UIViewController, UIScrollViewDelegate, JSONDownloaderDelegate, PopUpViewDelegate {

    @IBOutlet weak var kaartScrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    
    @IBOutlet weak var bottomView1: UIImageView!
    @IBOutlet weak var bottomView2: UIImageView!
    
    var pinpoints: [Pinpoint] = []
    var blackScreen: UIView = UIView()
    let contentDownloader: JSONDownloader = JSONDownloader()
    
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        
        contentDownloader.delegate = self
        
        kaartScrollView.contentSize = CGSizeMake(1000, 1000)
        
        kaartScrollView.minimumZoomScale = 1.0
        kaartScrollView.maximumZoomScale = 5.0
        
        blackScreen.backgroundColor = Colors.bruinTransparant
        blackScreen.frame = CGRectMake(0, 0, self.view.bounds.width, self.view.bounds.height)
        
        let defaults: NSUserDefaults = NSUserDefaults.standardUserDefaults()
        if defaults.objectForKey("pinpoints") == nil {
            
            downloadContent()
            
        } else {
            
            checkDatabaseChecksum()
            
        }
        
        bottomView2.alpha = 0;
        
    }
    
    func checkDatabaseChecksum() {
        
        contentDownloader.downloadJSON(DownloadType.DOWNLOAD_CHECKUM)
        startActivityIndicator()
        
    }
    
    func downloadContent() {

        contentDownloader.downloadJSON(DownloadType.DOWNLOAD_PINPOINTS)
        startActivityIndicator()
        
    }
    
    func startActivityIndicator() {
        
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
        activityIndicator.setTranslatesAutoresizingMaskIntoConstraints(false)
        self.view.addSubview(activityIndicator)
        
        activityIndicator.startAnimating()
        
        var binding = ["superview" : self.view, "activityIndicator" : activityIndicator]
        var format = "H:[superview]-(<=1)-[activityIndicator(20)]"
        var constraint = NSLayoutConstraint.constraintsWithVisualFormat(format, options: NSLayoutFormatOptions.AlignAllCenterY, metrics: nil, views: binding)
        
        self.view.addConstraints(constraint)
        
        format = "V:[superview]-(<=1)-[activityIndicator(20)]"
        constraint = NSLayoutConstraint.constraintsWithVisualFormat(format, options: NSLayoutFormatOptions.AlignAllCenterX, metrics: nil, views: binding)
        
        self.view.addConstraints(constraint)
        
    }
    
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        
        return contentView
    }
    
    func JSONDownloaderSuccess(response: AnyObject) {
        
        activityIndicator.stopAnimating()
        
        if response is [Pinpoint] {
            
            let pinpointResponse = response as? [Pinpoint]
            pinpoints = pinpointResponse!
            Utils.saveObjectToDisk(pinpoints, forKey: "pinpoints")
            addPinPoints()
            
        } else if response is Int {
        
            if (response as! Int != NSUserDefaults.standardUserDefaults().objectForKey("checksum") as! Int) {
                
                println("Nieuwe database!")
                NSUserDefaults.standardUserDefaults().setObject(response, forKey: "checksum")
                NSUserDefaults.standardUserDefaults().synchronize()
                downloadContent()
                
            } else {
                
                pinpoints = Utils.openObjectFromDisk("pinpoints") as! [Pinpoint]
                addPinPoints()
                
            }
            
        } else {
        
            print("Onbekende response ontvangen")
            
        }
        
    }
    
    func JSONDownloaderFailed(message: String, type: DownloadType) {
        
        activityIndicator.stopAnimating()
        
        if (type == DownloadType.DOWNLOAD_CHECKUM) {
            
            pinpoints = Utils.openObjectFromDisk("pinpoints") as! [Pinpoint]
            addPinPoints()
            
        }
        
        let failAlert: UIAlertView = UIAlertView(title: "Error", message: message, delegate: self, cancelButtonTitle: "Helaas")
        failAlert.show()
        
    }
    
    func addPinPoints() {
        
        pinpoints.sort({ $0.id < $1.id })
        
        var delay = 0.3
        
        for eenPinPoint: Pinpoint in pinpoints {
            
            let pinPointButton: UIButton = UIButton(frame: CGRectMake(eenPinPoint.xPos - 40, eenPinPoint.yPos - 108, 80, 108))
            pinPointButton.setImage(UIImage(named: eenPinPoint.image), forState: UIControlState.Normal)
            pinPointButton.tag = eenPinPoint.id
            pinPointButton.addTarget(self, action: Selector("pinPointPressed:"), forControlEvents: UIControlEvents.TouchUpInside)
            pinPointButton.alpha = 0
            kaartScrollView.addSubview(pinPointButton)
            
            UIView.animateWithDuration(0.5, delay: delay, options: nil, animations: {
            
                pinPointButton.alpha = 1
            
            }, completion: nil)
            
            delay += 0.3
            
        }
        
    }
    
    func scrollViewDidZoom(scrollView: UIScrollView) {
        
        for views in kaartScrollView.subviews as! [UIView] {
            
            if let button = views as? UIButton {
                
                let dePinPoint = pinpoints[button.tag]
                let zoomScale: CGFloat = kaartScrollView.zoomScale
                button.frame = CGRectMake(dePinPoint.xPos * zoomScale - 40, dePinPoint.yPos * zoomScale - 108, 80, 108)
                
            }
            
        }
        
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        
        if (scrollView.contentOffset.x > 500) {
            
            UIView.animateWithDuration(0.5, animations: {
            
                self.bottomView2.alpha = 1
                self.bottomView1.alpha = 0
            
            })
            
        } else {
            
            UIView.animateWithDuration(0.5, animations: {
                
                self.bottomView2.alpha = 0
                self.bottomView1.alpha = 1
                
            })
            
        }
        
    }
    
    func pinPointPressed(sender: UIButton!) {
        
        blackScreen.alpha = 0
        self.view.addSubview(blackScreen)
        
        UIView.animateWithDuration(0.3, animations: {
          
            self.blackScreen.alpha = 1
            
        })
        
        let popUp: PopupView = PopupView(aPinpoint: pinpoints[sender.tag])
        popUp.delegate = self
        popUp.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.001, 0.001)
        popUp.setTranslatesAutoresizingMaskIntoConstraints(false)
        self.view.addSubview(popUp)
        
        let bindings = ["popUp" : popUp]
        var format: String = "H:|-20-[popUp]-20-|"
        var constraints = NSLayoutConstraint.constraintsWithVisualFormat(format, options: NSLayoutFormatOptions(0), metrics: nil, views: bindings)
        
        self.view.addConstraints(constraints)
        
        format = "V:|-20-[popUp]-20-|"
        constraints = NSLayoutConstraint.constraintsWithVisualFormat(format, options: NSLayoutFormatOptions(0), metrics: nil, views: bindings)
        
        self.view.addConstraints(constraints)
        
        UIView.animateWithDuration(0.3/1.5, animations: {
        
            popUp.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.1, 1.1)
            
        }, completion: { (finished: Bool) in
            
            UIView.animateWithDuration(0.3/2, animations: {
                
                popUp.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.9, 0.9)
                
            }, completion: { (finshed: Bool) in
            
                UIView.animateWithDuration(0.3/2, animations: {
                
                    popUp.transform = CGAffineTransformIdentity
                
                })
            
            })
            
        })
        
    }
    
    func popUpDidDismiss() {
        
        blackScreen.removeFromSuperview()
        
    }
    
}
