//
//  LanguageType.swift
//  FHKConfig
//
//  Created by Fredy Leon on 21/2/26.
//

import SwiftUI

public enum LanguageType: String, Sendable, Codable, Equatable {
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
    
    public static func == (lhs: LanguageType, rhs: LanguageType) -> Bool {
        lhs.code() == rhs.code()
    }
}
