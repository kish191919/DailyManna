
import SwiftUI

enum QuoteCategory: String, CaseIterable, Codable {
    case freedom = "Freedom"
    case motivation = "Motivation"
    case newYear = "New Year"
    case stoicism = "Stoicism"
    case success = "Success"
    case business = "Business"
    case newBeginnings = "New beginnings"
    case personalGrowth = "Personal Growth"
    case positivity = "Positivity"
    case encouragement = "Encouragement"
    case happiness = "Happiness"
    case positiveMindset = "Positive Mindset"
    case selfDevelopment = "Self-Development"
    case selfRespect = "Self-Respect"
    case selfEsteem = "Self-Esteem"
    case selfDiscipline = "Self-Discipline"
    case selfLove = "Self-Love"
    case selfTransformation = "Self-Transformation"
    case hope = "Hope"  // 추가된 부분
    
    var icon: String {
        switch self {
        case .freedom: return "🦅"
        case .motivation: return "🔥"
        case .newYear: return "🎉"
        case .stoicism: return "🏛"
        case .success: return "🏅"
        case .business: return "🏢"
        case .newBeginnings: return "NEW"
        case .personalGrowth: return "📈"
        case .positivity: return "👍"
        case .encouragement: return "📢"
        case .happiness: return "😊"
        case .positiveMindset: return "🧠"
        case .selfDevelopment: return "🌱"
        case .selfRespect: return "👍"
        case .selfEsteem: return "💝"
        case .selfDiscipline: return "✅"
        case .selfLove: return "🛁"
        case .selfTransformation: return "🦋"
        case .hope: return "🌟"  // 추가된 부분
        }
    }
}
