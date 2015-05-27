//
//  AppDelegate.swift
//  Wildlands
//
//  Created by Jan on 18-03-15.
//  Copyright (c) 2015 INF2A. All rights reserved.
//

import UIKit
import Socket_IO_Client_Swift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let socket = SocketIOClient(socketURL: "doornbosagrait.tk:2345", options: nil)

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        if (NSUserDefaults.standardUserDefaults().objectForKey("checksum") == nil) {
            
            NSUserDefaults.standardUserDefaults().setObject(0, forKey: "checksum")
            NSUserDefaults.standardUserDefaults().synchronize()
            
        }
        
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
        if socket.connected {
            showSocketMelding()
        }
        socket.disconnect(fast: true)
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        socket.disconnect(fast: false)
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        socket.disconnect(fast: false)
        
    }

    func connectSocket() {
        
        socket.connect()
        
    }
    
    func isSocketConnected() -> Bool {
        
        return socket.connected
        
    }
    
    func connectIfNotConnected() {
        
        if !socket.connected {
            socket.connect()
        }
        
    }
    
    func showSocketMelding() {
        
        if let current = self.window?.rootViewController?.navigationController?.visibleViewController {
            
            var image: UIImage = Utils.fontAwesomeToImageWith(string: "\u{f1e6}", andColor: UIColor.whiteColor())
            JSSAlertView().show(current, title: "VERBINDING VERBROKEN", text: "Als je een nieuwe quiz wil starten of joinen zul je de App opnieuw moeten opstarten.", buttonText: "Oke", cancelButtonText: "Annuleer", color: UIColorFromHex(0xc1272d, alpha: 1), iconImage: image, delegate: nil)
            
        }
        
    }

}