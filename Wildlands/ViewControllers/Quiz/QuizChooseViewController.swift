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

    // MARK: Interface Builder
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var leerlingButton: UIButton!
    @IBOutlet weak var docentButton: UIButton!
    @IBOutlet weak var activitySpinner: UIActivityIndicatorView!
    
    var socket: SocketIOClient?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Disable iPhone auto lock, otherwise we lose our Socket.IO connection
        UIApplication.sharedApplication().idleTimerDisabled = true
        
        backgroundView.layer.insertSublayer(WildlandsGradient.grayGradient(forBounds: view.bounds), atIndex: 0)
        
        leerlingButton = WildlandsButton.createButtonWithImage(named: "default-button", forButton: leerlingButton)
        docentButton = WildlandsButton.createButtonWithImage(named: "default-button", forButton: docentButton)
        
        disableButtons()
        activitySpinner.startAnimating()
        
        let delegate: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        socket = delegate.socket
        socket?.on("connect", callback: socketConnected)
        socket?.on("error", callback: socketError)
        
        delegate.connectIfNotConnected()
        
        // If Socket is connected enable the buttons
        if delegate.isSocketConnected() {
            socketConnected(nil, ack: nil)
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Socket IO
    
    /**
        Disable the buttons, so if the user is not connected with the Socket, he 
        can't start or join a quiz.
     */
    func disableButtons() {
        
        leerlingButton.enabled = false
        docentButton.enabled = false

    }
    
    func socketConnected(data: NSArray?, ack: AckEmitter?) {
        
        println("Socket is connected!");
        leerlingButton.enabled = true
        docentButton.enabled = true
        activitySpinner.stopAnimating()
        
    }
    
    func socketError(data: NSArray?, ack: AckEmitter?) {
        
        var alert = JSSAlertView()
        let icon = Utils.fontAwesomeToImageWith(string: "\u{f127}", andColor: UIColor.whiteColor())
        alert.show(self, title: NSLocalizedString("error", comment: "").uppercaseString, text: NSLocalizedString("quizCantConnect", comment: ""), buttonText: NSLocalizedString("helaas", comment: ""), cancelButtonText: nil, color: UIColorFromHex(0xc1272d, alpha: 1), iconImage: icon, delegate: nil)
        
        activitySpinner.stopAnimating()
        
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
