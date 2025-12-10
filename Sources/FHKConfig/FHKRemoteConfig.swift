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
import FHKUtils
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
            Logger.info("FirebaseApp configurado desde FHKConfig.")
        }
        
        remoteConfig = RemoteConfig.remoteConfig()
        setupSettings()
    }
    
    private func setupSettings() {
        let settings = RemoteConfigSettings()
        
        #if DEBUG
        // fetch immediately in develop
        settings.minimumFetchInterval = 0
        #else
        // fetch each two hours in production
        settings.minimumFetchInterval = 7200
        #endif
        
        remoteConfig.configSettings = settings
    }
    
    public func fetchConfig(completion: @escaping (Error?) -> Void) {
        remoteConfig.fetchAndActivate { [weak self] (status, error) in
            guard let self = self else { return }
            
            if let error = error {
                Logger.error("Error al obtener configuración remota: \(error.localizedDescription)")
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
            Logger.error("Error: No se pudo obtener el Data de lenguajes (el valor es nulo o vacío).")
            return []
        }
        
        do {
            let languageStatus = try JSONDecoder().decode(LanguageModel.self, from: jsonData)
            return languageStatus.enabledCodes
        } catch {
            Logger.error("Error al decodificar LanguageStatus: \(error.localizedDescription)")
            return []
        }
    }
}
