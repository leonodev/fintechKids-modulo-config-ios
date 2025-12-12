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
    }

    private static var environmentType: EnvironmentType = .production
    private static var languageType: LanguageType = .es

    public static func setEnvironmentType(_ environmentType: EnvironmentType) {
        Self.environmentType = environmentType
    }

    public static func setLanguageType(_ languageType: LanguageType) {
        Self.languageType = languageType
    }

    public static func getEnvironmentType() -> EnvironmentType {
        return Self.environmentType
    }

    public static func getLanguageType() -> LanguageType {
        return Self.languageType
    }
}
