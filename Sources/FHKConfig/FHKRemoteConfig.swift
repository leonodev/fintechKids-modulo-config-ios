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


public protocol RemoteConfigManagerProtocol: ObservableObject, AnyObject {
    var enabledLanguages: [String] { get }
    func fetchConfig(completion: @escaping (Error?) -> Void)
}

@MainActor
public final class RemoteConfigManager: RemoteConfigManagerProtocol {
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
    
//    public func fetchConfig(completion: @escaping (Error?) -> Void) {
//        remoteConfig.fetchAndActivate { [weak self] (status, error) in
//            guard let self = self else { return }
//            
//            if let error = error {
//                Logger.error("Error al obtener configuración remota: \(error.localizedDescription)")
//            }
//            
//            self.enabledLanguages = self.getEnabledLanguages()
//            completion(error)
//        }
//    }
    
    public func fetchConfig(completion: @escaping (Error?) -> Void) {
        remoteConfig.fetchAndActivate { [weak self] (status, error) in
            guard let self = self else { return }
            
            switch status {
            case .successFetchedFromRemote:
                Logger.info("✅ Firebase: Datos frescos descargados.")
            case .successUsingPreFetchedData:
                Logger.info("🏠 Firebase: Usando datos de la caché local.")
            case .error:
                Logger.error("❌ Firebase: Error en la red o Throttling.")
            @unknown default:
                break
            }
            
            // Actualizamos la propiedad SIEMPRE, ya que si falló el fetch,
            // ahora tendrá al menos los defaults que pusimos arriba.
            Task { @MainActor in
                self.enabledLanguages = self.getEnabledLanguages()
                completion(error)
            }
        }
    }
    
    // MARK: - Obtener Lenguajes
    private func getEnabledLanguages() -> [String] {
        let configValue = remoteConfig.configValue(forKey: "enabled_languages")
        
        // Obtenemos el valor (Firebase devuelve "" si no existe, no nil)
        let jsonString = configValue.stringValue
        
        // 2. Comprobamos que no esté vacío
        guard !jsonString.isEmpty else {
            Logger.error("Error: El valor de 'enabled_languages' en Firebase está vacío.")
            return ["es"]
        }
        
        // Convertimos a Data
        guard let jsonData = jsonString.data(using: .utf8) else {
            Logger.error("Error: No se pudo convertir el string de Firebase a Data.")
            return ["es"]
        }
        
        do {
            let languageStatus = try JSONDecoder().decode(LanguageModel.self, from: jsonData)
            return languageStatus.enabledCodes
        } catch {
            Logger.error("Error al decodificar JSON de Remote Config: \(error)")
            return ["es"]
        }
    }
}

/*
 USO EN TEST
 
 final class MockConfigManager: RemoteConfigManagerProtocol {
     @Published var enabledLanguages: [String] = ["fr", "de"]
     // ... implementación de fetchConfig
 }

 let mockManager = MockConfigManager()
 let viewModel = ContentViewModel(configManager: mockManager)
 */
