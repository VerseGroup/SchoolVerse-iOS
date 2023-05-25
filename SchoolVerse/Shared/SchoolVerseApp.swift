//
//  SchoolVerseApp.swift
//  SchoolVerse
//
//  Created by Steven Yu on 8/31/22.
//

import SwiftUI
import FirebaseCore
import FirebaseAuth

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        // chooses firebase plist based on prod or dev
        let filePath = Bundle.main.path(forResource: CustomEnvironment.firebasePlist, ofType: "plist")
        guard let fileopts = FirebaseOptions(contentsOfFile: filePath!)
          else {
            assert(false, "Couldn't load config file")
            fatalError("Couldn't load config file")
        }
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
            RouterView()
                .onAppear {
                    // fixes delete/reinstall app and still being signed into FB
                    // source: https://stackoverflow.com/questions/40733262/log-user-out-after-app-has-been-uninstalled-firebase
                    if (!UserDefaults.standard.bool(forKey: "hasRunBefore")) {
                        print("The app is launching for the first time. Setting UserDefaults...")

                        do {
                            try Auth.auth().signOut()
                        } catch {

                        }

                        // Update the flag indicator
                        UserDefaults.standard.set(true, forKey: "hasRunBefore")
                        UserDefaults.standard.synchronize() // This forces the app to update userDefaults
                        
                    }
                }
        }
    }
}
