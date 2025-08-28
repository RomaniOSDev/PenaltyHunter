//
//  QuizQuestionsView.swift
//  PenaltyHunter
//
//  Created by Роман Главацкий on 28.08.2025.
//

import SwiftUI

struct QuizQuestionsView: View {
    let difficulty: DifficultyLevel
    @EnvironmentObject var navManager: NavigationManager
    @EnvironmentObject var quizDataManager: QuizDataManager
    @EnvironmentObject var resultsManager: QuizResultsManager
    
    @State private var currentQuestionIndex = 0
    @State private var selectedAnswerIndex: Int?
    @State private var isAnswerSelected = false
    @State private var showResult = false
    @State private var correctAnswers = 0
    @State private var wrongAnswers = 0
    @State private var questions: [QuizQuestion] = []
    
    var body: some View {
        ZStack {
            Image(.mainBack)
                .resizable()
                .ignoresSafeArea()
            
            if showResult {
                resultView
            } else {
                questionView
            }
        }
        .navigationBarBackButtonHidden()
        .onAppear {
            loadQuestions()
        }
    }
    
    //MARK: - Question View
    private var questionView: some View {
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
                
                VStack {
                    Image(.questionsMen)
                        .resizable()
                        .frame(width: 70, height: 100)
                    
                    Text("\(currentQuestionIndex + 1) / \(questions.count)")
                        .font(.subheadline)
                        .foregroundColor(.black)
                }
                
                Spacer()
                
                Image(.backButton)
                    .resizable()
                    .frame(width: 70, height: 60)
                    .opacity(0)
            }
            .padding()
            
            Spacer()
            
            // Question
            if !questions.isEmpty {
                VStack(spacing: 25) {
                    Text(questions[currentQuestionIndex].question)
                        .font(.system(size: 32, weight: .bold))
                        .foregroundStyle(.black)
                        .minimumScaleFactor(0.5)
                        .lineLimit(0)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 20)
                    
                    // Answer options
                    VStack(spacing: 15) {
                        ForEach(0..<questions[currentQuestionIndex].options.count, id: \.self) { index in
                            Button(action: {
                                selectAnswer(index)
                            }) {
                                HStack {
                                    Spacer()
                                    
                                    Text(questions[currentQuestionIndex].options[index])
                                        .font(.system(size: 36, weight: .bold))
                                        .foregroundStyle(.black)
                                        .multilineTextAlignment(.leading)
                                        .minimumScaleFactor(0.5)
                                    
                                    Spacer()
                                }
                                .padding()
                                .background(
                                    Image(.answerBack)
                                        .resizable()
                                    
                                )
                            }
                            .disabled(isAnswerSelected)
                        }
                    }
                    .padding(.horizontal, 20)
                    
                    // Next button
                    
                        Button(action: nextQuestion) {
                            Image(.nextButton)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(height: 70)
                                .opacity(isAnswerSelected ? 1 : 0.5)
                        }
                        .disabled(!isAnswerSelected)
                        .padding(.horizontal, 20)
                        .transition(.opacity)
                    
                }
            }
            
            Spacer()
        }
    }
    
    //MARK: - Result View
    private var resultView: some View {
        VStack(spacing: 30) {
            Spacer()
            
            VStack(spacing: 20) {
               
                Image(difficulty.endImage)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                
                VStack(spacing: 15) {
                    HStack {
                        Text("Correct answers:")
                            .foregroundColor(.white)
                        Spacer()
                        Text("\(correctAnswers)")
                            .fontWeight(.bold)
                            .foregroundColor(.green)
                    }
                    
                    HStack {
                        Text("Incorrect answers:")
                            .foregroundColor(.white)
                        Spacer()
                        Text("\(wrongAnswers)")
                            .fontWeight(.bold)
                            .foregroundColor(.red)
                    }
                    
                    HStack {
                        Text("The percentage of correct ones:")
                            .foregroundColor(.white)
                        Spacer()
                        Text("\(Int(Double(correctAnswers) / Double(questions.count) * 100))%")
                            .fontWeight(.bold)
                            .foregroundColor(.blue)
                    }
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 15)
                        .fill(Color.black.opacity(0.3))
                )
                
                Text(gradeText)
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.yellow)
                    .multilineTextAlignment(.center)
            }
            .padding()
            
            Spacer()
            
            HStack(spacing: 15) {
                Button(action: restartQuiz) {
                    Image(.back2Butoon)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                }
                
                Button(action: backToMain) {
                    Image(.nextButton)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                }
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 30)
        }
        .onAppear {
            saveResult()
        }
    }
    
    private var gradeText: String {
        let percentage = Double(correctAnswers) / Double(questions.count) * 100
        switch percentage {
        case 90...100: return "Great! 🏆"
        case 80..<90: return "Good! 🥈"
        case 70..<80: return "Satisfactory! 🥉"
        case 60..<70: return "No bad! 📚"
        default: return "Try again! 💪"
        }
    }
    
    private func loadQuestions() {
        questions = quizDataManager.getQuestions(for: difficulty)
        currentQuestionIndex = 0
        correctAnswers = 0
        wrongAnswers = 0
        selectedAnswerIndex = nil
        isAnswerSelected = false
        showResult = false
    }
    
    private func selectAnswer(_ index: Int) {
        selectedAnswerIndex = index
        isAnswerSelected = true
        
        if index == questions[currentQuestionIndex].correctAnswerIndex {
            correctAnswers += 1
        } else {
            wrongAnswers += 1
        }
    }
    
    private func nextQuestion() {
        if currentQuestionIndex < questions.count - 1 {
            currentQuestionIndex += 1
            selectedAnswerIndex = nil
            isAnswerSelected = false
        } else {
            showResult = true
        }
    }
    
    private func restartQuiz() {
        loadQuestions()
    }
    
    private func backToMain() {
        navManager.popBack()
    }
    
    private func saveResult() {
        let result = QuizResult(
            date: Date(),
            difficulty: difficulty,
            score: correctAnswers,
            totalQuestions: questions.count,
            correctAnswers: correctAnswers,
            wrongAnswers: wrongAnswers
        )
        resultsManager.saveResult(result)
    }
    
    private func backgroundColor(for index: Int) -> Color {
        if !isAnswerSelected {
            return Color.black.opacity(0.3)
        }
        
        if index == questions[currentQuestionIndex].correctAnswerIndex {
            return Color.green.opacity(0.7)
        } else if index == selectedAnswerIndex {
            return Color.red.opacity(0.7)
        } else {
            return Color.black.opacity(0.3)
        }
    }
    
    private func iconName(for index: Int) -> String {
        if index == questions[currentQuestionIndex].correctAnswerIndex {
            return "checkmark.circle.fill"
        } else if index == selectedAnswerIndex {
            return "xmark.circle.fill"
        } else {
            return ""
        }
    }
    
    private func iconColor(for index: Int) -> Color {
        if index == questions[currentQuestionIndex].correctAnswerIndex {
            return .green
        } else if index == selectedAnswerIndex {
            return .red
        } else {
            return .clear
        }
    }
}

#Preview {
    QuizQuestionsView(difficulty: .easy)
        .environmentObject(QuizDataManager.shared)
        .environmentObject(QuizResultsManager.shared)
}
