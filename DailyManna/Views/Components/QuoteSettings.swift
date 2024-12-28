import SwiftUI

// QuoteSettings.swift
struct QuoteSettings: Codable {
    var textSize: Double = 28
    var referenceSize: Double = 24
    var autoPlayInterval: Double = 12.0
    var hapticEnabled: Bool = true
    var theme: QuoteTheme = .classic
}

enum QuoteTheme: String, Codable, CaseIterable {
    case classic = "Classic"
    case midnight = "Midnight"
    // Premium themes
    case ocean = "Ocean"
    case forest = "Forest"
    case sunset = "Sunset"
}
