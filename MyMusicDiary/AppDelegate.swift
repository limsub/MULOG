//
//  AppDelegate.swift
//  MyMusicDiary
//
//  Created by 임승섭 on 2023/09/27.
//

import UIKit
import FirebaseCore
import FirebaseAnalytics

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        FirebaseApp.configure()
        Analytics.logEvent(AnalyticsEventAppOpen, parameters: nil)
        
        NetworkMonitor.shared.startMonitoring()
        
        sleep(1)
        
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.badge, .alert, .sound]) { success, error in
            // 맨 처음이라는 점을 분기처리하기 위함 -> 추가적인 UserDefault를 하나 더 넣어준다
            if !UserDefaults.standard.bool(forKey: NotificationUserDefaults.isFirst.key) {
                UserDefaults.standard.set(success, forKey: NotificationUserDefaults.isAllowed.key)
                UserDefaults.standard.set(true, forKey: NotificationUserDefaults.isFirst.key)
            }
            print("시스템 알림 설정 여부 : ", success)
        }
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        if url.scheme == "mulogapp" {
            let alert = UIAlertController(title: "Opened via URL", message: "App was opened via Instagram Story", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            
            
//            window?.rootViewController?.present(alert, animated: true, completion: nil)
            
            
            return true
        }
        return false
    }
}
