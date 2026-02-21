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
        if es { codes.append(LanguageType.es.code()) }
        if fr { codes.append(LanguageType.fr.code()) }
        if en { codes.append(LanguageType.en.code()) }
        if it { codes.append(LanguageType.it.code()) }
        return codes
    }
}
