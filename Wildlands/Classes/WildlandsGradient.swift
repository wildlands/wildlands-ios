//
//  WildlandsGradient.swift
//  Wildlands
//
//  Created by Jan Doornbos on 20-05-15.
//  Copyright (c) 2015 INF2A. All rights reserved.
//

import UIKit

class WildlandsGradient: NSObject {
    
    class func greenGradient(forBounds bounds: CGRect) -> CAGradientLayer {
        var gradient: CAGradientLayer = CAGradientLayer()
        gradient.frame = bounds
        gradient.colors = [UIColor(red: 45.0/255.0, green: 100.0/255.0, blue: 0.0/255.0, alpha: 1).CGColor, UIColor(red: 22.0/255.0, green: 45.0/255.0, blue: 26.0/255.0, alpha: 1).CGColor]
        return gradient
    }
    
    class func grayGradient(forBounds bounds: CGRect) -> CAGradientLayer {
        var gradient: CAGradientLayer = CAGradientLayer()
        gradient.frame = bounds
        gradient.colors = [UIColor(red: 153.0/255.0, green: 153/255.0, blue: 153.0/255.0, alpha: 1).CGColor, UIColor(red: 153.0/255.0, green: 153.0/255.0, blue: 153.0/255.0, alpha: 1).CGColor]
        return gradient
    }
    
    class func biomimicryColors() -> [CGColor] {
        return [UIColor(red: 174.0/255.0, green: 100.0/255.0, blue: 255.0/255.0, alpha: 1).CGColor, UIColor(red: 255.0/255.0, green: 144.0/255.0, blue: 255.0/255.0, alpha: 1).CGColor]
    }
    
    class func materiaalColors() -> [CGColor] {
        return [UIColor(red: 135.0/255.0, green: 114.0/255.0, blue: 46.0/255.0, alpha: 1).CGColor, UIColor(red: 202.0/255.0, green: 169.0/255.0, blue: 109.0/255.0, alpha: 1).CGColor]
    }
    
    class func energieColors() -> [CGColor] {
        return [UIColor(red: 255.0/255.0, green: 172.0/255.0, blue: 0.0/255.0, alpha: 1).CGColor, UIColor(red: 255.0/255.0, green: 225.0/255.0, blue: 2.0/255.0, alpha: 1).CGColor]
    }
    
    class func waterColors() -> [CGColor] {
        return [UIColor(red: 0.0/255.0, green: 92.0/255.0, blue: 255.0/255.0, alpha: 1).CGColor, UIColor(red: 0.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 1).CGColor]
    }
    
    class func dierenwelzijnColors() -> [CGColor] {
        return [UIColor(red: 237.0/255.0, green: 28.0/255.0, blue: 36.0/255.0, alpha: 1).CGColor, UIColor(red: 241.0/255.0, green: 90.0/255.0, blue: 36.0/255.0, alpha: 1).CGColor]
    }
   
}
