//
//  AppDelegate.swift
//  Todoey
//
//  Created by Vinicius Cechin on 22/10/19.
//  Copyright © 2019 Vinicius Cechin. All rights reserved.
//

import UIKit
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
//        print(Realm.Configuration.defaultConfiguration.fileURL)
        do {
            _ = try Realm()
        } catch {
            print("Error initializing realm, \(error)")
        }
        
        return true
    }
}

