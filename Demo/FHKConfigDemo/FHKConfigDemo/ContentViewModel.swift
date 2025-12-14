//
//  ContentViewModel.swift
//  FHKConfigDemo
//
//  Created by Fredy Leon on 10/12/25.
//
import SwiftUI
import FHKConfig
import FHKUtils
import Combine

public final class ContentViewModel<Manager: RemoteConfigManagerProtocol>: ObservableObject {
    private var configManager: Manager
    
    @Published var languages: [String] = []
    private var cancellables = Set<AnyCancellable>()
    
    public init(configManager: Manager) {
        self.configManager = configManager
        self.languages = configManager.enabledLanguages
        
        configManager.objectWillChange
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.languages = configManager.enabledLanguages
            }
            .store(in: &cancellables)
    }

    public func loadConfig() {
        configManager.fetchConfig { [weak self] error in
            guard let _ = self else { return }
            if let error = error {
                Logger.error("Error al obtener configuración remota: \(error.localizedDescription)")
            } else {
                Logger.info("Remote Language Active")
            }
        }
    }
}
