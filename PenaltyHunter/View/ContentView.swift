//
//  ContentView.swift
//  PenaltyHunter
//
//  Created by Роман Главацкий on 27.08.2025.
//

import SwiftUI

struct ContentView: View {
    @State private var showMain: Bool = false
    @State private var showAnimation: Bool = false
    var body: some View {
        ZStack {
            Image(.mainBack)
                .resizable()
                .ignoresSafeArea()
            VStack(spacing: 60) {
                Image(.logo)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                Button {
                    showMain.toggle()
                } label: {
                    Image(.playButton)
                        .resizable()
                        .frame(width: 150, height: 150)
                        .scaleEffect(showAnimation ? 1.1 : 1)
                }

            }.padding()
        }
        .animation(.bouncy, value: showAnimation)
        .onAppear(perform: {
            Timer.scheduledTimer(withTimeInterval: 0.3, repeats: true) { _ in
                showAnimation.toggle()
            }
        })
        .fullScreenCover(isPresented: $showMain) {
            MainView()
        }
    }
}

#Preview {
    ContentView()
}
