//
//  MonthCalendarView.swift
//  MyMusicDiary
//
//  Created by 임승섭 on 2023/10/04.
//

import UIKit
import FSCalendar



class MonthCalendarView: BaseView {
    
    /* no data */
    let noDataViewToday = NoDataView(
        imageName: "nodata_headphone",
        labelStatement: String(localized: "아직 오늘의 음악을 기록하지 않았습니다\n플러스 버튼을 눌러서 음악을 기록해주세요"),
        imageSize: 100
    )
    let noDataViewPastDay = NoDataView(
        imageName: "nodata_headphone",
        labelStatement: String(localized: "해당 날짜에 기록한 음악이 없습니다"),
        imageSize: 100
    )
    
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
        let view = UIButton()
        view.showsMenuAsPrimaryAction = true
        view.setImage(UIImage(named: "monthCalendarView_menuDown2"), for: .normal)
        return view
    }()
    let reloadBackLabel = {
        let view = UILabel()
        view.text = Date().toString(of: .singleDay)
        
        view.font = .boldSystemFont(ofSize: 12)
        view.textAlignment = .center
        return view
    }()
    let reloadButton = {
        let view = UIButton(frame: .zero)
        view.setImage(UIImage(named: "monthCalendarView_todayButton"), for: .normal)
        view.backgroundColor = .clear
        return view
    }()
    let hideButton = {
        let view = UIButton()
        view.setImage(UIImage(named: "hide"), for: .normal)
        view.setImage(UIImage(named: "monthCalendarView_showAlbums"), for: .selected)
        return view
    }()
    let plusButton = {
        let view = UIButton(frame: .zero)
        view.setImage(UIImage(named: "add"), for: .normal)
        return view
    }()
    let modifyButton = {
        let view = UIButton(frame: .zero)
        view.setImage(UIImage(named: "monthCalendarView_modifyButton"), for: .normal)

        return view
    }()
    
    /* CollectionView */
    lazy var collectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: createMonthBottomLayout())
        view.isScrollEnabled = false
        
        view.layer.cornerRadius = 20

        return view
    }()
    



    
    private func createMonthBottomLayout() -> UICollectionViewLayout {
        let spacing: CGFloat = 10
        
        let layout = UICollectionViewFlowLayout()

        let width = UIScreen.main.bounds.width - 32 - spacing * 4

        layout.itemSize = CGSize(width: width/3, height: 100)
        layout.sectionInset = UIEdgeInsets(top: spacing, left: spacing, bottom: spacing, right: spacing)
        layout.minimumLineSpacing = spacing
        layout.minimumInteritemSpacing = spacing
        
        return layout
    }
    
    
    /* set */
    override func setConfigure() {
        super.setConfigure()
        
        addSubview(backView)
        
        addSubview(calendar)
        addSubview(headerLabel)
        addSubview(menuButton)
        
        addSubview(reloadBackLabel)
        addSubview(reloadButton)
        
        addSubview(hideButton)
        addSubview(plusButton)
        
        addSubview(collectionView)
        addSubview(modifyButton)
        
        collectionView.addSubview(noDataViewToday)
        collectionView.addSubview(noDataViewPastDay)
    }
    override func setConstraints() {
        super.setConstraints()
        
        calendar.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide)
            make.horizontalEdges.equalTo(self.safeAreaLayoutGuide).inset(18)
            make.height.equalTo(self.safeAreaLayoutGuide).multipliedBy(0.58)
        }
        backView.snp.makeConstraints { make in
            make.top.equalTo(headerLabel.snp.top).offset(-16)
            make.horizontalEdges.equalTo(self).inset(14)
            make.bottom.equalTo(calendar).offset(8)
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
        reloadBackLabel.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(reloadButton).inset(1)
            make.bottom.equalTo(reloadButton).inset(1)
        }
        hideButton.snp.makeConstraints { make in
            make.centerY.equalTo(calendar.calendarHeaderView)
            make.trailing.equalTo(reloadButton.snp.leading).offset(-26)
            make.width.equalTo(25)
            make.height.equalTo(25)
        }
        plusButton.snp.makeConstraints { make in
            make.centerY.equalTo(calendar.calendarHeaderView)
            make.trailing.equalTo(hideButton.snp.leading).offset(-26)
            make.width.equalTo(25)
            make.height.equalTo(25)
        }
        modifyButton.snp.makeConstraints { make in
            make.centerY.equalTo(calendar.calendarHeaderView)
            make.trailing.equalTo(hideButton.snp.leading).offset(-26)
            make.width.equalTo(25)
            make.height.equalTo(25)
        }
        
        
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(backView.snp.bottom).offset(12)
            make.horizontalEdges.equalTo(self).inset(14)
            make.bottom.equalTo(self.safeAreaLayoutGuide).inset(12)
        }
        
//        modifyButton.snp.makeConstraints { make in
////            make.center.equalTo(self)
////            make.trailing.equalTo(collectionView).inset(8)
//
//
//            make.centerX.equalTo(self)
//            make.bottom.equalTo(collectionView).inset(8)
//
//            make.width.equalTo(80)
//            make.height.equalTo(40)
//
////            make.size.equalTo(40)
//        }
        
        noDataViewToday.snp.makeConstraints { make in
            make.center.equalTo(collectionView)
            make.height.equalTo(collectionView.snp.height).multipliedBy(0.8)
        }
        noDataViewPastDay.snp.makeConstraints { make in
            make.center.equalTo(collectionView)
            make.height.equalTo(collectionView.snp.height).multipliedBy(0.8)
        }
    }
    
    override func setting() {
        super.setting()
        
        settingCalendar()
        setInstaShareButton()
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
        
        // 선택 날짜 색상
        calendar.appearance.titleSelectionColor = .lightGray.withAlphaComponent(0.5)
        
        // 각종 설정
        calendar.today = nil
        calendar.scrollDirection = .horizontal
        calendar.locale = Locale.init(identifier: "en") // TODO: Localization 필요?
        calendar.scope = .month
        calendar.translatesAutoresizingMaskIntoConstraints = false
        calendar.appearance.selectionColor = .clear
        calendar.appearance.weekdayFont = .boldSystemFont(ofSize: 14)
        calendar.appearance.caseOptions = .weekdayUsesSingleUpperCase
        calendar.appearance.weekdayTextColor = .black
        calendar.appearance.titleFont = .boldSystemFont(ofSize: 12)
        calendar.weekdayHeight = 10
        calendar.placeholderType = .none
        
        // reloadBackLabel 데이터 설정
        reloadBackLabel.text = Date().toString(of: .singleDay)
    }
    
    
    
    // 24.07.15 인스타 스토리 공유하기 버튼
    lazy var instaShareButton: UIButton = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "instagram")?.withTintColor(Constant.Color.main2)

        
        let view = UIButton()
        view.backgroundColor = .clear
        
        view.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.size.equalTo(30)
            make.center.equalToSuperview()
        }
        
        return view
    }()
    func setInstaShareButton() {
        
        // collectionView에 올리면 레이아웃을 못잡는다. 그냥 view에 올린다
        self.addSubview(instaShareButton)
        instaShareButton.snp.makeConstraints { make in
            make.size.equalTo(40)
            
            make.bottom.equalTo(self.safeAreaLayoutGuide).inset(18) // 12 (collectionView) + 4 (padding)
            make.trailing.equalTo(self).inset(20) // 14 + 4
        }
    }
}
