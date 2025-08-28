import Foundation

enum DifficultyLevel: String, CaseIterable, Codable {
    case easy = "Easy"
    case medium = "Medium"
    case hard = "Hard"
    
    var emoji: String {
        switch self {
        case .easy: return "🟢"
        case .medium: return "🟡"
        case .hard: return "🔴"
        }
    }
    
    var color: String {
        switch self {
        case .easy: return "green"
        case .medium: return "yellow"
        case .hard: return "red"
        }
    }
    
    var endImage: ImageResource {
        switch self {
        case .easy: return .easyComp
        case .medium: return .mediumComp
        case .hard: return .hardComp
        }
    }
}

struct QuizQuestion {
    let id: Int
    let question: String
    let options: [String]
    let correctAnswerIndex: Int
    let difficulty: DifficultyLevel
    
    var correctAnswer: String {
        return options[correctAnswerIndex]
    }
}

class QuizDataManager: ObservableObject {
    static let shared = QuizDataManager()
    
    private init() {}
    
    func getQuestions(for difficulty: DifficultyLevel) -> [QuizQuestion] {
        switch difficulty {
        case .easy:
            return easyQuestions
        case .medium:
            return mediumQuestions
        case .hard:
            return hardQuestions
        }
    }
    
    private let easyQuestions: [QuizQuestion] = [
        QuizQuestion(id: 1, question: "How many players in one team?", options: ["10", "11", "12"], correctAnswerIndex: 1, difficulty: .easy),
        QuizQuestion(id: 2, question: "How long is one half?", options: ["40 min", "45 min", "60 min"], correctAnswerIndex: 1, difficulty: .easy),
        QuizQuestion(id: 3, question: "Kick from the corner?", options: ["Goal kick", "Corner kick", "Free kick"], correctAnswerIndex: 1, difficulty: .easy),
        QuizQuestion(id: 4, question: "What color is the warning card?", options: ["Red", "Yellow", "Green"], correctAnswerIndex: 1, difficulty: .easy),
        QuizQuestion(id: 5, question: "Which body part is forbidden?", options: ["Foot", "Head", "Hand"], correctAnswerIndex: 2, difficulty: .easy),
        QuizQuestion(id: 6, question: "What is the World Cup final called?", options: ["World Cup Final", "Super Cup", "Champions Final"], correctAnswerIndex: 0, difficulty: .easy),
        QuizQuestion(id: 7, question: "Penalty distance?", options: ["9 m", "11 m", "13 m"], correctAnswerIndex: 1, difficulty: .easy),
        QuizQuestion(id: 8, question: "Who plays in goal?", options: ["Defender", "Goalkeeper", "Forward"], correctAnswerIndex: 1, difficulty: .easy),
        QuizQuestion(id: 9, question: "How many points for a win?", options: ["2", "3", "4"], correctAnswerIndex: 1, difficulty: .easy),
        QuizQuestion(id: 10, question: "Football federation?", options: ["UEFA", "FIFA", "IOC"], correctAnswerIndex: 1, difficulty: .easy)
    ]
    
    private let mediumQuestions: [QuizQuestion] = [
        QuizQuestion(id: 11, question: "What is offside?", options: ["Player closer to goal at pass", "Attacker ahead of last defender at pass", "Player crossed midfield"], correctAnswerIndex: 1, difficulty: .medium),
        QuizQuestion(id: 12, question: "Max substitutions allowed?", options: ["3", "5", "6"], correctAnswerIndex: 1, difficulty: .medium),
        QuizQuestion(id: 13, question: "Who won the 2018 WC?", options: ["Germany", "France", "Argentina"], correctAnswerIndex: 1, difficulty: .medium),
        QuizQuestion(id: 14, question: "What after a draw?", options: ["Extra time", "Penalty shootout", "Replay"], correctAnswerIndex: 1, difficulty: .medium),
        QuizQuestion(id: 15, question: "Who is the captain?", options: ["Oldest player", "With armband", "First striker"], correctAnswerIndex: 1, difficulty: .medium),
        QuizQuestion(id: 16, question: "Champions League final name?", options: ["UEFA Final", "Champions League Final", "Cup Final"], correctAnswerIndex: 1, difficulty: .medium),
        QuizQuestion(id: 17, question: "WC 1966 mascot?", options: ["Lion", "Eagle", "Tiger"], correctAnswerIndex: 0, difficulty: .medium),
        QuizQuestion(id: 18, question: "Club with most UCL titles?", options: ["Barcelona", "Real Madrid", "Milan"], correctAnswerIndex: 1, difficulty: .medium),
        QuizQuestion(id: 19, question: "After two yellow cards?", options: ["Red card", "Penalty", "Free kick"], correctAnswerIndex: 0, difficulty: .medium),
        QuizQuestion(id: 20, question: "Usual added time per half?", options: ["1–5 min", "5–10 min", "10–15 min"], correctAnswerIndex: 0, difficulty: .medium)
    ]
    
    private let hardQuestions: [QuizQuestion] = [
        QuizQuestion(id: 21, question: "\"Hand of God\" scorer 1986?", options: ["Maradona", "Messi", "Ronaldo"], correctAnswerIndex: 0, difficulty: .hard),
        QuizQuestion(id: 22, question: "First WC winner 1930?", options: ["Brazil", "Uruguay", "Italy"], correctAnswerIndex: 1, difficulty: .hard),
        QuizQuestion(id: 23, question: "Portugal's top scorer?", options: ["Figo", "Ronaldo", "Eusébio"], correctAnswerIndex: 1, difficulty: .hard),
        QuizQuestion(id: 24, question: "\"Theatre of Dreams\" stadium?", options: ["Old Trafford", "Camp Nou", "Wembley"], correctAnswerIndex: 0, difficulty: .hard),
        QuizQuestion(id: 25, question: "Country with 5 WCs?", options: ["Germany", "Brazil", "Italy"], correctAnswerIndex: 1, difficulty: .hard),
        QuizQuestion(id: 26, question: "UCL all-time top scorer?", options: ["Messi", "Ronaldo", "Benzema"], correctAnswerIndex: 1, difficulty: .hard),
        QuizQuestion(id: 27, question: "Year cards introduced?", options: ["1966", "1970", "1982"], correctAnswerIndex: 1, difficulty: .hard),
        QuizQuestion(id: 28, question: "Barça coach treble 2009?", options: ["Rijkaard", "Guardiola", "Enrique"], correctAnswerIndex: 1, difficulty: .hard),
        QuizQuestion(id: 29, question: "WC 2002 hosts?", options: ["Korea & Japan", "France", "Germany"], correctAnswerIndex: 0, difficulty: .hard),
        QuizQuestion(id: 30, question: "7-time Ballon d'Or winner?", options: ["Ronaldo", "Messi", "Zidane"], correctAnswerIndex: 1, difficulty: .hard)
    ]
}
