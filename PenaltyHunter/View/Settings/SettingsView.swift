//
//  SettingsView.swift
//  PenaltyHunter
//
//  Created by Роман Главацкий on 27.08.2025.
//

import SwiftUI
import StoreKit

struct SettingsView: View {
    @EnvironmentObject var navManager: NavigationManager
    @EnvironmentObject var resultsManager: QuizResultsManager
    
    var body: some View {
        ZStack {
            Image(.mainBack)
                .resizable()
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 30) {
                    
                    //MARK: - Quiz Results Button
                    Button(action: {
                        navManager.navigate(to: .quizResults)
                    }) {
                        Image(.resultBut)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 190)
                    }
                    
                    //MARK: - Policy button
                    Button(action: {
                        SKStoreReviewController.requestReview()
                    }) {
                        Image(.rateBut)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 190)
                    }
                    
                    //MARK: - Policy button
                    Button(action: {
                        if let url = URL(string: "https://www.termsfeed.com/live/9a4810c4-cb7c-49dc-bfea-b4b46f41bbb1") {
                            UIApplication.shared.open(url)
                        }
                    }) {
                        Image(.policyBut)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 190)
                    }
                    
                    //MARK: - Info button
                    Button(action: {
                        navManager.navigate(to: .info)
                    }) {
                        Image(.infoBut)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 190)
                    }
                    
                    //MARK: - Back to menu
                    Button {
                        navManager.popBack()
                    } label: {
                        Image(.backtoMenuByt)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 190)
                    }
                    
                    // Clear Results Button
                    if !resultsManager.results.isEmpty {
                        Button(action: {
                
                            resultsManager.clearResults()
                        }) {
                            HStack {
                                Image(systemName: "trash.fill")
                                    .font(.title2)
                                    .foregroundColor(.red)
                                
                                Text("Clear All Results")
                                    .font(.title3)
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                                
                                Spacer()
                            }
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 15)
                                    .fill(Color.red.opacity(0.3))
                            )
                        }
                        
                    }
                    
                }
                .padding()
            }
        }
        .navigationBarBackButtonHidden()
    }
}

struct StatItem: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(color)
            
            Text(value)
                .font(.title3)
                .fontWeight(.bold)
                .foregroundColor(.white)
            
            Text(title)
                .font(.caption)
                .foregroundColor(.white.opacity(0.7))
        }
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    SettingsView()
        .environmentObject(NavigationManager())
        .environmentObject(QuizResultsManager.shared)
}
