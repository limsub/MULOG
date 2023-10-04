//
//  HomeTabViewController.swift
//  MyMusicDiary
//
//  Created by 임승섭 on 2023/10/03.
//

import UIKit



class HomeTabViewController: UITabBarController {
    
    let calendarVC = MonthCalendarViewController()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        GenreDataModel.shared.fetchGenreChart() // 앱의 맨 처음에 실행
        
        
        calendarVC.tabBarItem.title = "기록"
        
        calendarVC.tabBarItem.image = UIImage(systemName: "pencil")
        
        let navigationCalendar = UINavigationController(rootViewController: calendarVC)
        
        
        let tabItem = [navigationCalendar]
        self.viewControllers = tabItem
        
        setViewControllers(tabItem, animated: true)
    }
}
