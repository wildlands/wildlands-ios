//
//  AnalogClockHandView.swift
//  AnalogClock
//
//  Created by Jan Doornbos on 10-05-15.
//  Copyright (c) 2015 Doornbos Agra-IT. All rights reserved.
//

import UIKit

class AnalogClockHandView: UIView {

    var color: UIColor?
    var width: CGFloat?
    var length: CGFloat?
    var offsetLength: CGFloat?
    var degree: CGFloat?
    var shadowEnabled: Bool?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clearColor()
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func drawRect(rect: CGRect) {
        
        var top: CGPoint = CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2 - self.length!)
        var bottom: CGPoint = CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2 + self.offsetLength!)
        
        var path: UIBezierPath = UIBezierPath()
        path.lineWidth = self.width!
        path.moveToPoint(bottom)
        path.addLineToPoint(top)
        self.color!.set()
        path.stroke()
        
        AnalogClockHandView.rotateHand(self, rotationDegree: self.degree!)
        
    }
    
    class func rotateHand(hand: UIView, rotationDegree: CGFloat) {
    
        UIView.animateWithDuration(NSTimeInterval(1.0), animations: { ()-> Void in
            
            var float: CGFloat = rotationDegree * CGFloat(M_PI / 180.0)
            
            hand.transform = CGAffineTransformMakeRotation(float)
            return
            
        })
    
    }
    
}
