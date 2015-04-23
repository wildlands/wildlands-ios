//
//  PopupView.swift
//  Wildlands
//
//  Created by Jan on 25-03-15.
//  Copyright (c) 2015 INF2A. All rights reserved.
//

import UIKit

protocol PopUpViewDelegate {
 
    func popUpDidDismiss()
    
}

class PopupView: UIView, UIScrollViewDelegate {

    var delegate: PopUpViewDelegate?
    var thePinpoint: Pinpoint?
    var whiteBackground = UIView()
    var pageScrollView: UIScrollView = UIScrollView()
    var pageControl: UIPageControl = UIPageControl()
    
    init(aPinpoint: Pinpoint) {
        
        super.init(frame: CGRectNull)
        self.thePinpoint = aPinpoint
        self.backgroundColor = UIColor.clearColor()
        addContent()
        
    }
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
    }

    required init(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
        
    }
    
    func addContent() {
        
        whiteBackground.backgroundColor = Colors.zand
        whiteBackground.layer.cornerRadius = 10.0
        whiteBackground.layer.masksToBounds = false
        
        whiteBackground.layer.shadowColor = UIColor.blackColor().CGColor
        whiteBackground.layer.shadowOpacity = 0.8
        whiteBackground.layer.shadowRadius = 3
        whiteBackground.layer.shadowOffset = CGSizeMake(0, 0)
        
        whiteBackground.setTranslatesAutoresizingMaskIntoConstraints(false)
        self.addSubview(whiteBackground)
        
        let header: UIImageView = UIImageView(image: UIImage(named: thePinpoint!.typeName + "-header.png"))
        header.setTranslatesAutoresizingMaskIntoConstraints(false)
        header.contentMode = UIViewContentMode.ScaleAspectFit
        self.addSubview(header)
        
        let backButton: UIButton = UIButton()
        backButton.setTranslatesAutoresizingMaskIntoConstraints(false)
        backButton.setImage(UIImage(named: thePinpoint!.typeName + "-close.png"), forState: UIControlState.Normal)
        backButton.addTarget(self, action: Selector("goBackButton:"), forControlEvents: UIControlEvents.TouchUpInside)
        whiteBackground.addSubview(backButton)
        
        pageScrollView.setTranslatesAutoresizingMaskIntoConstraints(false)
        pageScrollView.bounces = true
        pageScrollView.showsVerticalScrollIndicator = true
        pageScrollView.delegate = self
        pageScrollView.scrollEnabled = true
        pageScrollView.pagingEnabled = true
        whiteBackground.addSubview(pageScrollView)
        
        pageControl.pageIndicatorTintColor = Colors.houtBruin
        pageControl.currentPageIndicatorTintColor = Colors.groen
        pageControl.setTranslatesAutoresizingMaskIntoConstraints(false)
        whiteBackground.addSubview(pageControl)
        
        let bindings = ["header" : header, "whiteBackground" : whiteBackground, "backButton" : backButton, "pageScrollView" : pageScrollView, "pageControl" : pageControl]
        
        var format: String = "H:|-20-[header]-20-|"
        var constraints = NSLayoutConstraint.constraintsWithVisualFormat(format, options: NSLayoutFormatOptions(0), metrics: nil, views: bindings)
        
        self.addConstraints(constraints)
        
        format = "V:|[header(90)]"
        constraints = NSLayoutConstraint.constraintsWithVisualFormat(format, options: NSLayoutFormatOptions(0), metrics: nil, views: bindings)
        
        self.addConstraints(constraints)
        
        format = "V:|-40-[whiteBackground]-|"
        constraints = NSLayoutConstraint.constraintsWithVisualFormat(format, options: NSLayoutFormatOptions(0), metrics: nil, views: bindings)
        
        self.addConstraints(constraints)
        
        format = "H:|-[whiteBackground]-|"
        constraints = NSLayoutConstraint.constraintsWithVisualFormat(format, options: NSLayoutFormatOptions(0), metrics: nil, views: bindings)
        
        self.addConstraints(constraints)
        
        format = "H:[backButton(40)]-5-|"
        constraints = NSLayoutConstraint.constraintsWithVisualFormat(format, options: NSLayoutFormatOptions(0), metrics: nil, views: bindings)
        
        whiteBackground.addConstraints(constraints)
        
        format = "V:|-5-[backButton(40)]"
        constraints = NSLayoutConstraint.constraintsWithVisualFormat(format, options: NSLayoutFormatOptions(0), metrics: nil, views: bindings)
        
        whiteBackground.addConstraints(constraints)
        
        format = "H:|[pageScrollView]|"
        constraints = NSLayoutConstraint.constraintsWithVisualFormat(format, options: NSLayoutFormatOptions(0), metrics: nil, views: bindings)
        
        whiteBackground.addConstraints(constraints)
        
        format = "V:|-50-[pageScrollView][pageControl(15)]-|"
        constraints = NSLayoutConstraint.constraintsWithVisualFormat(format, options: NSLayoutFormatOptions(0), metrics: nil, views: bindings)
        
        whiteBackground.addConstraints(constraints)
        
        format = "H:|[pageControl]|"
        constraints = NSLayoutConstraint.constraintsWithVisualFormat(format, options: NSLayoutFormatOptions(0), metrics: nil, views: bindings)
        
        whiteBackground.addConstraints(constraints)
        
        addPagesToScrollView()
        
    }
    
    func addPagesToScrollView() {
        
        if thePinpoint!.pages.count > 0 {
        
            var pageBindings = [String : AnyObject]()
            pageBindings["pageScrollView"] = pageScrollView
            
            var horizontalFormat = "H:|"
            
            var index = 1
            for contentPage in thePinpoint!.pages {
                
                let page = ContentPageView(content: contentPage)
                page.setTranslatesAutoresizingMaskIntoConstraints(false)
                pageBindings["page\(index)"] = page
                pageScrollView.addSubview(page)
                
                var format = "V:|[page\(index)(==pageScrollView)]|"
                var constraint = NSLayoutConstraint.constraintsWithVisualFormat(format, options: NSLayoutFormatOptions(0), metrics: nil, views: pageBindings)
                pageScrollView.addConstraints(constraint)
                
                horizontalFormat = horizontalFormat + "[page\(index)(==pageScrollView)]"
                
                index++
                
            }
            
            pageControl.numberOfPages = thePinpoint!.pages.count
            
            horizontalFormat = horizontalFormat + "|"
            
            var constraint = NSLayoutConstraint.constraintsWithVisualFormat(horizontalFormat, options: NSLayoutFormatOptions(0), metrics: nil, views: pageBindings)
            pageScrollView.addConstraints(constraint)
        
        }
    
    }
    
    func goBackButton(sender: UIButton!) {
        
        UIView.animateWithDuration(0.3/1.5, animations: {
            
            self.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.1, 1.1)
            
            }, completion: { (finished: Bool) in
                        
                UIView.animateWithDuration(0.3/2, animations: {
                            
                    self.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.001, 0.001)
                            
                    }, completion: { (finished: Bool) in
                        
                        self.delegate?.popUpDidDismiss()
                        self.removeFromSuperview()
                            
                    })
                
            })
        
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        
        pageControl.currentPage = (Int(floor(scrollView.contentOffset.x)) / (Int(floor(scrollView.contentSize.width)) / thePinpoint!.pages.count))
        
    }

}
