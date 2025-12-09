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
        if ES { codes.append("ES") }
        if FR { codes.append("FR") }
        if EN { codes.append("EN") }
        if IT { codes.append("IT") }
        return codes
    }
}
