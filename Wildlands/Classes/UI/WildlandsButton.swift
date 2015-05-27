//
//  WildlandsButton.swift
//  Wildlands
//
//  Created by Jan Doornbos on 18-05-15.
//  Copyright (c) 2015 INF2A. All rights reserved.
//

import UIKit

class WildlandsButton: NSObject {
    
    class func createButtonWithImage(#named: String, forButton button: UIButton) -> UIButton {
        
        let image: UIImage = UIImage(named: named)!.resizableImageWithCapInsets(UIEdgeInsetsMake(6, 6, 6, 6), resizingMode: UIImageResizingMode.Stretch)
        
        button.setBackgroundImage(image, forState: .Normal)
        button.layer.shadowColor = UIColor.blackColor().CGColor
        button.layer.shadowOffset = CGSizeMake(0, 0);
        button.layer.shadowOpacity = 1
        
        return button
        
    }
   
}
