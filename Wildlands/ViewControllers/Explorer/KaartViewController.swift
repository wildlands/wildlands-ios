//
//  KaartViewController.swift
//  Wildlands
//
//  Created by Jan on 24-03-15.
//  Copyright (c) 2015 INF2A. All rights reserved.
//

import UIKit
import SDWebImage

class KaartViewController: UIViewController, UIScrollViewDelegate, PopUpViewDelegate, WildlandsGPSDelegate {

    // MARK: Interface Builder
    @IBOutlet weak var kaartScrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    
    // MARK: Properties
    var pinpoints: [Pinpoint] = []
    var blackScreen: UIView = UIView()
    var currentPosition: UIImageView = UIImageView()
    var wildlandsGPS: WildlandsGPS = WildlandsGPS()
    
    var currentType: WildlandsTheme?
    
    var currentX: Int = 0
    var currentY: Int = 0
    
    var popupOpen: Bool = false
    var lastPinpoint: Int = 0
    
    var layerView: UIImageView = UIImageView()
    
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        
        wildlandsGPS.delegate = self
        
        kaartScrollView.contentSize = CGSizeMake(2500, 2392)
        
        kaartScrollView.minimumZoomScale = 0.5
        kaartScrollView.maximumZoomScale = 5.0
        kaartScrollView.setZoomScale(0.5, animated: false)
        
        blackScreen.backgroundColor = Colors.bruinTransparant
        blackScreen.frame = CGRectMake(0, 0, self.view.bounds.width, self.view.bounds.height)
        
        currentPosition.image = UIImage(named: "spot.png")
        currentPosition.frame = CGRectMake(0, 0, 25, 25)
        kaartScrollView.addSubview(currentPosition)
        
        addThemeLayer()
        
