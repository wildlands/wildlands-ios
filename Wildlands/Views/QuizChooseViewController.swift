//
//  QuizChooseViewController.swift
//  Wildlands
//
//  Created by Jan Doornbos on 29-04-15.
//  Copyright (c) 2015 INF2A. All rights reserved.
//

import UIKit
import Socket_IO_Client_Swift

class QuizChooseViewController: UIViewController {

    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var leerlingButton: UIButton!
    @IBOutlet weak var docentButton: UIButton!
    
    var socket: SocketIOClient?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        backgroundView.layer.insertSublayer(WildlandsGradient.grayGradient(forBounds: view.bounds), atIndex: 0)
        
        let button: UIImage = UIImage(named: "element-18")!.resizableImageWithCapInsets(UIEdgeInsetsMake(6, 6, 6, 6), resizingMode: UIImageResizingMode.Stretch)
        leerlingButton.setBackgroundImage(button, forState: UIControlState.Normal)
        leerlingButton.layer.shadowColor = UIColor.blackColor().CGColor
        leerlingButton.layer.shadowOffset = CGSizeMake(0, 0);
        leerlingButton.layer.shadowOpacity = 1
        
        docentButton.setBackgroundImage(button, forState: UIControlState.Normal)
        docentButton.layer.shadowColor = UIColor.blackColor().CGColor
        docentButton.layer.shadowOffset = CGSizeMake(0, 0);
        docentButton.layer.shadowOpacity = 1
        
        let delegate: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        socket = delegate.socket
        
        if !delegate.isSocketConnected() {
            
            socket?.connect()
            
        }
        
        socket?.on("connect", callback: socketConnected)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func checkIfConnected() {
        
        if let theSocket = socket {
            
            if !theSocket.connected {
                
                leerlingButton.enabled = false
                docentButton.enabled = false
                
            } else {
                
                leerlingButton.enabled = true
                docentButton.enabled = true
                
            }
            
        }
        
    }
    
    func socketConnected(data: NSArray?, ack: AckEmitter?) {
        
        println("Socket is connected!");
        
    }

    @IBAction func goBack(sender: AnyObject) {
        
        self.dismissViewControllerAnimated(true, completion: nil)
        
    }

    @IBAction func goToJoinQuiz(sender: AnyObject) {
        
        self.performSegueWithIdentifier("goToJoinQuiz", sender: self)
        
    }

    @IBAction func goToGenerateQuiz(sender: AnyObject) {
        
        self.performSegueWithIdentifier("goToGenerateQuiz", sender: self)
        
    }
}
