
//

import SwiftUI

// ContentView.swift
struct ContentView: View {
    @StateObject private var viewModel = QuoteReminderViewModel()
    @State private var hasExistingSettings: Bool = false
    
    var body: some View {
        NavigationView {
            if hasExistingSettings {
                QuoteView(viewModel: viewModel)
            } else {
                ReminderSetupView(viewModel: viewModel)
            }
        }
        .onAppear {
            // Check for saved category and load it
            Task {
                let hasSettings = await viewModel.loadSavedCategory()
                hasExistingSettings = hasSettings
            }
        }
    }
}
