// The Swift Programming Language
// https://docs.swift.org/swift-book

import Foundation
import FHKDomain
import FHKInjections


public final class FHKConfiguration: @unchecked Sendable, FHKConfigurationProtocol {
    private let lock = NSLock()
    
    private var storage: FHKStorageManagerProtocol {
        inject.fhkStorage
    }
    
    public var parentMail: String?
    public var familyName: String?
    
    private var _environmentType: EnvironmentType = .production
    public var environmentType: EnvironmentType {
        get {
            lock.lock()
            defer { lock.unlock() }
            return _environmentType
        }
        set {
            lock.lock()
            defer { lock.unlock() }
            _environmentType = newValue
        }
    }
    
    public init() {
        self.parentMail = readParentMail()
    }
    
    public func setEnvironment(_ environmentType: EnvironmentType) {
        lock.lock()
        defer { lock.unlock() }
        self._environmentType = environmentType
    }

    public func getEnvironment() -> EnvironmentType {
        lock.lock()
        defer { lock.unlock() }
        return self._environmentType
    }
    
    public func updateParentMail() {
        self.parentMail = readParentMail()
    }
}

private extension FHKConfiguration {
    
    private func readParentMail() -> String? {
        try? storage.readKeychain(String.self, for: KeychainKeys.userKey, prompt: nil)
    }
    
    private func readFamilyName() -> String? {
        try? storage.readKeychain(String.self, for: KeychainKeys.familyNameKey, prompt: nil)
    }
}
