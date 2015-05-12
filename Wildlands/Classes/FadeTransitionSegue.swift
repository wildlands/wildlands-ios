//
//  FadeTransitionSegue.swift
//  Wildlands
//
//  Created by Jan Doornbos on 29-04-15.
//  Copyright (c) 2015 INF2A. All rights reserved.
//

import UIKit

class FadeTransitionSegue: UIStoryboardSegue {
    
    override func perform() {
        
        let transition: CATransition = CATransition()
        
        transition.duration = 0.5;
        transition.type = kCATransitionFade;
        
        let source = sourceViewController as! UIViewController
        if let navigation = source.navigationController {
            navigation.view.layer.addAnimation(transition, forKey: kCATransition)
            navigation.pushViewController(self.destinationViewController as! UIViewController, animated: false)
        }
        
    }
   
}
