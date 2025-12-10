//
//  ContentViewModel.swift
//  FHKConfigDemo
//
//  Created by Fredy Leon on 10/12/25.
//
import SwiftUI
import FHKConfig
import Combine

public final class ContentViewModel<T: RemoteConfigManagerProtocol>: ObservableObject {
    private var configManager: T
    
    @Published var languages: [String] = []
    private var cancellables = Set<AnyCancellable>()
    
    public init(configManager: T) {
        self.configManager = configManager
        
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
                print("⚠️ Error al obtener configuración remota: \(error.localizedDescription)")
            } else {
                print("✅ Remote Language Active")
            }
        }
    }
}
