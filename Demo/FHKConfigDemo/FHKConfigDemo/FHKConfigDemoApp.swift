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
import FHKDomain

public extension DependenciesInjection {
    var configManager: any FHKRemoteConfigManagerProtocol {
        get { self[(any FHKRemoteConfigManagerProtocol).self] }
        set { self[(any FHKRemoteConfigManagerProtocol).self] = newValue }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()
      
    let deps = DependenciesInjection.shared
      
    /// Configuration
    deps.set(FHKRemoteConfigManager(), for: (any FHKRemoteConfigManagerProtocol).self)

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
