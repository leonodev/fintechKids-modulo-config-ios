//
//  FHKRemoteConfig.swift
//  FHKConfig
//
//  Created by Fredy Leon on 9/12/25.
//

import Foundation
import SwiftUI
import FirebaseRemoteConfig
import FirebaseCore
public import Combine


public protocol RemoteConfigManagerProtocol: ObservableObject {
    var enabledLanguages: [String] { get }
    func fetchConfig(completion: @escaping (Error?) -> Void)
}


@MainActor
public final class RemoteConfigManager: RemoteConfigManagerProtocol {
    public static let shared = RemoteConfigManager()
    public let remoteConfig: RemoteConfig
    @Published public var enabledLanguages: [String] = []
    
    
    // MARK: - Inicialización
    public init() {
        if FirebaseApp.app() == nil {
            FirebaseApp.configure()
            print("✅ FirebaseApp configurado desde FHKConfig.")
        }
        
        remoteConfig = RemoteConfig.remoteConfig()
        setupSettings()
    }
    
    private func setupSettings() {
        let settings = RemoteConfigSettings()
        remoteConfig.configSettings = settings
    }
    
    public func fetchConfig(completion: @escaping (Error?) -> Void) {
        remoteConfig.fetchAndActivate { [weak self] (status, error) in
            guard let self = self else { return }
            
            if let error = error {
                print("⚠️ Error al obtener configuración remota: \(error.localizedDescription)")
            } else {
                print("✅ Remote Config activado. Status: \(status.rawValue)")
            }
            
            self.enabledLanguages = self.getEnabledLanguages()
            completion(error)
        }
    }
    
    // MARK: - Obtener Lenguajes
    private func getEnabledLanguages() -> [String] {
        let configValue = remoteConfig.configValue(forKey: "enabled_languages")
        let possibleData: Data? = configValue.dataValue
        
        guard let jsonData = possibleData, !jsonData.isEmpty else {
            print("❌ Error: No se pudo obtener el Data de lenguajes (el valor es nulo o vacío).")
            return []
        }
        
        do {
            let languageStatus = try JSONDecoder().decode(LanguageModel.self, from: jsonData)
            return languageStatus.enabledCodes
        } catch {
            print("❌ Error al decodificar LanguageStatus: \(error.localizedDescription)")
            return []
        }
    }
}
