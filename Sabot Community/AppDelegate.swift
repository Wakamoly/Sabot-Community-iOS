//
//  AppDelegate.swift
//  Sabot Community
//
//  Created by Wakamoly on 7/12/20.
//  Copyright © 2020 LucidSoftworksLLC. All rights reserved.
//

import UIKit
import PopupDialog

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        // Uncomment for a dark theme demo
        //        // Customize dialog appearance
                let pv = PopupDialogDefaultView.appearance()
                pv.titleFont    = UIFont(name: "HelveticaNeue-Light", size: 16)!
                pv.titleColor   = .white
                pv.messageFont  = UIFont(name: "HelveticaNeue", size: 14)!
                pv.messageColor = UIColor(white: 0.8, alpha: 1)
        
                // Customize the container view appearance
                let pcv = PopupDialogContainerView.appearance()
                pcv.backgroundColor = UIColor(red:0.23, green:0.23, blue:0.27, alpha:1.00)
                pcv.cornerRadius    = 2
                pcv.shadowEnabled   = true
                pcv.shadowColor     = .black
                pcv.shadowOpacity   = 0.6
                pcv.shadowRadius    = 20
                pcv.shadowOffset    = CGSize(width: 0, height: 8)
        
                // Customize overlay appearance
                let ov = PopupDialogOverlayView.appearance()
                ov.blurEnabled     = true
                ov.blurRadius      = 30
                ov.liveBlurEnabled = true
                ov.opacity         = 0.7
                ov.color           = .black
        
                // Customize default button appearance
                let db = DefaultButton.appearance()
                db.titleFont      = UIFont(name: "HelveticaNeue-Medium", size: 14)!
                db.titleColor     = .white
                db.buttonColor    = UIColor(red:0.25, green:0.25, blue:0.29, alpha:1.00)
                db.separatorColor = UIColor(red:0.20, green:0.20, blue:0.25, alpha:1.00)
        
                // Customize cancel button appearance
                let cb = CancelButton.appearance()
                cb.titleFont      = UIFont(name: "HelveticaNeue-Medium", size: 14)!
                cb.titleColor     = UIColor(white: 0.6, alpha: 1)
                cb.buttonColor    = UIColor(red:0.25, green:0.25, blue:0.29, alpha:1.00)
                cb.separatorColor = UIColor(red:0.20, green:0.20, blue:0.25, alpha:1.00)
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

