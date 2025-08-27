//
//  NavigationManager.swift
//  PenaltyHunter
//
//  Created by Роман Главацкий on 27.08.2025.
//

import Foundation
import SwiftUI

enum Screen: Hashable {
    case settings
    case news
    case quiz
    case ref
    case guide
    case guideInfo(Guide)
}

@MainActor
final class NavigationManager: ObservableObject {
    @Published var path = NavigationPath()
    
       func navigate(to screen: Screen) {
           path.append(screen)
       }
       
       func popToRoot() {
           path.removeLast(path.count)
       }
       
       func popBack(_ steps: Int = 1) {
           guard path.count >= steps else { return }
           path.removeLast(steps)
       }
    
    func navigateToGuideInfo(_ guide: Guide) {
            navigate(to: .guideInfo(guide))
        }
}
