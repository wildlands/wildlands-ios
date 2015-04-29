//
//  Fonts.swift
//  Wildlands
//
//  Created by Jan on 26-03-15.
//  Copyright (c) 2015 INF2A. All rights reserved.
//

import UIKit

class Fonts: NSObject {
 
    class func defaultFont(size: CGFloat) -> UIFont {
        return UIFont(name: "Roboto-Regular", size: size)!
    }
    
    class func wildlandsfont(size: CGFloat) -> UIFont {
        return UIFont(name: "wildlands-regular", size: size)!
    }
    
    class func speedletterFont(size: CGFloat) -> UIFont {
        return UIFont(name: "speedletter-regular", size: size)!
    }
    
}