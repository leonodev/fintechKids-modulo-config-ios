//
//  ContentView.swift
//  FHKConfigDemo
//
//  Created by Fredy Leon on 9/12/25.
//

import SwiftUI
import FHKConfig

struct ContentView: View {
    @StateObject private var viewModel = ContentViewModel(configManager: RemoteConfigManager.shared)
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                
                // --- Sección de Status ---
                Text("Estado de la Carga")
                    .font(.headline)
                
                // --- Sección de Lenguajes ---
                Text("Lenguajes Habilitados (Remote Config)")
                    .font(.title3)
                
                List {
                    if viewModel.languages.isEmpty {
                        Text("No hay lenguajes habilitados o error de decodificación.")
                    } else {
                        ForEach(viewModel.languages, id: \.self) { lang in
                            Text("🌎 \(lang)")
                        }
                    }
                }
                .frame(maxHeight: 200)
                .listStyle(.insetGrouped)
            }
            .padding()
            .navigationTitle("FHKConfig Demo")
        }
        .onAppear {
            viewModel.loadConfig()
        }
    }
}

#Preview {
    ContentView()
}
