//
//  TodayDateString.swift
//  MyMusicDiary
//
//  Created by 임승섭 on 2023/11/12.
//

import Foundation
import RxSwift

class TodayDate {
    static let shared = TodayDate()
    
    private init() { }
    
    let todayDateString = BehaviorSubject(value: Date().toString(of: .full))
    
}
