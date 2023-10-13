//
//  MonthCalendarView.swift
//  MyMusicDiary
//
//  Created by 임승섭 on 2023/10/04.
//

import UIKit
import FSCalendar

class MonthCalendarView: BaseView {
    
    /* calendar */
    let backView = {
        let view = UIView()
        view.backgroundColor = .white
        
        view.layer.cornerRadius = 20
        
        return view
    }()
    
    var calendar = FSCalendar()

    let headerLabel = {
        let view = UILabel()
        
        view.text = Constant.DateFormat.headerDateFormatter.string(from: Date())  // 초기값
        view.font = .boldSystemFont(ofSize: 24)
        
       return view
    }()
    let menuButton = {
        let view = UIButton(frame: .zero)
        view.setImage(UIImage(named: "menu"), for: .normal)
        return view
    }()
    let reloadButton = {
        let view = UIButton(frame: .zero)
        view.setImage(UIImage(named: "reload"), for: .normal)
        return view
    }()
    let plusButton = {
        let view = UIButton(frame: .zero)
        view.setImage(UIImage(named: "add"), for: .normal)
        return view
    }()
    
    
    /* CollectionView */
    lazy var collectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: configureCollectionLayout())
        view.isScrollEnabled = false
        
        view.layer.cornerRadius = 20
        return view
    }()
    
    lazy var modifyButton = {
        let view = UIButton()
        view.setImage(UIImage(named: "pencil"), for: .normal)
        view.backgroundColor = .red
//        view.addTarget(self, action: #selector(modifyButtonClicked), for: .touchUpInside)
        // addTarget은 뷰컨에서
        return view
    }()
    

    
    func configureCollectionLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
        
        let spacing: CGFloat = 10
        
        let width = UIScreen.main.bounds.width - 28 - spacing * 4

        layout.itemSize = CGSize(width: width/3, height: 100)
        layout.sectionInset = UIEdgeInsets(top: spacing, left: spacing, bottom: spacing, right: spacing)
        
        return layout
    }
    
    
    /* set */
    override func setConfigure() {
        super.setConfigure()
        
        addSubview(backView)
        
        addSubview(calendar)
        addSubview(headerLabel)
        addSubview(menuButton)
        addSubview(reloadButton)
        addSubview(plusButton)
        
        addSubview(collectionView)
        addSubview(modifyButton)
        
    }
    override func setConstraints() {
        super.setConstraints()
        
        calendar.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide).inset(20)
            make.horizontalEdges.equalTo(self.safeAreaLayoutGuide).inset(18)
            make.height.equalTo(self.safeAreaLayoutGuide).multipliedBy(0.6)
        }
        headerLabel.snp.makeConstraints { make in
            make.centerY.equalTo(calendar.calendarHeaderView)
            make.leading.equalTo(calendar.collectionView).inset(18)
        }
        menuButton.snp.makeConstraints { make in
            make.centerY.equalTo(calendar.calendarHeaderView)
            make.trailing.equalTo(self).inset(32)
            make.width.equalTo(25)
            make.height.equalTo(25)
        }
        reloadButton.snp.makeConstraints { make in
            make.centerY.equalTo(calendar.calendarHeaderView)
            make.trailing.equalTo(menuButton.snp.leading).offset(-26)
            make.width.equalTo(25)
            make.height.equalTo(25)
        }
        plusButton.snp.makeConstraints { make in
            make.centerY.equalTo(calendar.calendarHeaderView)
            make.trailing.equalTo(reloadButton.snp.leading).offset(-26)
            make.width.equalTo(25)
            make.height.equalTo(25)
        }
        
        backView.snp.makeConstraints { make in
            make.top.equalTo(headerLabel.snp.top).offset(-16)
            make.horizontalEdges.equalTo(self).inset(14)
            make.bottom.equalTo(calendar).offset(8)
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(backView.snp.bottom).offset(12)
            make.horizontalEdges.equalTo(self).inset(14)
            make.bottom.equalTo(self.safeAreaLayoutGuide).inset(12)
        }
        
        modifyButton.snp.makeConstraints { make in
//            make.center.equalTo(self)
            make.trailing.equalTo(collectionView)
            make.bottom.equalTo(collectionView)
            make.size.equalTo(50)
        }
    }
    
    override func setting() {
        super.setting()
        
        settingCalendar()
    }
    
    
    func settingCalendar() {
        
        calendar.register(CalendarCell.self, forCellReuseIdentifier: CalendarCell.description())
        
        // 오늘 날짜 선택
       calendar.setCurrentPage(Date(), animated: true)
       calendar.select(Date())
       
        
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
