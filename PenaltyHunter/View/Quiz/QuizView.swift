//
//  QuizView.swift
//  PenaltyHunter
//
//  Created by Роман Главацкий on 27.08.2025.
//

import SwiftUI

struct QuizView: View {
    
    @EnvironmentObject var navManager: NavigationManager
    @State private var selectedDifficulty: DifficultyLevel?
    
    var body: some View {
        ZStack {
            Image(.mainBack)
                .resizable()
                .ignoresSafeArea()
            VStack(spacing: 20) {
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
                    Image(.chooseLevelLabel)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(maxHeight: 190)
                    Spacer()
                    Image(.backButton)
                        .resizable()
                        .frame(width: 70, height: 60)
                        .opacity(0)

                }
                Spacer()
                VStack(spacing: 15) {
                    Button(action: {
                        selectedDifficulty = .easy
                        navManager.navigate(to: .quizQuestion(.easy))
                    }) {
                        Image(.easyLabel)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                    }
                    Button(action: {
                        selectedDifficulty = .medium
                        navManager.navigate(to: .quizQuestion(.medium))
                    }) {
                        Image(.mediumLabel)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                    }
                    Button(action: {
                        selectedDifficulty = .hard
                        navManager.navigate(to: .quizQuestion(.hard))
                    }) {
                        Image(.hardLabel)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                    }
                }.padding()
            }.padding()
        }
        .navigationBarBackButtonHidden()
        .onAppear {
            // Сбрасываем выбранный уровень при появлении экрана
            selectedDifficulty = nil
        }
    }
}

#Preview {
    QuizView()
        .environmentObject(NavigationManager())
        .environmentObject(QuizDataManager.shared)
}
