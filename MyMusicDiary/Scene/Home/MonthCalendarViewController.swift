//
//  MonthCalendarViewController.swift
//  MyMusicDiary
//
//  Created by 임승섭 on 2023/10/02.
//

import UIKit
import FSCalendar
import Kingfisher

class MonthCalendarViewController: BaseViewController {
    
    let repository = MusicItemTableRepository()
    
    var calendar = FSCalendar()
    
    var previousSelectedDate: Date = Date() // 초기값은 의미 없다 (옵셔널로 만들기 싫어서 넣어줌)
    var currentSelectedDate: Date = Date()
    var previousMonthPosition = FSCalendarMonthPosition(rawValue: 1)    // 얘네는 옵셔널
    var currentMonthPosition = FSCalendarMonthPosition(rawValue: 1)
    
    var previousCell: CalendarCell?
    var currentCell: CalendarCell?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        
        calendar.register(CalendarCell.self, forCellReuseIdentifier: CalendarCell.description())
        calendar.delegate = self
        calendar.dataSource = self
        
        
        settingWholeCalendar()
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
        
//        calendar.appearance.borderRadius = 0    // ??
        
        calendar.translatesAutoresizingMaskIntoConstraints = false
        
        calendar.today = nil
//        calendar.allowsSelection = false
        
//        calendar.appearance.eventSelectionColor = .clear
        calendar.appearance.selectionColor = .clear
        
        // 글자 색 조절
        
        
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
        
        print(date, position.rawValue)
        
        cell.backImageView.alpha = (date == currentSelectedDate) ? 1 : 0.5
        
        
        
        if let data = repository.fetchDay(date) {
            // 해당 데이터의 musicList의 첫 번째 데이터를 대표로 띄워줌 (인덱스 0)
            let url = URL(string: data.musicItems[0].smallImageURL!)
            cell.backImageView.kf.setImage(with: url)
            
        } else {
            // 데이터 없으면 빈칸
        }
        
        
        return cell
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
//        let cell = calendar.cell(for: date, at: monthPosition) as! CalendarCell
//        cell.backImageView.alpha = 1
        
//        calendar.reloadData()
        
        
        
        previousSelectedDate = currentSelectedDate
        currentSelectedDate = date
//        previousMonthPosition = currentMonthPosition ?? nil
//        currentMonthPosition = monthPosition
//
//
//
//        guard let previousCell = calendar.cell(for: previousSelectedDate, at: previousMonthPosition!) as? CalendarCell else { return }
//        guard let currentCell = calendar.cell(for: currentSelectedDate, at: currentMonthPosition!) as? CalendarCell else { return }
//
//        previousCell.backImageView.alpha = 0.5
//        currentCell.backImageView.alpha = 1
        
        
        let cell = calendar.cell(for: date, at: monthPosition) as! CalendarCell
        previousCell = currentCell
        currentCell = cell
        
        previousCell?.backImageView.alpha = 0.5
        currentCell?.backImageView.alpha = 1
    }
    

    // 방법 1
    // selectedDate 변수를 하나 만들고, 셀을 클릭하면 그 날로 값을 업데이트함
    // cellFor에서 selectedDate인 셀만 alpha를 1로 주고, 나머지는 0.5로 줌
    // didselect할 때마다 calendar.reloadData()를 해줌
    // -> 문제 : 굳이 필요도 없는데 계속 reloadData를 해줘야 함

    // 방법 2
    // 변수를 두 개 만든다. previousSelectedDate, currentSelectedDate
    // didselect할 때마다 pSD는 alpha 0.5로 해주고, cSD의 alpha를 1로 해준다
    // 하나만 선택할 수 있는 기능이기 때문에 가능한 로직이지 않을까 싶다
    // monthPosition에 대한 변수도 만들어야 한다 -> 이거 로직이 좀 골치아프네
    // 페이지를 넘길 때, monthPosition이 바뀌기 때문에 이 때는 reload를 해주자
    // reload를 해주기 때문에 cellFor에서도 selectedDay인지 확인해서 alpha 조절 -> 차피 오늘 날짜 초기값 주니까 괜찮은듯
    
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        calendar.reloadData()
//        print(calendar.currentPage)
    }
    
    
}


