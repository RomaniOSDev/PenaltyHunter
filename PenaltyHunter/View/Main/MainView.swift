//
//  MainView.swift
//  PenaltyHunter
//
//  Created by Роман Главацкий on 27.08.2025.
//

import SwiftUI

struct MainView: View {
    
    @StateObject private var navManager = NavigationManager()
    
    var body: some View {
        NavigationStack(path: $navManager.path) {
            ZStack {
                Image(.mainBack)
                    .resizable()
                    .ignoresSafeArea()
                VStack {
                    //MARK: Settings
                    HStack {
                        Spacer()
                        Button {
                            navManager.navigate(to: .settings)
                        } label: {
                            Image(.settingsButton)
                                .resizable()
                                .frame(width: 80, height: 80)
                        }

                    }
                    
                    //MARK: News
                    Button {
                        navManager.navigate(to: .news)
                    } label: {
                        Image(systemName: "newspaper")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                    }
                    
                    //MARK: Guide
                    Button {
                        navManager.navigate(to: .guide)
                    } label: {
                        
                        Image(.guideButton)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                    }
                    
                    //MARK: Quiz
                    Button {
                        navManager.navigate(to: .quiz)
                    } label: {
                        
                        Image(.quizButton)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                    }
                    
                    //MARK: Ref
                    Button {
                        navManager.navigate(to: .ref)
                    } label: {
                        
                        Image(.refButton)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                    }


                }.padding()
            }
            .navigationDestination(for: Screen.self) { screen in
                switch screen {
                case .guide: GuideView()
                case .settings: SettingsView()
                case .news: NewsView()
                case .quiz: QuizView()
                case .ref: RefView()
                case .guideInfo(let guide): GuideInfoView(guide: guide)
                case .quizQuestion: QuizQuestionsView()
                }
            }
        }
        .environmentObject(navManager)
    }
}

#Preview {
    MainView()
}
