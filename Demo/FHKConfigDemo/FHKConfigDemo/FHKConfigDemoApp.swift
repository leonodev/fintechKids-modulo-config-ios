//
//  FHKConfigDemoApp.swift
//  FHKConfigDemo
//
//  Created by Fredy Leon on 9/12/25.
//

import SwiftUI
import FirebaseCore
import FHKInjections
import FHKConfig

public extension DependenciesInjection {
    var configManager: any FHKConfigManagerProtocol {
        get { self[(any FHKConfigManagerProtocol).self] }
        set { self[(any FHKConfigManagerProtocol).self] = newValue }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()
      
    let deps = DependenciesInjection.shared
      
    /// Configuration
    deps.set(RemoteConfigManager(), for: (any FHKConfigManagerProtocol).self)

    return true
  }
}

@main
struct FHKConfigDemoApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
