//
//  SceneDelegate.swift
//  MyMusicDiary
//
//  Created by 임승섭 on 2023/09/27.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        // 혹시 알림 시간이 설정되어 있지 않으면, 디폴트 21:00으로 넣어준다.
        if UserDefaults.standard.string(forKey: NotificationUserDefaults.time.key) == nil {
            print("기본 알림 시간이 설정되어 있지 않습니다. 21시 00분으로 설정합니다")
            UserDefaults.standard.set("2100", forKey: NotificationUserDefaults.time.key)
        }
        
        // 혹시 알림은 켜져 있는데, 남은 알림 리스트가 15개 미만이면, 알림 리스트를 업데이트 시켜준다
        // 시스템 알림이 꺼져 있으면 어차피 알림이 가지 않기 때문에, 시스템 알림 여부는 고려하지 않는다
        if UserDefaults.standard.bool(forKey: NotificationUserDefaults.isAllowed.key) {
            
            UNUserNotificationCenter.current().getPendingNotificationRequests { requests in
                
                if requests.count < 15 {
                    print("등록된 알림 리스트가 15개 미만이기 때문에 새롭게 리스트를 등록합니다")
                    NotificationRepository.shared.updateNotifications()
                }
            }
        }
        
  
        
        
        guard let scene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: scene)
        let vc = HomeTabViewController()
        window?.rootViewController = UINavigationController(rootViewController: vc)
        window?.makeKeyAndVisible()
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
        
//        UIApplication.shared.applicationIconBadgeNumber = 9
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


}

