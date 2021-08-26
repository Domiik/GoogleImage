//
//  AppDelegate.swift
//  GoogleImage
//
//  Created by Domiik on 23.08.2021.
//

import UIKit
import GoogleSignIn

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    let clientID = "344298861542-058q98mni79viuk9tsk4h8nr5enns19g.apps.googleusercontent.com"

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        GIDSignIn.sharedInstance()?.clientID = clientID
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

