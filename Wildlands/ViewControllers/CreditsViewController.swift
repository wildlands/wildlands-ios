//
//  CreditsViewController.swift
//  Wildlands
//
//  Created by Jan Doornbos on 22-05-15.
//  Copyright (c) 2015 INF2A. All rights reserved.
//

import UIKit

class CreditsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let tapRecognizer: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "goBack:")
        
        // Loop through all the views in this controller
        for view in self.view.subviews {
            
            // If the view is an UIImageView
            if view.isKindOfClass(UIImageView) {
                view.addGestureRecognizer(tapRecognizer)
            }
        }
        self.view.addGestureRecognizer(tapRecognizer)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Button functions
    
    /**
        Go back to the previous page (in this case StartViewController)
    
        :param: sender      The gesture that calls this action.
     */
    func goBack(sender: UITapGestureRecognizer) {
        
        self.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
}
