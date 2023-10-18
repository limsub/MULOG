//
//  NotificationUserDefaults+Enum.swift
//  MyMusicDiary
//
//  Created by 임승섭 on 2023/10/18.
//

import Foundation

enum NotificationUserDefaults {
    case isAllowed
    case time
    
    var key: String {
        switch self {
        case .isAllowed:
            return "notificationAllowed"
        case .time:
            return "notificationTime"
        }
    }
}
