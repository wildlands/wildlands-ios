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

class PopupView: UIView {

    var delegate: PopUpViewDelegate?
    var thePinpoint: Pinpoint?
    var whiteBackground = UIView()
    
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
        
        let imageView: UIImageView = UIImageView()
        imageView.setTranslatesAutoresizingMaskIntoConstraints(false)
        //imageView.contentMode = UIViewContentMode.ScaleToFill
        //imageView.image = UIImage(named: "olifanten.jpg")
        imageView.sd_setImageWithURL(NSURL(string: thePinpoint!.photo))
        whiteBackground.addSubview(imageView)
        
        let scrollView: UIScrollView = UIScrollView()
        scrollView.setTranslatesAutoresizingMaskIntoConstraints(false)
        scrollView.bounces = true
        scrollView.showsVerticalScrollIndicator = true
        whiteBackground.addSubview(scrollView)
        
        let header: UIImageView = UIImageView(image: UIImage(named: thePinpoint!.typeName + "-header.png"))
        header.setTranslatesAutoresizingMaskIntoConstraints(false)
        header.contentMode = UIViewContentMode.ScaleAspectFit
        self.addSubview(header)
        
        let backButton: UIButton = UIButton()
        backButton.setTranslatesAutoresizingMaskIntoConstraints(false)
        backButton.setImage(UIImage(named: thePinpoint!.typeName + "-close.png"), forState: UIControlState.Normal)
        backButton.addTarget(self, action: Selector("goBackButton:"), forControlEvents: UIControlEvents.TouchUpInside)
        whiteBackground.addSubview(backButton)
        
        let label: UILabel = UILabel()
        label.text = thePinpoint!.pinDescription
        label.textColor = Colors.fontColor
        label.setTranslatesAutoresizingMaskIntoConstraints(false)
        label.numberOfLines = 0
        label.font = Fonts.defaultFont
        scrollView.addSubview(label)
        
        let bindings = ["label" : label, "header" : header, "whiteBackground" : whiteBackground, "backButton" : backButton, "scrollView" : scrollView, "imageView" : imageView]
        
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
        
        format = "H:|[imageView]|"
        constraints = NSLayoutConstraint.constraintsWithVisualFormat(format, options: NSLayoutFormatOptions(0), metrics: nil, views: bindings)
        
        whiteBackground.addConstraints(constraints)
        
        format = "V:|-50-[imageView(200)]-10-[scrollView]-10-|"
        constraints = NSLayoutConstraint.constraintsWithVisualFormat(format, options: NSLayoutFormatOptions(0), metrics: nil, views: bindings)
        
        whiteBackground.addConstraints(constraints)
        
        format = "H:[backButton(40)]-5-|"
        constraints = NSLayoutConstraint.constraintsWithVisualFormat(format, options: NSLayoutFormatOptions(0), metrics: nil, views: bindings)
        
        whiteBackground.addConstraints(constraints)
        
        format = "V:|-5-[backButton(40)]"
        constraints = NSLayoutConstraint.constraintsWithVisualFormat(format, options: NSLayoutFormatOptions(0), metrics: nil, views: bindings)
        
        whiteBackground.addConstraints(constraints)
        
        format = "H:|-10-[scrollView]-10-|"
        constraints = NSLayoutConstraint.constraintsWithVisualFormat(format, options: NSLayoutFormatOptions(0), metrics: nil, views: bindings)
        
        whiteBackground.addConstraints(constraints)
        
        format = "H:|[label(==scrollView)]|"
        constraints = NSLayoutConstraint.constraintsWithVisualFormat(format, options: NSLayoutFormatOptions(0), metrics: nil, views: bindings)
        
        scrollView.addConstraints(constraints)
        
        format = "V:|[label]|"
        constraints = NSLayoutConstraint.constraintsWithVisualFormat(format, options: NSLayoutFormatOptions(0), metrics: nil, views: bindings)
        
        scrollView.addConstraints(constraints)
        
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

}
