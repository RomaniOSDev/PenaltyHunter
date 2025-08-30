//
//  InfoView.swift
//  PenaltyHunter
//
//  Created by Роман Главацкий on 30.08.2025.
//

import SwiftUI

struct InfoView: View {
    @EnvironmentObject var navManager: NavigationManager
    var body: some View {
        ZStack {
            Image(.mainBack)
                .resizable()
                .ignoresSafeArea()
            VStack {
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
                Image(.infoLabel)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                Spacer()
            }.padding()
        }
        .navigationBarBackButtonHidden()
    }
}

#Preview {
    InfoView()
}
