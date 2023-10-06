//
//  ChartViewController.swift
//  MyMusicDiary
//
//  Created by 임승섭 on 2023/10/06.
//

import UIKit


class ChartViewController: BaseViewController {
    
    let repository = ChartDataRepository()
    
    let sub = MusicItemTableRepository()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        
//        let dict = repository.fetchMonthGenreData("202310")
        
//        let dict = repository.fetchWeekGenreData(startDate: "20231001", endDate: "20231001")
        
//        print(dict)
        
        
        print(sub.fetchMusic())
    }
}
