//
//  MonthCalendarViewController.swift
//  MyMusicDiary
//
//  Created by 임승섭 on 2023/10/02.
//

import UIKit
import FSCalendar

class MonthCalendarViewController: BaseViewController {
    
    var calendar = FSCalendar()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        
        calendar.register(CalendarCell.self, forCellReuseIdentifier: CalendarCell.description())
        calendar.delegate = self
        calendar.dataSource = self
        
        
        
    }
    
    override func setConfigure() {
        super.setConfigure()
        
        view.addSubview(calendar)
    }
    override func setConstraints() {
        super.setConstraints()
        
        calendar.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(view.safeAreaLayoutGuide).multipliedBy(0.7)
        }
    }
}

extension MonthCalendarViewController: FSCalendarDelegate, FSCalendarDataSource {
    
    func settingWholeCalendar() {
        calendar.today = nil
        calendar.scrollDirection = .horizontal
        calendar.locale = Locale.init(identifier: "ko_KR")
        calendar.scope = .month
        
        calendar.appearance.borderRadius = 0    // ??
        
        calendar.translatesAutoresizingMaskIntoConstraints = false
    }
    
//    func configureVisibleCells() {
//        calendar.visibleCells().forEach { cell in
//            let date = self.calendar.date(for: cell)
//            let position = self.calendar.monthPosition(for: cell)
//            
//            self.configureCell(cell, for: date, at: position)
//        }
//    }
    
//    func configureCell(_ cell: FSCalendarCell?, for date: Date?, at position: FSCalendarMonthPosition) {
//        guard let diyCell = cell as? CalendarCell else { return }
//    }
    
    
    func calendar(_ calendar: FSCalendar, cellFor date: Date, at position: FSCalendarMonthPosition) -> FSCalendarCell {
        guard let cell = calendar.dequeueReusableCell(withIdentifier: CalendarCell.description(), for: date, at: position) as? CalendarCell else { return FSCalendarCell() }
        
        return cell
    }
    
//    func calendar(_ calendar: FSCalendar, willDisplay cell: FSCalendarCell, for date: Date, at monthPosition: FSCalendarMonthPosition) {
//        self.configureCell(cell, for: date, at: monthPosition)
//    }
}


