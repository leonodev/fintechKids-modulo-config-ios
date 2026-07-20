// The Swift Programming Language
// https://docs.swift.org/swift-book

import Foundation
import FHKDomain
import FHKInjections
import FHKStorage

import Foundation

public extension FHKConfiguration {
    static var live: Self {
        let state = LiveState()
        
        var config = Self()
        
        config.parentMail = {
            state.readParentMail()
        }
        config.familyName = {
            state.readFamilyName()
        }
        
        config.approvePin = {
            state.readApprovePin()
        }
        
        config.environmentType = {
            state.getEnvironment()
        }
        
        config.refreshParentMail = {
            state.refreshParentMail()
        }
        
        config.refreshFamilyName = {
            state.refreshFamilyName()
        }
        
        config.setEnvironment = {
            env in state.setEnvironment(env)
        }
        
        config.getEnvironment = {
            state.getEnvironment()
        }
        
        return config
    }
}

private final class LiveState: @unchecked Sendable {
    private let lock = NSLock()
    
    private var parentMail: String?
    private var familyName: String?
    private var approvePin: String?
    private var environmentType: EnvironmentType = .production
    
    private var storage: FHKStorageManager {
        inject.fhkStorage
    }
    
    init() {
        // Initial load from the Keychain at startup
        self.parentMail = try? storage.readKeychain(String.self,
                                                    for: KeychainKeys.userKey, prompt: nil)
        self.familyName = try? storage.readKeychain(String.self,
                                                    for: KeychainKeys.familyNameKey, prompt: nil)
        self.approvePin = try? storage.readKeychain(String.self,
                                                    for: KeychainKeys.approvePinKey, prompt: nil)
    }
    
    // MARK: - Getters Protegidos
    func readParentMail() -> String? {
        lock.lock(); defer { lock.unlock() }
        return parentMail
    }
    
    func readFamilyName() -> String? {
        lock.lock(); defer { lock.unlock() }
        return familyName
    }
    
    func readApprovePin() -> String? {
        lock.lock(); defer { lock.unlock() }
        return approvePin
    }
    
    func getEnvironment() -> EnvironmentType {
        lock.lock(); defer { lock.unlock() }
        return environmentType
    }
    
    // MARK: - Mutaciones Protegidas
    func setEnvironment(_ env: EnvironmentType) {
        lock.lock(); defer { lock.unlock() }
        environmentType = env
    }
    
    func refreshParentMail() {
        let newValue = try? storage.readKeychain(String.self, for: KeychainKeys.userKey, prompt: nil)
        lock.lock(); defer { lock.unlock() }
        parentMail = newValue
    }
    
    func refreshFamilyName() {
        let newValue = try? storage.readKeychain(String.self, for: KeychainKeys.familyNameKey, prompt: nil)
        lock.lock(); defer { lock.unlock() }
        familyName = newValue
    }
}
