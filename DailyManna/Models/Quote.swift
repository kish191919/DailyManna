import SwiftUI

// MARK: - Models
struct Quote: Identifiable, Codable {
    let id: UUID
    let text: String
    let reference: String
    let categories: [QuoteCategory]
}

