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
    
//    let repository = MusicItemTableRepository()
//    var currentSelectedDate: Date = Date()
    
    let viewModel = CalendarViewModel()
    
    var calendar = FSCalendar()
    
    var previousCell: CalendarCell?
    var currentCell: CalendarCell?
    
    // 헤더 타이틀 레이블
    let headerDateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale.init(identifier: "en")
        dateFormatter.dateFormat = "MMMM"
        return dateFormatter
    }()
    
    lazy var headerLabel = {
        let view = UILabel()
        
        view.text = headerDateFormatter.string(from: Date())  // 초기값
        view.font = .boldSystemFont(ofSize: 24)
        
       return view
    }()
    lazy var reloadButton = {
        let view = UIButton(frame: .zero)
        view.setImage(UIImage(named: "reload"), for: .normal)
        view.addTarget(self, action: #selector(reloadButtonClicked), for: .touchUpInside)
        return view
    }()
    lazy var plusButton = {
        let view = UIButton(frame: .zero)
        view.setImage(UIImage(named: "add"), for: .normal)
        view.addTarget(self, action: #selector(plusButtonClicked), for: .touchUpInside)
        return view
    }()
    
    @objc
    private func reloadButtonClicked() {
        calendar.setCurrentPage(Date(), animated: true)
    }
    @objc
    private func plusButtonClicked() {
        let vc = SaveViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
//    lazy var beforeButton = {
//        let view = UIButton()
//        view.setImage(UIImage(systemName: "chevron.left"), for: .normal)
//        view.addTarget(self, action: #selector(beforeButtonClicked), for: .touchUpInside)
//        return view
//    }()
//    lazy var afterButton = {
//        let view = UIButton()
//        view.setImage(UIImage(systemName: "chevron.right"), for: .normal)
//        view.addTarget(self, action: #selector(afterButtonClicked), for: .touchUpInside)
//        return view
//    }()
//
//    private func getBefore(date: Date) -> Date {
//        guard let date = Calendar.current.date(byAdding: .month, value: -1, to: date) else { return Date() }
//        return date
//    }
//    private func getAfter(date: Date) -> Date {
//        guard let date = Calendar.current.date(byAdding: .month, value: 1, to: date) else { return Date() }
//        return date
//    }
//
//    @objc
//    private func beforeButtonClicked() {
//        calendar.setCurrentPage(getBefore(date: calendar.currentPage), animated: true)
//    }
//    @objc
//    private func afterButtonClicked() {
//        calendar.setCurrentPage(getAfter(date: calendar.currentPage), animated: true)
//    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        
        
//        navigationItem.title = "기록"
//        navigationController?.navigationBar.prefersLargeTitles = true
//        navigationItem.largeTitleDisplayMode = .always
        
        
        
        
        settingCalendar()
    }
    
    
    // set
    override func setConfigure() {
        super.setConfigure()
        
        view.addSubview(calendar)
        view.addSubview(headerLabel)
//        view.addSubview(beforeButton)
//        view.addSubview(afterButton)
        view.addSubview(reloadButton)
        view.addSubview(plusButton)
    }
    override func setConstraints() {
        super.setConstraints()
        
        calendar.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(18)
            make.height.equalTo(view.safeAreaLayoutGuide).multipliedBy(0.6)
        }
        headerLabel.snp.makeConstraints { make in
            make.centerY.equalTo(calendar.calendarHeaderView)
            make.leading.equalTo(calendar.collectionView).inset(18)
        }
//        beforeButton.snp.makeConstraints { make in
//            make.centerY.equalTo(calendar.calendarHeaderView)
//            make.width.equalTo(20)
////            make.leading.equalTo(headerLabel.snp.trailing).offset(8)
//            make.centerX.equalTo(view).offset(-20)
//        }
//        afterButton.snp.makeConstraints { make in
//            make.centerY.equalTo(calendar.calendarHeaderView)
//            make.width.equalTo(20)
//            make.leading.equalTo(beforeButton.snp.trailing).offset(8)
//        }
        reloadButton.snp.makeConstraints { make in
            make.centerY.equalTo(calendar.calendarHeaderView)
            make.trailing.equalTo(view).inset(32)
            make.width.equalTo(25)
            make.height.equalTo(25)
        }
        plusButton.snp.makeConstraints { make in
            make.centerY.equalTo(calendar.calendarHeaderView)
            
            make.trailing.equalTo(reloadButton.snp.leading).offset(-26)
            make.width.equalTo(25)
            make.height.equalTo(25)
        }
    }

    private func settingCalendar() {
        // register, 프로토콜 채택
        calendar.register(CalendarCell.self, forCellReuseIdentifier: CalendarCell.description())
        calendar.delegate = self
        calendar.dataSource = self
        
        // 기존의 헤더 가림
        calendar.appearance.headerTitleColor = .clear
        calendar.appearance.headerMinimumDissolvedAlpha = 0.0
        calendar.headerHeight = 66
        
        // 각종 설정
        calendar.today = nil
        calendar.scrollDirection = .horizontal
        calendar.locale = Locale.init(identifier: "en")
        calendar.scope = .month
        calendar.translatesAutoresizingMaskIntoConstraints = false
        calendar.appearance.selectionColor = .clear
        calendar.appearance.weekdayFont = .boldSystemFont(ofSize: 14)
        calendar.appearance.caseOptions = .weekdayUsesSingleUpperCase
        calendar.appearance.weekdayTextColor = .black
        calendar.appearance.titleFont = .boldSystemFont(ofSize: 12)
        calendar.weekdayHeight = 10
        calendar.placeholderType = .none
    }
}


extension MonthCalendarViewController: FSCalendarDelegate, FSCalendarDataSource {
    
    func maximumDate(for calendar: FSCalendar) -> Date {
        return Date()
    }

    
    func calendar(_ calendar: FSCalendar, cellFor date: Date, at position: FSCalendarMonthPosition) -> FSCalendarCell {
        guard let cell = calendar.dequeueReusableCell(withIdentifier: CalendarCell.description(), for: date, at: position) as? CalendarCell else { return FSCalendarCell() }
        
        print(date, position.rawValue)
        
        cell.backImageView.alpha = viewModel.isCurrentSelected(date) ? 1 : 0.5
        
        if let thumb = viewModel.firstMusicUrl(date) {
            cell.backImageView.kf.setImage(with: thumb)
        } else {
            
        }
        
        return cell
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        
        // currentSelectedDate 업데이트
        viewModel.currentSelectedDate.value = date

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
    
    // 10/3
    // 이전/다음 달 날짜는 아예 안나오게 설정해서 복잡하게 로직 짤 필요가 없어졌다
    
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        let currentPage = calendar.currentPage
        headerLabel.text = headerDateFormatter.string(from: currentPage)
        
        calendar.reloadData()
    }
}


