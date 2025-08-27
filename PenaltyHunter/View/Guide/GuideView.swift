//
//  GuideView.swift
//  PenaltyHunter
//
//  Created by Роман Главацкий on 27.08.2025.
//

import SwiftUI

struct GuideView: View {
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
                ScrollView {
                    LazyVGrid(columns: [GridItem(), GridItem(), GridItem()]) {
                        ForEach(Guide.allCases, id: \.self) { guide in
                            Button {
                                navManager.navigateToGuideInfo(guide)
                            } label: {
                                Image(guide.smallIcon)
                                    .resizable()
                                    .frame(height: 130)
                                    .aspectRatio(contentMode: .fit)
                            }

                        }
                    }
                }
            }.padding()
        }
        .navigationBarBackButtonHidden()
    }
}

#Preview {
    GuideView()
}
