//
//  LeylApp.swift
//  Leyl
//
//  Created by Abdelaziz Salah on 03/11/25.
//

import SwiftUI

@main
struct LeylApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    @State private var audioPlayerManager = AudioPlayerManager.shared
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .tint(Color(hex: "#ff0436"))
                .preferredColorScheme(.dark)
                .environment(audioPlayerManager)
        }
    }
}


final class AppDelegate: NSObject, UIApplicationDelegate {
    func applicationWillTerminate(_ application: UIApplication) {
        print("Application will Terminate")
//        AudioPlayerManager.shared.endAllLiveActivities()
    }
}
