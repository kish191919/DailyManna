//
//  ContentView.swift
//  DailyManna
//
//  Created by sunghwan ki on 12/26/24.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = QuoteReminderViewModel()
    
    var body: some View {
        NavigationView {
            ReminderSetupView(viewModel: viewModel)
        }
    }
}
