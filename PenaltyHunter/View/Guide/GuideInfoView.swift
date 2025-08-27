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
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

#Preview {
    GuideInfoView(guide: Guide.addtime)
}
