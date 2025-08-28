//
//  QuizView.swift
//  PenaltyHunter
//
//  Created by Роман Главацкий on 27.08.2025.
//

import SwiftUI

struct QuizView: View {
    
    @EnvironmentObject var navManager: NavigationManager
    
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
                VStack {
                    Button(action: {navManager.navigate(to: .quizQuestion)}) {
                        Image(.easyLabel)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                    }
                    Button(action: {navManager.navigate(to: .quizQuestion)}) {
                        Image(.mediumLabel)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                    }
                    Button(action: {navManager.navigate(to: .quizQuestion)}) {
                        Image(.hardLabel)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                    }
                }.padding()
            }.padding()
        }
    }
}

#Preview {
    QuizView()
}
