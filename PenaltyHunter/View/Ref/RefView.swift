//
//  RefView.swift
//  PenaltyHunter
//
//  Created by Роман Главацкий on 27.08.2025.
//

import SwiftUI

struct RefView: View {
    @EnvironmentObject var navManager: NavigationManager
    @StateObject private var refereeManager = RefereeDataManager.shared
    
    @State private var currentQuestionIndex = 0
    @State private var selectedDecision: RefereeDecision?
    @State private var isAnswerSelected = false
    @State private var showResult = false
    @State private var correctAnswers = 0
    @State private var wrongAnswers = 0
    @State private var questions: [RefereeQuestion] = []
    @State private var showStartScreen = true
    
    var body: some View {
        ZStack {
            Image(.mainBack)
                .resizable()
                .ignoresSafeArea()
            
            if showStartScreen {
                startScreen
            } else if showResult {
                resultScreen
            } else {
                questionScreen
            }
        }
        .navigationBarBackButtonHidden()
        .onAppear {
            loadQuestions()
        }
    }
    
    // MARK: - Start Screen
    private var startScreen: some View {
        VStack(spacing: 30) {
            //MARK:  - Backbutton
            HStack {
                Button {
                    navManager.popBack()
                } label: {
                    Image(.backButton)
                        .resizable()
                        .frame(width: 70, height: 60)
                }
                Spacer()
                
                
            }
            Spacer()
            
            VStack(spacing: 20) {
                Image(systemName: "whistle.fill")
                    .font(.system(size: 80))
                    .foregroundColor(.yellow)
                
                Text("Referee Training")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                
                Text("Test your referee skills with 10 challenging situations")
                    .font(.title3)
                    .foregroundColor(.white.opacity(0.8))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                
                VStack(spacing: 15) {
                    HStack {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(.green)
                        Text("Penalty decisions")
                        Spacer()
                    }
                    .foregroundColor(.white)
                    
                    HStack {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(.green)
                        Text("Card decisions")
                        Spacer()
                    }
                    .foregroundColor(.white)
                    
                    HStack {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(.green)
                        Text("Free kick calls")
                        Spacer()
                    }
                    .foregroundColor(.white)
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 15)
                        .fill(Color.black.opacity(0.3))
                )
            }
            
            Spacer()
            
            Button(action: startQuiz) {
                HStack {
                    Image(systemName: "play.fill")
                        .font(.title2)
                    Text("Start Referee Test")
                        .font(.title3)
                        .fontWeight(.bold)
                }
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 15)
                        .fill(Color.green)
                )
            }
            
        }
        .padding()
    }
    
    // MARK: - Question Screen
    private var questionScreen: some View {
        VStack(spacing: 20) {
            // Header
            HStack {
                Button {
                    showStartScreen = true
                } label: {
                    Image(.backButton)
                        .resizable()
                        .frame(width: 70, height: 60)
                }
                
                Spacer()
                
                VStack {
                    Text("Question \(currentQuestionIndex + 1) of \(questions.count)")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                }
                
                Spacer()
                
                Image(.backButton)
                    .resizable()
                    .frame(width: 70, height: 60)
                    .opacity(0)
            }
            
            
            Spacer()
            
            if !questions.isEmpty {
                VStack {
                    // Question Image (placeholder for now)
                    Image(questions[currentQuestionIndex].imageName)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .cornerRadius(10)
                    
                    // Question Text
                    Text(questions[currentQuestionIndex].question)
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 20)
                    
                    // Answer Options
                    LazyHGrid(rows: [GridItem(), GridItem(), GridItem()]) {
                        ForEach(questions[currentQuestionIndex].options, id: \.self) { decision in
                            Button {
                                selectDecision(decision)
                            } label: {
                                Image(decision.imageCard)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                            }
                            
                        }
                    }
                    
                    // Next Button
                    Button {
                        nextQuestion()
                    } label: {
                        Image(.nextButton)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .opacity(isAnswerSelected ? 1 : 0.3)
                            .frame(maxHeight: 65)
                    }
                }
            }
            
            Spacer()
        }
        .padding()
    }
    
    // MARK: - Result Screen
    private var resultScreen: some View {
        VStack{
            Spacer()
            
            VStack(spacing: 20) {
                Image(.correct)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                
                VStack(spacing: 15) {
                    HStack {
                        Text("Correct decisions:")
                            .foregroundColor(.white)
                        Spacer()
                        Text("\(correctAnswers)")
                            .fontWeight(.bold)
                            .foregroundColor(.green)
                    }
                    
                    HStack {
                        Text("Incorrect decisions:")
                            .foregroundColor(.white)
                        Spacer()
                        Text("\(wrongAnswers)")
                            .fontWeight(.bold)
                            .foregroundColor(.red)
                    }
                    
                    HStack {
                        Text("Success rate:")
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
            
            HStack{
                Button(action: restartQuiz) {
                    Image(.back2Butoon)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                }
                
                Button(action: backToStart) {
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
    
    // MARK: - Helper Methods
    private var gradeText: String {
        let percentage = Double(correctAnswers) / Double(questions.count) * 100
        switch percentage {
        case 90...100: return "Excellent Referee! 🏆"
        case 80..<90: return "Good Referee! 🥈"
        case 70..<80: return "Fair Referee! 🥉"
        case 60..<70: return "Needs Practice! 📚"
        default: return "Keep Learning! 💪"
        }
    }
    
    private func loadQuestions() {
        questions = refereeManager.getQuestions()
        resetQuiz()
    }
    
    private func resetQuiz() {
        currentQuestionIndex = 0
        correctAnswers = 0
        wrongAnswers = 0
        selectedDecision = nil
        isAnswerSelected = false
        showResult = false
        showStartScreen = true
    }
    
    private func startQuiz() {
        showStartScreen = false
    }
    
    //    private func showResults() {
    //        // This could navigate to a results view
    //        // For now, we'll just show the start screen
    //        showStartScreen = true
    //    }
    
    private func selectDecision(_ decision: RefereeDecision) {
        selectedDecision = decision
        isAnswerSelected = true
        
        if decision == questions[currentQuestionIndex].correctAnswer {
            correctAnswers += 1
        } else {
            wrongAnswers += 1
        }
    }
    
    private func nextQuestion() {
        if currentQuestionIndex < questions.count - 1 {
            currentQuestionIndex += 1
            selectedDecision = nil
            isAnswerSelected = false
        } else {
            showResult = true
        }
    }
    
    private func restartQuiz() {
        resetQuiz()
    }
    
    private func backToStart() {
        showStartScreen = true
    }
    
    private func saveResult() {
        let result = RefereeResult(
            date: Date(),
            score: correctAnswers,
            totalQuestions: questions.count,
            correctAnswers: correctAnswers,
            wrongAnswers: wrongAnswers
        )
        refereeManager.saveResult(result)
    }
    
    private func backgroundColor(for decision: RefereeDecision) -> Color {
        if !isAnswerSelected {
            return Color.black.opacity(0.3)
        }
        
        if decision == questions[currentQuestionIndex].correctAnswer {
            return Color.green.opacity(0.7)
        } else if decision == selectedDecision {
            return Color.red.opacity(0.7)
        } else {
            return Color.black.opacity(0.3)
        }
    }
}

#Preview {
    RefView()
        .environmentObject(RefereeDataManager.shared)
}
