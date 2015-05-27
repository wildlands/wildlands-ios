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
        for view in self.view.subviews {
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
    func goBack(sender: UITapGestureRecognizer) {
        
        self.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
}
