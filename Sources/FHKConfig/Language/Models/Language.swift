//
//  LanguageModel.swift
//  FHKConfig
//
//  Created by Fredy Leon on 9/12/25.
//

import Foundation

public struct LanguageModel: Codable {
    let es: Bool
    let fr: Bool
    let en: Bool
    let it: Bool
    
    var enabledCodes: [String] {
        var codes: [String] = []
        if es { codes.append(Configuration.LanguageType.es.code()) }
        if fr { codes.append(Configuration.LanguageType.fr.code()) }
        if en { codes.append(Configuration.LanguageType.en.code()) }
        if it { codes.append(Configuration.LanguageType.it.code()) }
        return codes
    }
}
