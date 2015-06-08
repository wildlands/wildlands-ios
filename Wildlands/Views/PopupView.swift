//
//  PopupView.swift
//  Wildlands
//
//  Created by Jan on 25-03-15.
//  Copyright (c) 2015 INF2A. All rights reserved.
//

import UIKit

protocol PopUpViewDelegate {
 
    /**
        When the user dissmisses the popUp, this message is send.
     */
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
    
    /**
        Add the content to the page
     */
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
        
        // Create the theme header on the popUp
        let header: UIImageView = UIImageView(image: UIImage(named: thePinpoint!.typeName.rawValue + "-header.png"))
        header.setTranslatesAutoresizingMaskIntoConstraints(false)
        header.contentMode = UIViewContentMode.ScaleAspectFit
        self.addSubview(header)
        
        // Create backbutton
        let backButton: UIButton = UIButton()
        backButton.setTranslatesAutoresizingMaskIntoConstraints(false)
        backButton.setImage(UIImage(named: thePinpoint!.typeName.rawValue + "-close.png"), forState: UIControlState.Normal)
        backButton.addTarget(self, action: Selector("goBackButton:"), forControlEvents: UIControlEvents.TouchUpInside)
        whiteBackground.addSubview(backButton)
        
        // Make scrollView for the pages
        pageScrollView.setTranslatesAutoresizingMaskIntoConstraints(false)
        pageScrollView.bounces = true
        pageScrollView.showsVerticalScrollIndicator = true
        pageScrollView.delegate = self
        pageScrollView.scrollEnabled = true
        pageScrollView.pagingEnabled = true
        whiteBackground.addSubview(pageScrollView)
        
        // Make dots for page indication
        pageControl.pageIndicatorTintColor = Colors.houtBruin
        pageControl.currentPageIndicatorTintColor = Colors.groen
        pageControl.setTranslatesAutoresizingMaskIntoConstraints(false)
        pageControl.addTarget(self, action: Selector("changePage"), forControlEvents: UIControlEvents.ValueChanged)
        whiteBackground.addSubview(pageControl)
        
        // Add constraints
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
    
    /**
        Add the pages with the content to the scrollView.
     */
    func addPagesToScrollView() {
        
        let currentLevel = Utils.openObjectFromDisk(forKey: "currentLevel") as! Level
        
        // Only show pages with the same level that is selected in the beginning from the App
        var paginas = thePinpoint!.pages.filter() { $0.level == currentLevel.id }
        
        // If there are pages
        if paginas.count > 0 {
        
            var pageBindings = [String : AnyObject]()
            pageBindings["pageScrollView"] = pageScrollView
            
            // Constraint string
            var horizontalFormat = "H:|"
            
            var index = 1
            // Loop through the pages
            for contentPage in paginas {
                
                // Make the page
                let page = ContentPageView(content: contentPage)
                page.setTranslatesAutoresizingMaskIntoConstraints(false)
                pageBindings["page\(index)"] = page
                pageScrollView.addSubview(page)
                
                var format = "V:|[page\(index)(==pageScrollView)]|"
                var constraint = NSLayoutConstraint.constraintsWithVisualFormat(format, options: NSLayoutFormatOptions(0), metrics: nil, views: pageBindings)
                pageScrollView.addConstraints(constraint)
                
                // Add this page to the horizontal constraint
                horizontalFormat = horizontalFormat + "[page\(index)(==pageScrollView)]"
                
                index++
                
            }
            
            // Set the pages dots
            pageControl.numberOfPages = paginas.count
            
            horizontalFormat = horizontalFormat + "|"
            
            var constraint = NSLayoutConstraint.constraintsWithVisualFormat(horizontalFormat, options: NSLayoutFormatOptions(0), metrics: nil, views: pageBindings)
            pageScrollView.addConstraints(constraint)
        
        }
    
    }
    
    /**
        Dismiss the popUp.

        :param: sender      The button who send the action.
     */
    func goBackButton(sender: UIButton!) {
        
        // Animate the popUp out of the view
        UIView.animateWithDuration(0.3/1.5, animations: {
            
            self.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.1, 1.1)
            
            }, completion: { (finished: Bool) in
                        
                UIView.animateWithDuration(0.3/2, animations: {
                            
                    self.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.001, 0.001)
                            
                    }, completion: { (finished: Bool) in
                        
                        // Send delegate message
                        self.delegate?.popUpDidDismiss()
                        // Completely remove the popUp from the view
                        self.removeFromSuperview()
                            
                    })
                
            })
        
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        
        // Change the dot who indicates the current page when the user scrolled the scrollView
        pageControl.currentPage = (Int(floor(scrollView.contentOffset.x)) / (Int(floor(scrollView.contentSize.width)) / thePinpoint!.pages.count))
        
    }
    
    /**
        Is called by the pageControl when the user clicks on the left or right side of the pageControl.
     */
    func changePage() {
    
        // Calculate the x position from the current page
        let page: CGFloat = CGFloat(pageControl.currentPage)
        let pageWidth: CGFloat = CGFloat(floor(pageScrollView.contentSize.width)) / CGFloat(thePinpoint!.pages.count)
        
        // Scroll to the page
        pageScrollView.scrollRectToVisible(CGRectMake(pageWidth * page, 0, pageWidth, pageScrollView.contentSize.height), animated: true)
    
    }

}
