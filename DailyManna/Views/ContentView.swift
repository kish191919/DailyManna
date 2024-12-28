
//

import SwiftUI

// ContentView.swift
struct ContentView: View {
    @StateObject private var viewModel = QuoteReminderViewModel()
    @State private var hasExistingSettings: Bool?  // Changed to optional
    
    var body: some View {
        Group {
            if let hasSettings = hasExistingSettings {  // Only show content when we know the settings state
                if hasSettings {
                    QuoteView(viewModel: viewModel)
                } else {
                    ReminderSetupView(viewModel: viewModel)
                }
            } else {
                // Show nothing while loading
                Color.clear
            }
        }
        .task {
            // Check for saved category and load it
            let hasSettings = await viewModel.loadSavedCategory()
            hasExistingSettings = hasSettings
        }
    }
}
