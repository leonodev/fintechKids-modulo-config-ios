//
//  ContentViewModel.swift
//  FHKConfigDemo
//
//  Created by Fredy Leon on 10/12/25.
//
import SwiftUI
import Observation
import FHKConfig
import FHKUtils
import FHKInjections

@Observable
public final class ContentViewModel {
    var languages: [String] = []
    
    // Injections Dependency
    var configManager: FHKConfigManagerProtocol {
        inject.configManager
    }
    
    public init() {}
    
    public func loadConfig() async {
        configManager.fetchConfig { [weak self] error in
            guard let self = self else { return }
            if let error = error {
                Logger.error("Error al obtener configuración remota: \(error.localizedDescription)")
            } else {
                Logger.info("Remote Language Active")
                self.languages = configManager.enabledLanguages
            }
        }
    }
}
