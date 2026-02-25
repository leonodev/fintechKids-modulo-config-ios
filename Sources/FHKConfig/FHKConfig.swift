// The Swift Programming Language
// https://docs.swift.org/swift-book

import Foundation
import SwiftUI
import FHKDesignSystem
import FHKStorage
import FHKInjections
import FHKDomain

public protocol FHKConfigurationProtocol: FHKInjectableProtocol {
    var environmentType: EnvironmentType { get set }
    func setEnvironment(_ environmentType: EnvironmentType)
    func getEnvironment() -> EnvironmentType
    func getParentMail() async -> String?
}

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
