import Foundation
import SwiftUICore

// MARK: - Referee Decision Types
enum RefereeDecision: String, CaseIterable, Codable {
    case penalty = "Penalty"
    case freeKick = "Free Kick"
    case yellowCard = "Yellow Card"
    case redCard = "Red Card"
    case playOn = "Play On"
    
    var imageCard: ImageResource {
        switch self {
        
        case .penalty:
            return .penaltyButtun
        case .freeKick:
            return .freeKickButon
        case .yellowCard:
            return .yaellowCardButton
        case .redCard:
            return .redCardButtun
        case .playOn:
            return .playOnButton
        }
    }
    
    var emoji: String {
        switch self {
        case .penalty: return "🎯"
        case .freeKick: return "⚽"
        case .yellowCard: return "🟨"
        case .redCard: return "🟥"
        case .playOn: return "⚪"
        }
    }
    
    var color: Color {
        switch self {
        case .penalty: return .red
        case .freeKick: return .blue
        case .yellowCard: return .yellow
        case .redCard: return .red
        case .playOn: return .green
        }
    }
}

// MARK: - Referee Question Model
struct RefereeQuestion: Identifiable {
    let id: Int
    let imageName: ImageResource // Placeholder for now, will be replaced with actual images
    let correctDecision: RefereeDecision
    let question: String
    let options: [RefereeDecision]
    
    var correctAnswer: RefereeDecision {
        return correctDecision
    }
}

// MARK: - Referee Result Model
struct RefereeResult: Identifiable, Codable {
    let id = UUID()
    let date: Date
    let score: Int
    let totalQuestions: Int
    let correctAnswers: Int
    let wrongAnswers: Int
    
    var percentage: Double {
        return Double(correctAnswers) / Double(totalQuestions) * 100
    }
    
    var grade: String {
        switch percentage {
        case 90...100: return "Excellent Referee! 🏆"
        case 80..<90: return "Good Referee! 🥈"
        case 70..<80: return "Fair Referee! 🥉"
        case 60..<70: return "Needs Practice! 📚"
        default: return "Keep Learning! 💪"
        }
    }
    
    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}

// MARK: - Referee Data Manager
class RefereeDataManager: ObservableObject {
    static let shared = RefereeDataManager()
    
    @Published var results: [RefereeResult] = []
    
    private let userDefaultsKey = "RefereeResults"
    
    private init() {
        loadResults()
    }
    
    func getQuestions() -> [RefereeQuestion] {
        return refereeQuestions
    }
    
    func saveResult(_ result: RefereeResult) {
        results.append(result)
        saveToUserDefaults()
    }
    
    func clearResults() {
        results.removeAll()
        saveToUserDefaults()
    }
    
    func getBestResult() -> RefereeResult? {
        return results.max { $0.percentage < $1.percentage }
    }
    
    func getAverageScore() -> Double {
        guard !results.isEmpty else { return 0 }
        let totalPercentage = results.reduce(0) { $0 + $1.percentage }
        return totalPercentage / Double(results.count)
    }
    
    func getTotalAttempts() -> Int {
        return results.count
    }
    
    private func saveToUserDefaults() {
        if let encoded = try? JSONEncoder().encode(results) {
            UserDefaults.standard.set(encoded, forKey: userDefaultsKey)
        }
    }
    
    private func loadResults() {
        if let data = UserDefaults.standard.data(forKey: userDefaultsKey),
           let decoded = try? JSONDecoder().decode([RefereeResult].self, from: data) {
            results = decoded
        }
    }
    
    // MARK: - Questions Data
    private let refereeQuestions: [RefereeQuestion] = [
        RefereeQuestion(
            id: 1,
            imageName: .ref1,
            correctDecision: .penalty,
            question: "What should the referee call in this situation?",
            options: [.penalty, .freeKick, .yellowCard, .redCard, .playOn]
        ),
        RefereeQuestion(
            id: 2,
            imageName: .ref2,
            correctDecision: .penalty,
            question: "What is the correct decision here?",
            options: [.penalty, .freeKick, .yellowCard, .redCard, .playOn]
        ),
        RefereeQuestion(
            id: 3,
            imageName: .ref3,
            correctDecision: .freeKick,
            question: "What should the referee award?",
            options: [.penalty, .freeKick, .yellowCard, .redCard, .playOn]
        ),
        RefereeQuestion(
            id: 4,
            imageName: .ref4,
            correctDecision: .freeKick,
            question: "What is the appropriate call?",
            options: [.penalty, .freeKick, .yellowCard, .redCard, .playOn]
        ),
        RefereeQuestion(
            id: 5,
            imageName: .ref5,
            correctDecision: .yellowCard,
            question: "What card should be shown?",
            options: [.penalty, .freeKick, .yellowCard, .redCard, .playOn]
        ),
        RefereeQuestion(
            id: 6,
            imageName: .ref6,
            correctDecision: .redCard,
            question: "What is the correct disciplinary action?",
            options: [.penalty, .freeKick, .yellowCard, .redCard, .playOn]
        ),
        RefereeQuestion(
            id: 7,
            imageName: .ref7,
            correctDecision: .yellowCard,
            question: "What should the referee show?",
            options: [.penalty, .freeKick, .yellowCard, .redCard, .playOn]
        ),
        RefereeQuestion(
            id: 8,
            imageName: .ref8,
            correctDecision: .redCard,
            question: "What is the appropriate punishment?",
            options: [.penalty, .freeKick, .yellowCard, .redCard, .playOn]
        ),
        RefereeQuestion(
            id: 9,
            imageName: .ref9,
            correctDecision: .freeKick,
            question: "What should be awarded here?",
            options: [.penalty, .freeKick, .yellowCard, .redCard, .playOn]
        ),
        RefereeQuestion(
            id: 10,
            imageName: .ref10,
            correctDecision: .playOn,
            question: "What should the referee do?",
            options: [.penalty, .freeKick, .yellowCard, .redCard, .playOn]
        )
    ]
}
