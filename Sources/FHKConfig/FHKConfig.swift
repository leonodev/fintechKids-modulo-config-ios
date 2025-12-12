// The Swift Programming Language
// https://docs.swift.org/swift-book

import Foundation

@globalActor
public actor ConfigurationActor {
    public static let shared = ConfigurationActor()
}

@ConfigurationActor
public struct Configuration {
    public enum EnvironmentType: String, Sendable {
        case production = "Production"
        case develop = "Develop"
    }

    public enum LanguageType: String, Sendable {
        case en = "EN"
        case es = "ES"
        case it = "IT"
        case fr = "FR"
        
        public func code() -> String {
            return self.rawValue
        }
    }

    private static var environmentType: EnvironmentType = .production
    private static var languageType: LanguageType = .es

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
