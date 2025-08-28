import SwiftUI

struct QuizResultsView: View {
    @EnvironmentObject var navManager: NavigationManager
    @EnvironmentObject var resultsManager: QuizResultsManager
    @State private var selectedDifficulty: DifficultyLevel? = nil
    
    var body: some View {
        ZStack {
            Image(.mainBack)
                .resizable()
                .ignoresSafeArea()
            
            VStack(spacing: 20) {
                // Header
                HStack {
                    Button {
                        navManager.popBack()
                    } label: {
                        Image(.backButton)
                            .resizable()
                            .frame(width: 70, height: 60)
                    }
                    
                    Spacer()
                    
                    Text("Quiz Results")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    
                    Spacer()
                    
                    Image(.backButton)
                        .resizable()
                        .frame(width: 70, height: 60)
                        .opacity(0)
                }
                .padding()
                
                // Difficulty Filter
                HStack(spacing: 15) {
                    Button(action: { selectedDifficulty = nil }) {
                        Text("All")
                            .font(.title3)
                            .fontWeight(.bold)
                            .foregroundColor(selectedDifficulty == nil ? .white : .white.opacity(0.6))
                            .padding(.horizontal, 20)
                            .padding(.vertical, 10)
                            .background(
                                RoundedRectangle(cornerRadius: 20)
                                    .fill(selectedDifficulty == nil ? Color.blue : Color.blue.opacity(0.3))
                            )
                    }
                    
                    ForEach(DifficultyLevel.allCases, id: \.self) { difficulty in
                        Button(action: { selectedDifficulty = difficulty }) {
                            HStack {
                                Text(difficulty.emoji)
                                Text(difficulty.rawValue)
                            }
                            .font(.title3)
                            .fontWeight(.bold)
                            .foregroundColor(selectedDifficulty == difficulty ? .white : .white.opacity(0.6))
                            .padding(.horizontal, 20)
                            .padding(.vertical, 10)
                            .background(
                                RoundedRectangle(cornerRadius: 20)
                                    .fill(selectedDifficulty == difficulty ? Color(difficulty.color) : Color(difficulty.color).opacity(0.3))
                            )
                        }
                    }
                }
                .padding(.horizontal)
                
                // Statistics
                statisticsView
                
                // Results List
                resultsListView
                
                Spacer()
            }
        }
        .navigationBarBackButtonHidden()
    }
    
    private var statisticsView: some View {
        VStack(spacing: 15) {
            HStack(spacing: 20) {
                QuizStatCard(
                    title: "Total Attempts",
                    value: "\(resultsManager.getTotalAttempts(for: selectedDifficulty))",
                    color: .blue
                )
                
                QuizStatCard(
                    title: "Best Score",
                    value: "\(Int(resultsManager.getBestResult(for: selectedDifficulty)?.percentage ?? 0))%",
                    color: .green
                )
                
                QuizStatCard(
                    title: "Average",
                    value: "\(Int(resultsManager.getAverageScore(for: selectedDifficulty)))%",
                    color: .orange
                )
            }
            .padding(.horizontal)
        }
    }
    
    private var resultsListView: some View {
        ScrollView {
            LazyVStack(spacing: 15) {
                let filteredResults = resultsManager.getResults(for: selectedDifficulty)
                
                if filteredResults.isEmpty {
                    VStack(spacing: 20) {
                        Image(systemName: "trophy")
                            .font(.system(size: 60))
                            .foregroundColor(.yellow)
                        
                        Text("No results yet")
                            .font(.title2)
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                        
                        Text("Complete your first quiz to see results here!")
                            .font(.subheadline)
                            .foregroundColor(.white.opacity(0.7))
                            .multilineTextAlignment(.center)
                    }
                    .padding(.top, 50)
                } else {
                    ForEach(filteredResults.sorted { $0.date > $1.date }) { result in
                        QuizResultCard(result: result)
                    }
                }
            }
            .padding(.horizontal)
        }
    }
}

struct QuizStatCard: View {
    let title: String
    let value: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 8) {
            Text(title)
                .font(.caption)
                .fontWeight(.medium)
                .foregroundColor(.white.opacity(0.8))
                .multilineTextAlignment(.center)
            
            Text(value)
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.white)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 15)
                .fill(color.opacity(0.3))
        )
    }
}

struct QuizResultCard: View {
    let result: QuizResult
    
    var body: some View {
        HStack(spacing: 15) {
            // Difficulty indicator
            VStack {
                Text(result.difficulty.emoji)
                    .font(.title2)
                Text(result.difficulty.rawValue)
                    .font(.caption)
                    .fontWeight(.medium)
            }
            .foregroundColor(.white)
            .frame(width: 60)
            
            // Result details
            VStack(alignment: .leading, spacing: 5) {
                HStack {
                    Text("Score: \(result.correctAnswers)/\(result.totalQuestions)")
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    
                    Spacer()
                    
                    Text("\(Int(result.percentage))%")
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundColor(scoreColor)
                }
                
                Text(result.grade)
                    .font(.subheadline)
                    .foregroundColor(.yellow)
                
                Text(result.formattedDate)
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.7))
            }
            
            Spacer()
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 15)
                .fill(Color.black.opacity(0.3))
        )
    }
    
    private var scoreColor: Color {
        switch result.percentage {
        case 90...100: return .green
        case 80..<90: return .blue
        case 70..<80: return .orange
        case 60..<70: return .yellow
        default: return .red
        }
    }
}

#Preview {
    QuizResultsView()
        .environmentObject(QuizResultsManager.shared)
        .environmentObject(NavigationManager())
}
