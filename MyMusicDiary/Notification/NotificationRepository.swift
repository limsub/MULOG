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
    
    func printCurrentNotificationList() {
        UNUserNotificationCenter.current().getPendingNotificationRequests { requests in
                for request in requests {
                    print("Identifier: \(request.identifier)")
                    print("Title: \(request.content.title)")
                    print("Body: \(request.content.body)")
                    print("Trigger: \(String(describing: request.trigger))")
                    print("---")
                }
            }
    }

    func delete(_ date: Date) {
        
        print("알림을 제거합니다 : \(date.toString(of: .full))")
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [date.toString(of: .full)])
    }
    
    func updateNotifications() {
        
        // content 세팅
        content.title = String(localized: "오늘의 음악을 기록해주세요!")
        content.body = String(localized: "아직 오늘 음악을 기록하지 않았습니다")
        content.badge = 1
        content.sound = .default
        
        
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
//            
//            print(component.month, component.day, identifier)
            
            UNUserNotificationCenter.current().add(request) { error in
//                print("알림 추가 에러: ", error)
            }
        }
        print("알림 추가 done")
    }
    
    func checkSystemSetting() -> Bool {
        UNUserNotificationCenter.current().requestAuthorization(options: [.badge, .alert, .sound]) { success, error in
            print(success)
        }
        
        return true
    }
    
    // 이걸 굳이 shared 안에 넣기가 좀 그렇다. 요 안에서 shared.updateNotification을 실행시켜야 함..
    // failure 용으로 쓰는 곳 하나 있어서 일단 둔다
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
