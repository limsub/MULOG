//
//  GenreColor+Enum.swift
//  MyMusicDiary
//
//  Created by 임승섭 on 2023/10/11.
//

import Foundation

enum GenreColor {
    case kpop
    case pop
    case ost
    case hiphop
    case rb
    case dance
    case electronic
    case rock
    case alternative
    case singASongWriter
    
    var colorKoreanName: String {
        switch self {
        case .kpop:
            return "K-Pop"
        case .pop:
            return "팝"
        case .ost:
            return "OST"
        case .hiphop:
            return "힙합/랩"
        case .rb:
            return "R&B/소울"
        case .dance:
            return "댄스"
        case .electronic:
            return "일렉트로닉"
        case .rock:
            return "록"
        case .alternative:
            return "얼터너티브"
        case .singASongWriter:
            return "싱어송라이터"
        }
    }
    
    var colorHexCode: String {
        switch self {
        case .kpop:
            return "#000000"
        case .pop:
            return "#800000"
        case .ost:
            return "#2E4053"
        case .hiphop:
            return "#701C28"
        case .rb:
            return "#4B0082"
        case .dance:
            return "#6e9bf6"
        case .electronic:
            return "#7ff9cd"
        case .rock:
            return "#ea6e83"
        case .alternative:
            return "#c4abc0"
        case .singASongWriter:
            return "#50388c"
        }
    }
}
