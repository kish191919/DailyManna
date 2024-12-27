import SwiftUI

struct Quote: Identifiable, Codable {
    let id: String  // UUID에서 String으로 변경
    let text: String
    let reference: String
    let category: String
    
    enum CodingKeys: String, CodingKey {
        case id, text, reference, category
    }
}

