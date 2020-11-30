//
//  AppDelegate.swift
//  Torque
//
//  Created by Amanuel on 6/29/20.
//  Copyright © 2020 Amanuel. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        //starts communication with electric skateboard
        _ = ELCommunicationProtocol()
        //retrieves saved values
        let defaults = UserDefaults.standard
        if(!defaults.bool(forKey: "saved")){
            defaults.set(true,forKey: "saved")
            defaults.set("no", forKey: "darkmode")
            defaults.set("Placeholder", forKey: "name")
        }
        //updates values for synchronization accross app
        ELMetrics.darkMode.value = defaults.object(forKey: "darkmode") as! String
        ELMetrics.name.value = defaults.object(forKey: "name") as! String
        ELMetrics.didUpdate.value = "yes"
        
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
    
    func applicationWillTerminate(_ application: UIApplication) {
        let defaults = UserDefaults.standard
        defaults.set(ELMetrics.darkMode.value, forKey: "darkmode")
        defaults.set(ELMetrics.name.value, forKey: "name")
    }

}

