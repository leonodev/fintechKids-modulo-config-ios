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
                Text("FHKConfig Demo")
                    .font(.title3)
                    .padding()
                
            }
            .padding()
            .navigationTitle("FHKConfig Demo")
        }
    }
}

#Preview {
    ContentView()
}
