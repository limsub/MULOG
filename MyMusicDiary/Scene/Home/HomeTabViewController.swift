//
//  HomeTabViewController.swift
//  MyMusicDiary
//
//  Created by 임승섭 on 2023/10/03.
//

import UIKit



class HomeTabViewController: UITabBarController {
    
    let calendarVC = MonthCalendarViewController()
    
    let chartVC = ChartTabViewController()
    
    let pagerVC = PagerViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        GenreDataModel.shared.fetchGenreChart() // 앱의 맨 처음에 실행
        
        
        calendarVC.tabBarItem.title = "기록"
        chartVC.tabBarItem.title = "차트"
        pagerVC.tabBarItem.title = "페이지"
        
        calendarVC.tabBarItem.image = UIImage(systemName: "pencil")
        chartVC.tabBarItem.image = UIImage(systemName: "pencil")
        pagerVC.tabBarItem.image = UIImage(systemName: "pencil")
        
        
        let navCalendar = UINavigationController(rootViewController: calendarVC)
        let navChart = UINavigationController(rootViewController: chartVC)
        let navPager = UINavigationController(rootViewController: pagerVC)
        
        
        let tabItem = [navCalendar, navChart, navPager]
        self.viewControllers = tabItem
        
        setViewControllers(tabItem, animated: true)
    }
}
