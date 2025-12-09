//
//  ContentView.swift
//  FHKConfigDemo
//
//  Created by Fredy Leon on 9/12/25.
//

import SwiftUI
import FHKConfig

struct ContentView: View {
    @State public var currentLanguages: [String] = RemoteConfigManager.currentEnabledLanguages
    @State private var fetchStatus: String = "Esperando configuración..."
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                
                // --- Sección de Status ---
                Text("Estado de la Carga")
                    .font(.headline)
                Text(fetchStatus)
                    .foregroundColor(fetchStatus.contains("Error") ? .red : .green)
                    .padding(.bottom)
                
                // --- Sección de Lenguajes ---
                Text("Lenguajes Habilitados (Remote Config)")
                    .font(.title3)
                
                List {
                    if currentLanguages.isEmpty {
                        Text("No hay lenguajes habilitados o error de decodificación.")
                    } else {
                        ForEach(currentLanguages, id: \.self) { lang in
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
        .task {
            for await languages in RemoteConfigManager.currentLanguageUpdates {
                // El cambio de estado se produce en la tarea principal (main actor).
                currentLanguages = languages
                fetchStatus = "✅ Configuración actualizada y cargada."
                print("UI actualizada con nuevos lenguajes: \(languages)")
            }
        }
        .onAppear {
            // 4. Inicia la carga de la configuración al aparecer la vista.
            fetchConfiguration()
        }
    }
    
    private func fetchConfiguration() {
        fetchStatus = "Obteniendo configuración remota..."
        RemoteConfigManager.fetchConfig { error in
            // Este closure se ejecuta en la cola principal (Firebase lo garantiza).
            if let error = error {
                fetchStatus = "❌ Error al obtener RC: \(error.localizedDescription)"
            } else {
                // El .task ya capturó el resultado y actualizó 'currentLanguages'
                // con el valor emitido por 'languageUpdates'.
                print("Fetch finalizado. La vista reaccionará a través del stream.")
            }
        }
    }
}

#Preview {
    ContentView()
}
