//
//  Help+Enum.swift
//  MyMusicDiary
//
//  Created by 임승섭 on 2023/10/18.
//

import Foundation


// 몇 번째 페이지인지 구분하기 위함
enum HelpType {
    case drag
    case representative
    case delete
}

// 도움말 화면이 나오게 된 이유 -> 다시 보지 않기 버튼 히든처리해주기 위함
enum HelpShowType {
    case firstTime  // 첫 화면에 뜸
    case selectButton   // 도움말 버튼 눌러서 뜸
}
