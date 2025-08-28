//
//  GuideInfoView.swift
//  PenaltyHunter
//
//  Created by Роман Главацкий on 27.08.2025.
//

import SwiftUI

struct GuideInfoView: View {
    @EnvironmentObject var navManager: NavigationManager
    let guide: Guide
    
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
                Image(guide.largeIcon)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    
                Spacer()
            }
            .padding()
            .navigationBarBackButtonHidden()
        }
    }
}

#Preview {
    GuideInfoView(guide: Guide.addtime)
}
