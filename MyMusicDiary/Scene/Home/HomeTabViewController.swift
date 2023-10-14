//
//  HomeTabViewController.swift
//  MyMusicDiary
//
//  Created by 임승섭 on 2023/10/03.
//

import UIKit

extension CALayer {
    // Sketch 스타일의 그림자를 생성한다
    func applyShadow(color: UIColor = .black, alpha: Float = 0.5, x: CGFloat = 0, y: CGFloat = 2, blur: CGFloat = 4) {
        
        shadowColor = color.cgColor
        shadowOpacity = alpha
        shadowOffset = CGSize(width: x, height: y)
        shadowRadius = blur / 2.0
    }
}

extension UITabBar {
    // 기본 그림자 스타일을 초기화해서, 커스텀 스타일을 적용할 준비를 한다
    static func clearShadow() {
        UITabBar.appearance().shadowImage = UIImage()
        UITabBar.appearance().backgroundImage = UIImage()
        UITabBar.appearance().backgroundColor = UIColor.white
    }
}



class HomeTabViewController: UITabBarController {
    
    let pagerVC = PagerViewController()
    
    let calendarVC = MonthCalendarViewController()
    
    let chartVC = ChartTabViewController()
    
    let settingVC = MainSettingViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        
//        UNUserNotificationCenter.current().getPendingNotificationRequests { requests in
//
//            print(requests)
//        }
        
//        NotificationRepository.shared.updateNotifications()
        
        
        view.backgroundColor = .clear
        
        GenreDataModel.shared.fetchGenreChart {
            print("앱의 맨 처음에 실행")
        } // 앱의 맨 처음에 실행
        
        UITabBar.clearShadow()
        tabBar.layer.applyShadow()
        
        tabBar.tintColor = Constant.Color.main2
        
    
        tabBar.layer.cornerRadius = 30
        
        
        
        
        pagerVC.tabBarItem.image = UIImage(systemName: "music.note.house")
        calendarVC.tabBarItem.image = UIImage(systemName: "calendar")
        chartVC.tabBarItem.image = UIImage(systemName: "chart.pie")
        settingVC.tabBarItem.image = UIImage(systemName: "gearshape")
        
        [pagerVC, calendarVC, chartVC, settingVC].forEach { vc in
            vc.tabBarItem.imageInsets = UIEdgeInsets(
                top: -30,
                left: 0,
                bottom: 10,
                right: 0
            )
            vc.title = nil
        }
        
//        let navPager = UINavigationController(rootViewController: pagerVC)
        let navCalendar = UINavigationController(rootViewController: calendarVC)
        let navChart = UINavigationController(rootViewController: chartVC)
        let navSetting = UINavigationController(rootViewController: settingVC)
        
        
        let tabItem = [pagerVC, navCalendar, navChart, navSetting]
        self.viewControllers = tabItem
        
    
        
        setViewControllers(tabItem, animated: true)
    }
}
