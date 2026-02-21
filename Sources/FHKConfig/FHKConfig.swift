// The Swift Programming Language
// https://docs.swift.org/swift-book

import Foundation
import SwiftUI
import FHKDesignSystem
import FHKStorage
import FHKInjections

public protocol ConfigurationProtocol: FHKInjectableProtocol {
    var environmentType: EnvironmentType { get set }
    var languageType: LanguageType { get set }
    var storageManager: FHKStorageManagerProtocol { get set }
    
    func languageTypeFromCode(_ string: String) -> LanguageType
    func setEnvironment(_ environmentType: EnvironmentType)
    func setLanguage(_ languageType: LanguageType)
    func getEnvironment() -> EnvironmentType
    func getLanguage() -> LanguageType
    func getParentMail() async -> String?
}

public class Configuration: ConfigurationProtocol {
    public var environmentType: EnvironmentType = .production
    public var languageType: LanguageType = .es
    public var storageManager: FHKStorageManagerProtocol
    
    public init(storageManager: FHKStorageManagerProtocol) {
        self.storageManager = storageManager
    }
    
    public func languageTypeFromCode(_ string: String) -> LanguageType {
        return LanguageType(rawValue: string) ?? .es
    }

    public func setEnvironment(_ environmentType: EnvironmentType) {
        self.environmentType = environmentType
    }

    public func setLanguage(_ languageType: LanguageType) {
        self.languageType = languageType
    }

    public func getEnvironment() -> EnvironmentType {
        self.environmentType
    }

    public func getLanguage() -> LanguageType {
        self.languageType
    }
    
    public func getParentMail() async -> String? {
        try? storageManager.readKeychain(String.self, for: KeychainKeys.userKey, prompt: nil)
    }
}

extension Image {
    public var imageToCode: String {
        switch self {
        case .englandCircleFlag: return LanguageType.en.code()
        case .franceCircleFlag: return LanguageType.fr.code()
        case .italyCircleFlag: return LanguageType.it.code()
        case .spainCircleFlag: return LanguageType.es.code()
        default: return ""
        }
    }
}
