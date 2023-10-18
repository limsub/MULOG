//
//  SystemNotification.swift
//  MyMusicDiary
//
//  Created by 임승섭 on 2023/10/18.
//

import Foundation

class SystemNotification {
    static let shared = SystemNotification()
    private init() { }
    
    var isOn = Observable(true)
}
