// The Swift Programming Language
// https://docs.swift.org/swift-book

import Foundation
import FHKDesignSystem
import SwiftUI

public struct Configuration {
    private static var environmentType: EnvironmentType = .production
    private static var languageType: LanguageType = .es
    
    public enum EnvironmentType: String, Sendable {
        case production = "Production"
        case develop = "Develop"
    }

    public enum LanguageType: String, Sendable, Codable {
        case en = "en"
        case es = "es"
        case it = "it"
        case fr = "fr"
        
        public func code() -> String {
            return self.rawValue
        }
        
        public var languageTypeToImageFlag: Image {
            switch self {
            case .es: return .spainCircleFlag
            case .it: return .italyCircleFlag
            case .en: return .englandCircleFlag
            case .fr: return .franceCircleFlag
            }
        }
    }
    
    public static func languageTypeFromCode(_ string: String) -> LanguageType {
        return LanguageType(rawValue: string) ?? .es
    }

    public static func setEnvironment(_ environmentType: EnvironmentType) {
        Self.environmentType = environmentType
    }

    public static func setLanguage(_ languageType: LanguageType) {
        Self.languageType = languageType
    }

    public static func getEnvironment() -> EnvironmentType {
        return Self.environmentType
    }

    public static func getLanguage() -> LanguageType {
        return Self.languageType
    }
}

extension Image {
    public var imageToCode: String {
        switch self {
        case .italyCircleFlag: return Configuration.LanguageType.it.code()
        case .englandCircleFlag: return Configuration.LanguageType.en.code()
        case .franceCircleFlag: return Configuration.LanguageType.fr.code()
        default: return Configuration.LanguageType.es.code()
        }
    }
}
