import Foundation

// MARK: - API Models
struct SStatsAPIResponse: Codable {
    let appName: String
    let documentation: String
    let mainSiteUrl: String
    let apiReference: String
    let openApiSchema: String
    let version: String
    let contacts: [String]
}

// MARK: - News Item Model
struct NewsItem: Identifiable, Codable {
    let id = UUID()
    let title: String
    let description: String
    let date: Date
    let category: NewsCategory
    let imageUrl: String?
    let source: String
    
    enum NewsCategory: String, CaseIterable, Codable {
        case football = "Football"
        case transfer = "Transfer"
        case match = "Match"
        case league = "League"
        case other = "Other"
        
        var emoji: String {
            switch self {
            case .football: return "⚽"
            case .transfer: return "🔄"
            case .match: return "🏆"
            case .league: return "🏅"
            case .other: return "📰"
            }
        }
        
        var color: String {
            switch self {
            case .football: return "green"
            case .transfer: return "blue"
            case .match: return "orange"
            case .league: return "purple"
            case .other: return "gray"
            }
        }
    }
}

// MARK: - Mock News Data (since API doesn't provide news content)
extension NewsItem {
    static let mockNews: [NewsItem] = [
        NewsItem(
            title: "SStats.net API v0.9.8.0 Released",
            description: "New version of SStats.net API has been released with improved performance and new features for football statistics.",
            date: Date(),
            category: .other,
            imageUrl: nil,
            source: "SStats.net"
        ),
        NewsItem(
            title: "Premier League Transfer Window Opens",
            description: "The summer transfer window is now open for Premier League clubs. Major signings expected this season.",
            date: Date().addingTimeInterval(-86400), // Yesterday
            category: .transfer,
            imageUrl: nil,
            source: "SStats.net"
        ),
        NewsItem(
            title: "Champions League Final Results",
            description: "Exciting Champions League final with record-breaking viewership and amazing goals.",
            date: Date().addingTimeInterval(-172800), // 2 days ago
            category: .match,
            imageUrl: nil,
            source: "SStats.net"
        ),
        NewsItem(
            title: "La Liga Season Preview",
            description: "Analysis of upcoming La Liga season with predictions and team rankings.",
            date: Date().addingTimeInterval(-259200), // 3 days ago
            category: .league,
            imageUrl: nil,
            source: "SStats.net"
        ),
        NewsItem(
            title: "World Cup Qualifiers Update",
            description: "Latest results from World Cup qualifiers around the world with surprising outcomes.",
            date: Date().addingTimeInterval(-345600), // 4 days ago
            category: .football,
            imageUrl: nil,
            source: "SStats.net"
        )
    ]
}

// MARK: - API Service
class NewsAPIService: ObservableObject {
    static let shared = NewsAPIService()
    
    @Published var apiInfo: SStatsAPIResponse?
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let baseURL = "https://api.sstats.net"
    
    private init() {}
    
    func fetchAPIInfo() {
        isLoading = true
        errorMessage = nil
        
        guard let url = URL(string: baseURL) else {
            errorMessage = "Invalid URL"
            isLoading = false
            return
        }
        
        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            DispatchQueue.main.async {
                self?.isLoading = false
                
                if let error = error {
                    self?.errorMessage = "Network error: \(error.localizedDescription)"
                    return
                }
                
                guard let data = data else {
                    self?.errorMessage = "No data received"
                    return
                }
                
                do {
                    let apiResponse = try JSONDecoder().decode(SStatsAPIResponse.self, from: data)
                    self?.apiInfo = apiResponse
                } catch {
                    self?.errorMessage = "Failed to decode response: \(error.localizedDescription)"
                }
            }
        }.resume()
    }
    
    func getNewsItems() -> [NewsItem] {
        // Since the API doesn't provide actual news content,
        // we return mock data but could integrate with real news API later
        return NewsItem.mockNews
    }
}
