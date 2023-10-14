//
//  NotificationRepository.swift
//  MyMusicDiary
//
//  Created by 임승섭 on 2023/10/11.
//

import Foundation
import UIKit

class NotificationRepository {
    
    static let shared = NotificationRepository()
    
    let content = UNMutableNotificationContent()
    

    
    func updateNotifications() {
        
        // content 세팅
        content.title = "오늘의 음악을 기록해주세요!"
        content.body = "아직 오늘 음악을 기록하지 않았습니다"
        
        // UserDefault에 저장된 시간을 가져온다
        let time = UserDefaults.standard.string(forKey: NotificationUserDefaults.time.key)!
        
        guard let hour = Int(time.substring(from: 0, to: 1)) else { return }
        guard let minute =  Int(time.substring(from: 2, to: 3)) else { return }
        
        
        // 기존 request 제거
        print("기존 알림 리스트들을 모두 제거합니다")
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        
        // 새로운 request 등록
        print("새로운 알림 리스트를 등록합니다. 시간은 \(hour)시 \(minute)분 입니다")
        for i in 0...59 {
            guard let notiDay = Calendar.current.date(byAdding: .day, value: i, to: Date()) else { continue }
            let notiDayComponent = Calendar.current.dateComponents([.day, .month, .year], from: notiDay)
            
            var component = DateComponents()
            component.hour = hour
            component.minute = minute
            component.year = notiDayComponent.year
            component.month = notiDayComponent.month
            component.day = notiDayComponent.day
            
            let trigger = UNCalendarNotificationTrigger(
                dateMatching: component,
                repeats: false
            )
            
            let identifier = notiDay.toString(of: .full)
            
            let request = UNNotificationRequest(
                identifier: identifier,
                content: content,
                trigger: trigger
            )
            
            UNUserNotificationCenter.current().add(request) { error in
//                print(error)
            }
            
        }
        
    }
    
    
    func checkSystemSetting(_ successCompletionHandler: @escaping () -> Void, failureCompletionHandler: @escaping () -> Void) {
        UNUserNotificationCenter.current().requestAuthorization(options: [.badge, .alert, .sound]) { success, error in
            
            if success {
                successCompletionHandler()
            } else {
                failureCompletionHandler()
            }
        }
    }
}
