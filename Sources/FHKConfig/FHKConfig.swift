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
        case en = "EN"
        case es = "ES"
        case it = "IT"
        case fr = "FR"
        
        public func code() -> String {
            return self.rawValue
        }
        
        public var languageToImage: Image {
            switch self {
            case .es: return .spainCircleFlag
            case .it: return .italyCircleFlag
            case .en: return .englandCircleFlag
            case .fr: return .franceCircleFlag
            }
        }
        
        public static func getCode(from type: LanguageType) -> String {
            return type.code()
        }
        
        public static func imageToCode(_ flag: Image) -> String? {
            if flag == .spainCircleFlag { return "ES" }
            if flag == .italyCircleFlag { return "IT" }
            if flag == .englandCircleFlag { return "EN" }
            if flag == .franceCircleFlag { return "FR" }
            return nil
        }
        
        public static func codeToImage(_ code: String) -> Image? {
            switch code {
            case "ES": return .spainCircleFlag
            case "IT": return .italyCircleFlag
            case "EN": return .englandCircleFlag
            case "FR": return .franceCircleFlag
            default: return nil
            }
        }
    }
    
    public static func from(string: String) -> LanguageType {
        return LanguageType(rawValue: string.uppercased()) ?? .es
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
