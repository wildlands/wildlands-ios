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
        
        // Disable iPhone auto lock, otherwise we lose our Socket.IO connection
        UIApplication.sharedApplication().idleTimerDisabled = true
        
        backgroundView.layer.insertSublayer(WildlandsGradient.grayGradient(forBounds: view.bounds), atIndex: 0)
        
        leerlingButton = WildlandsButton.createButtonWithImage(named: "default-button", forButton: leerlingButton)
        docentButton = WildlandsButton.createButtonWithImage(named: "default-button", forButton: docentButton)
        
        disableButtons()
        
        let delegate: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        socket = delegate.socket
        socket?.on("connect", callback: socketConnected)
        
        delegate.connectIfNotConnected()
        if delegate.isSocketConnected() {
            socketConnected(nil, ack: nil)
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Socket IO
    func disableButtons() {
        
        leerlingButton.enabled = false
        docentButton.enabled = false

    }
    
    func socketConnected(data: NSArray?, ack: AckEmitter?) {
        
        println("Socket is connected!");
        leerlingButton.enabled = true
        docentButton.enabled = true
        
    }

    // MARK: - Button actions
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
