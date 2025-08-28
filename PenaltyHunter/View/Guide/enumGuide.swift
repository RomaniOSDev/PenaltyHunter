//
//  enumGuide.swift
//  PenaltyHunter
//
//  Created by Роман Главацкий on 27.08.2025.
//

enum Guide: CaseIterable {
    case kik
    case ball
    case scroll
    case fouls
    case misconducts
    case freeKicks
    case throwIns
    case goalkicks
    case yellowCards
    case advantage
    case substitutions
    case addtime
    
    var smallIcon: ImageResource {
        switch self {
            
        case .kik:
            return .skick
        case .ball:
            return .sball
        case .scroll:
            return .sscrolling
        case .fouls:
            return .sfouls
        case .misconducts:
            return .smisconduct
        case .freeKicks:
            return .sfreekick
        case .throwIns:
            return .strowin
        case .goalkicks:
            return .sgoalkick
        case .yellowCards:
            return .syellow
        case .advantage:
            return .sadventage
        case .substitutions:
            return .ssubstitutions
        case .addtime:
            return .saddtime
        }
    }
    
    var largeIcon: ImageResource {
        switch self {
            
        
        case .kik:
            return .bkick
        case .ball:
            return .bball
        case .scroll:
            return .bscroll
        case .fouls:
            return .bfouls
        case .misconducts:
            return.bmisconduct
        case .freeKicks:
            return .bfree
        case .throwIns:
            return .bthrow
        case .goalkicks:
            return .bgoalkick
        case .yellowCards:
            return .byellow
        case .advantage:
            return .badvantage
        case .substitutions:
            return .bsubstitutiion
        case .addtime:
            return .baddtime
        }
    }
}