        // Check if Pinpoints are available from disk
        if let pins = Utils.openObjectFromDisk(forKey: "pinpoints") as? [Pinpoint] {
            
            // We found pinpoints, lets place them on the map
            pinpoints = pins
            addPinPoints()
            
        } else {
            
            // No Pinpoints found, show alert
            var alert = JSSAlertView()
            let icon = Utils.fontAwesomeToImageWith(string: "\u{f00d}", andColor: UIColor.whiteColor())
            alert.show(self, title: NSLocalizedString("error", comment: "").uppercaseString, text: NSLocalizedString("explorerNoPinpoints", comment: ""), buttonText: NSLocalizedString("oke", comment: ""), cancelButtonText: nil, color: UIColorFromHex(0xc1272d, alpha: 1), iconImage: icon, delegate: nil)
            
        }
        
    }
    
    // MARK: - Theme
    
    /**
        Add the theme layer to the map.
     */
    func addThemeLayer() {
        
        let zoomScale: CGFloat = kaartScrollView.zoomScale
        
        // Unwrap the layer image URL
        if let layerString = Utils.openObjectFromDisk(forKey: currentType!.rawValue) as? String {
            
            var image: UIImage = UIImage()
            layerView = UIImageView(frame: CGRectMake(0, 0, kaartScrollView.contentSize.width / zoomScale, kaartScrollView.contentSize.height / zoomScale))
            layerView.alpha = 0
            
            // Select layer depending on theme
            layerView.sd_setImageWithURL(NSURL(string: layerString), completed: { (image: UIImage!, error: NSError!, cacheType: SDImageCacheType, imageURL: NSURL!) -> Void in
            
                // Fade in the layer
                UIView.animateWithDuration(0.5, animations: {
                
                    self.layerView.alpha = 1
                
                })
                
            })
            
            layerView.clipsToBounds = true
            // Add layer to the map
            contentView.addSubview(layerView)
            
        }
        
    }
    
    // MARK: - ScrollView
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        
        return contentView
    }
    
    func scrollViewDidZoom(scrollView: UIScrollView) {
        
        let zoomScale: CGFloat = kaartScrollView.zoomScale
        
        for views in kaartScrollView.subviews as! [UIView] {
            
            // Keep the pinpoints on the right position
            if let button = views as? UIButton {
                
                let dePinPoint = pinpoints[button.tag]
                button.frame = CGRectMake(dePinPoint.xPos * zoomScale - 40, dePinPoint.yPos * zoomScale - 108, 80, 108)
                pinpoints[button.tag].trigger = CGRectMake(dePinPoint.xPos * zoomScale - 80, dePinPoint.yPos * zoomScale - 80, 160, 160)
                
            }
            
            // Keep the GPS position on the right place
            if let position = views as? UIImageView {
                
                if position == currentPosition {
                
                    position.frame = CGRectMake(CGFloat(currentX) * zoomScale - 12.5, CGFloat(currentY) * zoomScale - 12.5, 25, 25)
                    
                }
                
            }
            
        }
        
    }
    
    // MARK: - Pinpoints
    
    /**
        Add the Pinpoints to the map
     */
    func addPinPoints() {
        
        let zoomScale: CGFloat = kaartScrollView.zoomScale
        
        pinpoints.sort({ $0.id < $1.id })
        pinpoints = pinpoints.filter() { $0.typeName.rawValue == self.currentType?.rawValue }
        
        var delay = 0.3
        
        var i = 0
        for eenPinPoint: Pinpoint in pinpoints {
            
            let pinPointButton: UIButton = UIButton(frame: CGRectMake(eenPinPoint.xPos * zoomScale - 40, eenPinPoint.yPos * zoomScale - 108, 80, 108))
            var pinImage = "\(eenPinPoint.typeName.rawValue)-pin"
            pinPointButton.setImage(UIImage(named: pinImage), forState: UIControlState.Normal)
            pinPointButton.tag = eenPinPoint.id
            pinPointButton.addTarget(self, action: Selector("pinPointPressed:"), forControlEvents: UIControlEvents.TouchUpInside)
            pinPointButton.alpha = 0
            kaartScrollView.addSubview(pinPointButton)
            
            pinpoints[i].trigger = CGRectMake(eenPinPoint.xPos * zoomScale - 80, eenPinPoint.yPos * zoomScale - 80, 160, 160)
            
            UIView.animateWithDuration(0.5, delay: delay, options: nil, animations: {
                
                pinPointButton.alpha = 1
                
                }, completion: nil)
            
            delay += 0.3
            
            i++
            
        }
        
    }
    
    /**
        Action when a Pinpoint is pressed
    
        :param: sender          The button who sends the action
     */
    func pinPointPressed(sender: UIButton!) {
        
        openPinpointWithID(sender.tag)
        
    }
    
    /**
        Open a popup with content from a Pinpoint with an ID.

        :param: id              The ID from the Pinpoint
     */
    func openPinpointWithID(id: Int) {
        
        popupOpen = true
        lastPinpoint = id
        
        blackScreen.alpha = 0
        self.view.addSubview(blackScreen)
        
        UIView.animateWithDuration(0.3, animations: {
            
            self.blackScreen.alpha = 1
            
        })
        
        // Create the popUp
        let popUp: PopupView = PopupView(aPinpoint: pinpoints.filter { $0.id == id }.first! )
        popUp.delegate = self
        popUp.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.001, 0.001)
        popUp.setTranslatesAutoresizingMaskIntoConstraints(false)
        self.view.addSubview(popUp)
        
        // Add the constraints to the popUp
        let bindings = ["popUp" : popUp]
        var format: String = "H:|-20-[popUp]-20-|"
        var constraints = NSLayoutConstraint.constraintsWithVisualFormat(format, options: NSLayoutFormatOptions(0), metrics: nil, views: bindings)
        
        self.view.addConstraints(constraints)
        
        format = "V:|-20-[popUp]-20-|"
        constraints = NSLayoutConstraint.constraintsWithVisualFormat(format, options: NSLayoutFormatOptions(0), metrics: nil, views: bindings)
        
        self.view.addConstraints(constraints)
        
        // Animate the popUp into the screen
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
    
    // MARK: - Popup Delegate
    
    func popUpDidDismiss() {
        
        blackScreen.removeFromSuperview()
        popupOpen = false
        
    }
    
    // MARK: - GPS
    
    /**
        Is called from the WildlandsGPSDelegate.
        See WildlandsGPS.swift
    */
    func didReceiveNewCoordinates(x: Int, y: Int) {
        
        let zoomScale: CGFloat = kaartScrollView.zoomScale
        
        // Animate the spot to the new location
        UIView.animateWithDuration(0.5, animations: {
        
            self.currentPosition.frame = CGRectMake((CGFloat(x) * zoomScale) - 12.5, (CGFloat(y) * zoomScale) - 12.5, 25, 25)
        
        });
        
        // Save the coordinates
        currentX = x
        currentY = y
        
        let coordinate: CGPoint = CGPointMake(CGFloat(x), CGFloat(y))
        
        var i = 0
        // Check if the current position on the map is in a trigger area from a Pinpoint
        for eenPinpoint: Pinpoint in pinpoints {
            
            // Current position is in Pinpoint area, so open the popUp
            if CGRectContainsPoint(eenPinpoint.trigger, coordinate) {
                
                // Only open popUp if non is opened
                if !popupOpen && i != lastPinpoint {
                
                    openPinpointWithID(i)
                
                }
                
                break
                
            }
            i++
            
        }
        
    }
    
    // MARK: - Button functions
    
    /**
        Go back to previous ViewController (in this case: ChooseSubjectViewController).
    
        :param: sender          The object that send the request
     */
    @IBAction func goBack(sender: AnyObject) {
        
        self.navigationController?.popViewControllerAnimated(true)
        
    }
}
