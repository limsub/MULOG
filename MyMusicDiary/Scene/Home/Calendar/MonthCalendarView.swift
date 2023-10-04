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
    var calendar = FSCalendar()

    let headerLabel = {
        let view = UILabel()
        
        view.text = Constant.headerDateFormatter.string(from: Date())  // 초기값
        view.font = .boldSystemFont(ofSize: 24)
        
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
        view.backgroundColor = .red.withAlphaComponent(0.1)
        return view
    }()
    
    func configureCollectionLayout() -> UICollectionViewLayout {
        // item
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1/3), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        // group
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            repeatingSubitem: item,
            count: 3
        )
        group.interItemSpacing = .fixed(10)
        
        // section
        let section = NSCollectionLayoutSection(group: group)
        
        // configuration -> 일단 사용x
//        let configuration = UICollectionViewCompositionalLayoutConfiguration()
        
        // layout
        let layout = UICollectionViewCompositionalLayout(section: section)
//        layout.configuration = configuration
        
        return layout
    }
    
    
    /* set */
    override func setConfigure() {
        super.setConfigure()
        
        addSubview(calendar)
        addSubview(headerLabel)
        addSubview(reloadButton)
        addSubview(plusButton)
        
        addSubview(collectionView)
    }
    override func setConstraints() {
        super.setConstraints()
        
        calendar.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide)
            make.horizontalEdges.equalTo(self.safeAreaLayoutGuide).inset(18)
            make.height.equalTo(self.safeAreaLayoutGuide).multipliedBy(0.6)
        }
        headerLabel.snp.makeConstraints { make in
            make.centerY.equalTo(calendar.calendarHeaderView)
            make.leading.equalTo(calendar.collectionView).inset(18)
        }
        reloadButton.snp.makeConstraints { make in
            make.centerY.equalTo(calendar.calendarHeaderView)
            make.trailing.equalTo(self).inset(32)
            make.width.equalTo(25)
            make.height.equalTo(25)
        }
        plusButton.snp.makeConstraints { make in
            make.centerY.equalTo(calendar.calendarHeaderView)
            
            make.trailing.equalTo(reloadButton.snp.leading).offset(-26)
            make.width.equalTo(25)
            make.height.equalTo(25)
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(calendar.snp.bottom).offset(10)
            make.horizontalEdges.equalTo(self).inset(18)
            make.bottom.equalTo(self.safeAreaLayoutGuide)
        }
    }
    
    override func setting() {
        super.setting()
        
        settingCalendar()
    }
    
    func settingCalendar() {
        calendar.register(CalendarCell.self, forCellReuseIdentifier: CalendarCell.description())
       
        
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