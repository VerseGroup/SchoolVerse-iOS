//
//  SchoolVerseApp.swift
//  SchoolVerse
//
//  Created by Steven Yu on 8/31/22.
//

import SwiftUI
import FirebaseCore

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        // chooses firebase plist based on prod or dev
        let filePath = Bundle.main.path(forResource: CustomEnvironment.firebasePlist, ofType: "plist")
        guard let fileopts = FirebaseOptions(contentsOfFile: filePath!)
          else { assert(false, "Couldn't load config file") }
        FirebaseApp.configure(options: fileopts)
        return true
    }
}

@main
struct SchoolVerseApp: App {
    // register app delegate for Firebase setup
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
