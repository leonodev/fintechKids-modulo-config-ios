// The Swift Programming Language
// https://docs.swift.org/swift-book

import FHKStorage
import FHKInjections
import FHKDomain

public class FHKConfiguration: FHKConfigurationProtocol {
    public var environmentType: EnvironmentType = .production
    
    // Properties injections
    private var storageManager: any FHKStorageManagerProtocol {
        inject.storageManager
    }
    
    public init() {}
    
    public func setEnvironment(_ environmentType: EnvironmentType) {
        self.environmentType = environmentType
    }

    public func getEnvironment() -> EnvironmentType {
        self.environmentType
    }

    public func getParentMail() async -> String? {
        try? storageManager.readKeychain(String.self, for: KeychainKeys.userKey, prompt: nil)
    }
}
