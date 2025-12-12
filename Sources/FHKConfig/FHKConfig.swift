// The Swift Programming Language
// https://docs.swift.org/swift-book

import Foundation

public struct Configuration {
    
    public enum EnvironmentType: String {
        case production = "Production"
        case develop = "Develop"
    }

    public enum LanguageType: String {
        case en = "EN"
        case es = "ES"
        case it = "IT"
        case fr = "FR"
    }
    
    public static var environmentType: EnvironmentType = .production
    public static var languageType: LanguageType = .es
}
