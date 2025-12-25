//
//  LanguageModel.swift
//  FHKConfig
//
//  Created by Fredy Leon on 9/12/25.
//

import Foundation

public struct LanguageModel: Codable {
    let ES: Bool
    let FR: Bool
    let EN: Bool
    let IT: Bool
    
    var enabledCodes: [String] {
        var codes: [String] = []
        if ES { codes.append(Configuration.LanguageType.es.code()) }
        if FR { codes.append(Configuration.LanguageType.fr.code()) }
        if EN { codes.append(Configuration.LanguageType.en.code()) }
        if IT { codes.append(Configuration.LanguageType.it.code()) }
        return codes
    }
}
