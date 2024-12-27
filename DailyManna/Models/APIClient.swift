import Foundation

struct APIClient {
    static let baseURL = "https://aistockadvisor.net"
    
    static func fetchVerses(forCategory category: SubCategory) async throws -> [Quote] {
        let url = URL(string: "\(baseURL)/api/categories/\(category.name.lowercased())/verses")!
        let (data, _) = try await URLSession.shared.data(from: url)
        let response = try JSONDecoder().decode(VersesResponse.self, from: data)
        return response.verses
    }
 }

 struct VersesResponse: Codable {
    let verses: [Quote]
 }
