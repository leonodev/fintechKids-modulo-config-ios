//
//  ContentView.swift
//  FHKConfigDemo
//
//  Created by Fredy Leon on 9/12/25.
//

import SwiftUI
import FHKConfig

struct ContentView: View {
    private var viewModel = ContentViewModel()
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                
                // --- Sección de Lenguajes ---
                Text("Lenguajes Habilitados (Remote Config)")
                    .font(.title3)
                    .padding()
                
                List {
                    if viewModel.languages.isEmpty {
                        Text("No hay lenguajes habilitados o error de decodificación.")
                    } else {
                        ForEach(viewModel.languages, id: \.self) { lang in
                            Text("🌎 \(lang)")
                        }
                    }
                }
                .frame(maxHeight: 300)
                .listStyle(.insetGrouped)
            }
            .padding()
            .navigationTitle("FHKConfig Demo")
        }
        .onAppear {
            Task {
                await viewModel.loadConfig()
            }
        }
    }
}

#Preview {
    ContentView()
}
