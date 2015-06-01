//
//  KaartViewController.swift
//  Wildlands
//
//  Created by Jan on 24-03-15.
//  Copyright (c) 2015 INF2A. All rights reserved.
//

import UIKit

class KaartViewController: UIViewController, UIScrollViewDelegate, PopUpViewDelegate, WildlandsGPSDelegate {

    @IBOutlet weak var kaartScrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    
    var pinpoints: [Pinpoint] = []
    var blackScreen: UIView = UIView()
    var currentPosition: UIImageView = UIImageView()
    var wildlandsGPS: WildlandsGPS = WildlandsGPS()
    
    var currentType: WildlandsTheme?
    
    var currentX: Int = 0
    var currentY: Int = 0
    
    var popupOpen: Bool = false
    var lastPinpoint: Int = 0
    
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
        
        pinpoints = Utils.openObjectFromDisk(forKey: "pinpoints") as! [Pinpoint]
        addPinPoints()
        
    }
    
    // MARK: - ScrollView
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        
        return contentView
    }
    
    func scrollViewDidZoom(scrollView: UIScrollView) {
        
        let zoomScale: CGFloat = kaartScrollView.zoomScale
        
        for views in kaartScrollView.subviews as! [UIView] {
            
            if let button = views as? UIButton {
                
                let dePinPoint = pinpoints[button.tag]
                button.frame = CGRectMake(dePinPoint.xPos * zoomScale - 40, dePinPoint.yPos * zoomScale - 108, 80, 108)
                pinpoints[button.tag].trigger = CGRectMake(dePinPoint.xPos * zoomScale - 80, dePinPoint.yPos * zoomScale - 80, 160, 160)
                
            }
            
            if let position = views as? UIImageView {
                
                position.frame = CGRectMake(CGFloat(currentX) * zoomScale - 12.5, CGFloat(currentY) * zoomScale - 12.5, 25, 25)
                
            }
            
        }
        
    }
    
    // MARK: - Pinpoints
    func addPinPoints() {
        
        let zoomScale: CGFloat = kaartScrollView.zoomScale
        
        pinpoints.sort({ $0.id < $1.id })
        
        var delay = 0.3
        
        var i = 0
        for eenPinPoint: Pinpoint in pinpoints {
            
            if eenPinPoint.typeName.rawValue == currentType?.description {
                
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
                
            }
            
            i++
            
        }
        
    }
    
    func pinPointPressed(sender: UIButton!) {
        
        openPinpointWithID(sender.tag)
        
    }
    
    func openPinpointWithID(id: Int) {
        
        popupOpen = true
        lastPinpoint = id
        
        blackScreen.alpha = 0
        self.view.addSubview(blackScreen)
        
        UIView.animateWithDuration(0.3, animations: {
            
            self.blackScreen.alpha = 1
            
        })
        
        let popUp: PopupView = PopupView(aPinpoint: pinpoints[id])
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
    
    // MARK: - Popup Delegate
    func popUpDidDismiss() {
        
        blackScreen.removeFromSuperview()
        popupOpen = false
        
    }
    
    // MARK: - GPS
    func didReceiveNewCoordinates(x: Int, y: Int) {
        
        let zoomScale: CGFloat = kaartScrollView.zoomScale
        
        UIView.animateWithDuration(0.5, animations: {
        
            self.currentPosition.frame = CGRectMake((CGFloat(x) * zoomScale) - 12.5, (CGFloat(y) * zoomScale) - 12.5, 25, 25)
        
        });
        
        currentX = x
        currentY = y
        
        let coordinate: CGPoint = CGPointMake(CGFloat(x), CGFloat(y))
        
        var i = 0
        for eenPinpoint: Pinpoint in pinpoints {
            
            if CGRectContainsPoint(eenPinpoint.trigger, coordinate) {
                
                if !popupOpen && i != lastPinpoint {
                
                    openPinpointWithID(i)
                
                }
                
                break
                
            }
            i++
            
        }
        
    }
    
    // MARK: - Button functions
    @IBAction func goBack(sender: AnyObject) {
        
        self.navigationController?.popViewControllerAnimated(true)
        
    }
}
