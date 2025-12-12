// The Swift Programming Language
// https://docs.swift.org/swift-book

import Foundation

public struct Configuration {
    
    public enum EnvironmentType: String {
        case production = "production"
        case development = "development"
    }

    public enum LanguageType: String {
        case en = "EN"
        case es = "ES"
        case it = "IT"
        case fr = "FR"
    }
}
