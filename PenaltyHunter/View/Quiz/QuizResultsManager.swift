import Foundation
import SwiftUI

struct QuizResult: Codable, Identifiable {
    let id = UUID()
    let date: Date
    let difficulty: DifficultyLevel
    let score: Int
    let totalQuestions: Int
    let correctAnswers: Int
    let wrongAnswers: Int
    
    var percentage: Double {
        return Double(correctAnswers) / Double(totalQuestions) * 100
    }
    
    var grade: String {
        switch percentage {
        case 90...100: return "Great! 🏆"
        case 80..<90: return "Good! 🥈"
        case 70..<80: return "Satisfactory! 🥉"
        case 60..<70: return "No bad! 📚"
        default: return "Try again! 💪"
        }
    }
    
    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}

class QuizResultsManager: ObservableObject {
    static let shared = QuizResultsManager()
    
    @Published var results: [QuizResult] = []
    
    private let userDefaultsKey = "QuizResults"
    
    private init() {
        loadResults()
    }
    
    func saveResult(_ result: QuizResult) {
        results.append(result)
        saveToUserDefaults()
    }
    
    func clearResults() {
        results.removeAll()
        saveToUserDefaults()
    }
    
    func getResults(for difficulty: DifficultyLevel? = nil) -> [QuizResult] {
        if let difficulty = difficulty {
            return results.filter { $0.difficulty == difficulty }
        }
        return results
    }
    
    func getBestResult(for difficulty: DifficultyLevel? = nil) -> QuizResult? {
        let filteredResults = getResults(for: difficulty)
        return filteredResults.max { $0.percentage < $1.percentage }
    }
    
    func getAverageScore(for difficulty: DifficultyLevel? = nil) -> Double {
        let filteredResults = getResults(for: difficulty)
        guard !filteredResults.isEmpty else { return 0 }
        
        let totalPercentage = filteredResults.reduce(0) { $0 + $1.percentage }
        return totalPercentage / Double(filteredResults.count)
    }
    
    func getTotalAttempts(for difficulty: DifficultyLevel? = nil) -> Int {
        return getResults(for: difficulty).count
    }
    
    private func saveToUserDefaults() {
        if let encoded = try? JSONEncoder().encode(results) {
            UserDefaults.standard.set(encoded, forKey: userDefaultsKey)
        }
    }
    
    private func loadResults() {
        if let data = UserDefaults.standard.data(forKey: userDefaultsKey),
           let decoded = try? JSONDecoder().decode([QuizResult].self, from: data) {
            results = decoded
        }
    }
}
