//
//  LanguageManager.swift
//  FHKConfig
//
//  Created by Fredy Leon on 25/12/25.
//

import SwiftUI
import FHKStorage
import FHKUtils

@MainActor
public final class LanguageManager: ObservableObject {
    public static let shared = LanguageManager()
    private let storage: UserDefaultsProtocol = UserDefaultStorage()
    @Published public var selectedLanguage: String = "es"
    
    private init() {}
    
    public func readLanguage() async {
        do {
            let languageCode = try await storage.read(String.self, forKey: UserDefaultsKeys.languageKey)
            let newCode = languageCode ?? "es"
            
            await MainActor.run {
                // Sincronizamos y notificamos SIEMPRE
                self.selectedLanguage = newCode.lowercased()
                NotificationCenter.default.post(name: .languageDidChange, object: nil)
            }
        } catch {
            Logger.error("Error reading: \(error)")
        }
    }
    
    public func saveLanguage(_ language: String) async {
        do {
            try await storage.save(language, forKey: UserDefaultsKeys.languageKey)
            
            await MainActor.run {
                self.selectedLanguage = language.lowercased()
                NotificationCenter.default.post(name: .languageDidChange, object: nil)
            }
        } catch {
            Logger.error("Error saving language: \(error)")
        }
    }
}
