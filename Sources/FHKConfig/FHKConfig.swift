// The Swift Programming Language
// https://docs.swift.org/swift-book

import Foundation

public struct Configuration {
    private static var environmentType: EnvironmentType = .production
    private static var languageType: LanguageType = .es
    
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
