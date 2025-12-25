//
//  LanguageModifier.swift
//  FHKConfig
//
//  Created by Fredy Leon on 25/12/25.
//

import SwiftUI

public struct LanguageObserverModifier: ViewModifier {
    @State private var languageId = UUID()

    public func body(content: Content) -> some View {
        content
            .id(languageId) // Fuerza el refresh
            .onReceive(NotificationCenter.default.publisher(for: .languageDidChange)) { _ in
                self.languageId = UUID()
            }
    }
}

public extension View {
    public func observeLanguage() -> some View {
        self.modifier(LanguageObserverModifier())
    }
}
