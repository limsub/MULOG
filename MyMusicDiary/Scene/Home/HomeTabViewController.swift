//
//  HomeTabViewController.swift
//  MyMusicDiary
//
//  Created by 임승섭 on 2023/10/03.
//

import UIKit



class HomeTabViewController: UITabBarController {
    
    let pagerVC = PagerViewController()
    
    let calendarVC = MonthCalendarViewController()
    
    let chartVC = ChartTabViewController()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        GenreDataModel.shared.fetchGenreChart() // 앱의 맨 처음에 실행
        
        pagerVC.tabBarItem.title = "페이지"
        calendarVC.tabBarItem.title = "기록"
        chartVC.tabBarItem.title = "차트"
        
        pagerVC.tabBarItem.image = UIImage(systemName: "pencil")
        calendarVC.tabBarItem.image = UIImage(systemName: "pencil")
        chartVC.tabBarItem.image = UIImage(systemName: "pencil")
        
        let navPager = UINavigationController(rootViewController: pagerVC)
        let navCalendar = UINavigationController(rootViewController: calendarVC)
        let navChart = UINavigationController(rootViewController: chartVC)
        
        
        
        let tabItem = [navPager, navCalendar, navChart]
        self.viewControllers = tabItem
        
        setViewControllers(tabItem, animated: true)
    }
}
