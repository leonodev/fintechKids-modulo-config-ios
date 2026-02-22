// The Swift Programming Language
// https://docs.swift.org/swift-book

import Foundation
import SwiftUI
import FHKDesignSystem
import FHKStorage
import FHKInjections

public extension DependenciesInjection {
    var storageManager: any FHKStorageManagerProtocol {
        get { self[(any FHKStorageManagerProtocol).self] }
        set { self[(any FHKStorageManagerProtocol).self] = newValue }
    }
}

public protocol FHKConfigurationProtocol: FHKInjectableProtocol {
    var environmentType: EnvironmentType { get set }
    func setEnvironment(_ environmentType: EnvironmentType)
    func getEnvironment() -> EnvironmentType
    func getParentMail() async -> String?
}

public class FHKConfiguration: FHKConfigurationProtocol {
    public var environmentType: EnvironmentType = .production
    //public var storageManager: FHKStorageManagerProtocol
    private let storageManager = inject.storageManager
    
//    public init(storageManager: FHKStorageManagerProtocol) {
//        self.storageManager = storageManager
//    }
    
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
