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
internal import Combine

struct LanguageStatus: Codable, Sendable {
    let ES: Bool
    let FR: Bool
    let EN: Bool
    let IT: Bool
    
    var enabledCodes: [String] {
        var codes: [String] = []
        if ES { codes.append("ES") }
        if FR { codes.append("FR") }
        if EN { codes.append("EN") }
        if IT { codes.append("IT") }
        return codes
    }
}

public final class RemoteConfigManager: Sendable {
    
    // MARK: - Singleton & Lock
    public static let shared = RemoteConfigManager()
    
    // Lock para proteger el acceso a _enabledLanguages y el RemoteConfig
    private let lock = NSLock()
    
    public let remoteConfig: RemoteConfig!
    public var _enabledLanguages: [String] = []
    
    // Stream para emitir cambios de forma segura (alternativa a @Published en Sendable)
    public let _languageStream: AsyncStream<[String]>
    public let _languageContinuation: AsyncStream<[String]>.Continuation
    
    public var enabledLanguages: [String] {
        lock.lock()
        defer { lock.unlock() }
        return _enabledLanguages
    }
    
    public static var currentEnabledLanguages: [String] {
        return RemoteConfigManager.shared.enabledLanguages
    }
    
    public static var currentLanguageUpdates: AsyncStream<[String]> {
        return RemoteConfigManager.shared.languageUpdates
    }
    
    // Stream público para que SwiftUI pueda reaccionar a los cambios
    private var languageUpdates: AsyncStream<[String]> {
        _languageStream
    }
    
    // MARK: - Inicialización
    public init() {
        (_languageStream, _languageContinuation) = AsyncStream.makeStream()
        
        if FirebaseApp.app() == nil {
            FirebaseApp.configure()
            print("✅ FirebaseApp configurado desde FHKConfig.")
        }
        
        remoteConfig = RemoteConfig.remoteConfig()
        setupSettings()
        updateLanguages(self.getEnabledLanguages())
    }
    
    private func setupSettings() {
        let settings = RemoteConfigSettings()
        #if DEBUG
        settings.minimumFetchInterval = 0
        #endif
        remoteConfig.configSettings = settings
    }
    
    private func updateLanguages(_ newLanguages: [String]) {
        lock.lock()
        _enabledLanguages = newLanguages
        lock.unlock()
        
        _languageContinuation.yield(newLanguages)
    }
    
    private func fetchConfig(completion: @escaping (Error?) -> Void) {
        lock.lock()
        remoteConfig.fetchAndActivate { [weak self] (status, error) in
            guard let self = self else { return }
            
            if let error = error {
                print("⚠️ Error al obtener configuración remota: \(error.localizedDescription)")
            } else {
                print("✅ Remote Config activado. Status: \(status.rawValue)")
            }
            
            self.updateLanguages(self.getEnabledLanguages())
            
            completion(error)
            self.lock.unlock()
        }
    }
    
    public static func fetchConfig(completion: @escaping (Error?) -> Void) {
        RemoteConfigManager.shared.fetchConfig(completion: completion)
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
            let languageStatus = try JSONDecoder().decode(LanguageStatus.self, from: jsonData)
            return languageStatus.enabledCodes
        } catch {
            print("❌ Error al decodificar LanguageStatus: \(error.localizedDescription)")
            return []
        }
    }
}
