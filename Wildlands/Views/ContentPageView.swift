//
//  ContentPage.swift
//  Wildlands
//
//  Created by Jan Doornbos on 22-04-15.
//  Copyright (c) 2015 INF2A. All rights reserved.
//

import UIKit

class ContentPageView: UIView {
    
    var theContent: ContentPage?
    
    init(content: ContentPage) {
    
        super.init(frame: CGRectNull)
        self.theContent = content
        placeContent()
        
    }
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
    }
    
    required init(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
        
    }
    
    func placeContent() {
        
        let imageView: UIImageView = UIImageView()
        imageView.setTranslatesAutoresizingMaskIntoConstraints(false)
        imageView.sd_setImageWithURL(NSURL(string: theContent!.image))
        self.addSubview(imageView)
        
        let scrollView: UIScrollView = UIScrollView()
        scrollView.setTranslatesAutoresizingMaskIntoConstraints(false)
        scrollView.bounces = true
        scrollView.showsVerticalScrollIndicator = true
        self.addSubview(scrollView)
        
        let label: UILabel = UILabel()
        label.text = theContent?.content
        label.textColor = Colors.fontColor
        label.setTranslatesAutoresizingMaskIntoConstraints(false)
        label.numberOfLines = 0
        label.font = Fonts.defaultFont
        label.textAlignment = NSTextAlignment.Justified
        scrollView.addSubview(label)
        
        let bindings = ["label" : label, "scrollView" : scrollView, "imageView" : imageView]
        
        var format = "H:|[imageView]|"
        var constraints = NSLayoutConstraint.constraintsWithVisualFormat(format, options: NSLayoutFormatOptions(0), metrics: nil, views: bindings)
        
        self.addConstraints(constraints)
        
        format = "V:|[imageView(200)]-10-[scrollView]-10-|"
        constraints = NSLayoutConstraint.constraintsWithVisualFormat(format, options: NSLayoutFormatOptions(0), metrics: nil, views: bindings)
        
        self.addConstraints(constraints)
        
        format = "H:|-10-[scrollView]-10-|"
        constraints = NSLayoutConstraint.constraintsWithVisualFormat(format, options: NSLayoutFormatOptions(0), metrics: nil, views: bindings)
        
        self.addConstraints(constraints)
        
        format = "H:|[label(==scrollView)]|"
        constraints = NSLayoutConstraint.constraintsWithVisualFormat(format, options: NSLayoutFormatOptions(0), metrics: nil, views: bindings)
        
        self.addConstraints(constraints)
        
        format = "V:|[label]|"
        constraints = NSLayoutConstraint.constraintsWithVisualFormat(format, options: NSLayoutFormatOptions(0), metrics: nil, views: bindings)
        
        self.addConstraints(constraints)
        
        
    }
   
}
