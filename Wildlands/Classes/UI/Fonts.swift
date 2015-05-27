//
//  Fonts.swift
//  Wildlands
//
//  Created by Jan on 26-03-15.
//  Copyright (c) 2015 INF2A. All rights reserved.
//

import UIKit

class Fonts: NSObject {
 
    /**
     * Default font for the app (Roboto Regular)
     *
     * @param size      The size for the font
     */
    class func defaultFont(size: CGFloat) -> UIFont {
        return UIFont(name: "Roboto-Regular", size: size)!
    }
    
    /**
    * Wildlands font (Wildlands Regular)
    *
    * @param size      The size for the font
    */
    class func wildlandsfont(size: CGFloat) -> UIFont {
        return UIFont(name: "wildlands-regular", size: size)!
    }
    
    /**
    * Speedletter font (Eckhardt Speedletter JNL Regular)
    *
    * @param size      The size for the font
    */
    class func speedletterFont(size: CGFloat) -> UIFont {
        return UIFont(name: "EckhardtSpeedletterJNL-Regular", size: size)!
    }
    
    /**
    * Font Awesome (Font Awesome)
    *
    * @param size      The size for the font
    */
    class func fontAwesomeFont(size: CGFloat) -> UIFont {
        return UIFont(name: "FontAwesome", size: size)!
    }
    
}