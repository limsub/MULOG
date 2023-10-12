//
//  MonthCalendarViewController.swift
//  MyMusicDiary
//
//  Created by 임승섭 on 2023/10/02.
//

import UIKit
import FSCalendar
import Kingfisher

// view - viewCont 구분
// 1. addTarget은 VC에서 (self 들어가는건 VC에서)

class MonthCalendarViewController: BaseViewController {
    
    /* viewModel */
    let viewModel = MonthCalendarViewModel()
    
    /* view */
    let monthView = MonthCalendarView()

    /* dataSource */
    var dataSource: UICollectionViewDiffableDataSource<Int, MusicItemTable>?
    
    var currentPageDate = Date()
    
    @objc
    private func menuButtonClicked() {
        let vc = MonthScrollViewController()
        vc.viewModel.currentPageDate = currentPageDate
        
        navigationController?.pushViewController(vc, animated: true)
    }
    @objc
    private func reloadButtonClicked() {
        monthView.calendar.setCurrentPage(Date(), animated: true)
    }
    @objc
    private func plusButtonClicked() {
        let vc = SaveViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
    
    override func loadView() {
        self.view = monthView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(hexCode: "#F6F6F6")
        
        title = "Calendar"
        navigationController?.navigationBar.prefersLargeTitles = true
        
//        let barbutton = UIBarButtonItem(image: UIImage(systemName: "pencil"), style: .plain, target: self, action: #selector(buttonClicked))
//        navigationItem.rightBarButtonItem = barbutton

        settingMonthCalendarAndCollectionView()
        updateSnapshot()
    }
    
    
    
//    @objc
//    func buttonClicked() {
//        let vc = MonthScrollViewController()
//        vc.currentPageDate = currentPageDate
//        let nav = UINavigationController(rootViewController: vc)
//        nav.modalTransitionStyle = .crossDissolve
//        nav.modalPresentationStyle = .fullScreen
//        present(nav, animated: true)
//    }

    func settingMonthCalendarAndCollectionView() {
        monthView.calendar.delegate = self
        monthView.calendar.dataSource = self
        
        monthView.menuButton.addTarget(self, action: #selector(menuButtonClicked), for: .touchUpInside)
        monthView.reloadButton.addTarget(self, action: #selector(reloadButtonClicked), for: .touchUpInside)
        monthView.plusButton.addTarget(self, action: #selector(plusButtonClicked), for: .touchUpInside)
        
    }
    
    // set
    override func setConfigure() {
        super.setConfigure()
    }

    override func setConstraints() {
        super.setConstraints()
    }
}


extension MonthCalendarViewController: FSCalendarDelegate, FSCalendarDataSource {
    
    func maximumDate(for calendar: FSCalendar) -> Date {
        return Date()
    }

    
    func calendar(_ calendar: FSCalendar, cellFor date: Date, at position: FSCalendarMonthPosition) -> FSCalendarCell {
        guard let cell = calendar.dequeueReusableCell(withIdentifier: CalendarCell.description(), for: date, at: position) as? CalendarCell else { return FSCalendarCell() }
        
        cell.backImageView.alpha = viewModel.isCurrentSelected(date) ? 1 : 0.5
        
        if let thumb = viewModel.firstMusicUrl(date) {
            cell.backImageView.kf.setImage(with: thumb)
        } else {
            
        }
        
        return cell
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        
        // currentSelectedDate 업데이트
        viewModel.updateSelectedDate(date)
        
        if let previousCell = calendar.cell(for: viewModel.previousSelectedDate.value, at: monthPosition) as? CalendarCell {
            previousCell.backImageView.alpha = 0.5
            
        }
        if let currentCell = calendar.cell(for: viewModel.currentSelectedDate.value, at: monthPosition) as? CalendarCell {
            currentCell.backImageView.alpha = 1
        }
        
        // collectionView
        configureDataSource()
        viewModel.updateMusicList(date)
        updateSnapshot()
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
        currentPageDate = calendar.currentPage
        monthView.headerLabel.text = Constant.DateFormat.headerDateFormatter.string(from: currentPageDate)
        
        calendar.reloadData()
    }
}


// * Month - CollectionView
extension MonthCalendarViewController {
    
    func configureDataSource() {
        // cellRegistration
         let cellRegistration = UICollectionView.CellRegistration<MonthCalendarCatalogCell, MusicItemTable> { cell, indexPath, itemIdentifier in
            
             print(indexPath)
             cell.designCell(itemIdentifier)
             
        }
        
        // dataSource
        dataSource = UICollectionViewDiffableDataSource(
            collectionView: monthView.collectionView,
            cellProvider: { collectionView, indexPath, itemIdentifier in
                let cell = collectionView.dequeueConfiguredReusableCell(
                    using: cellRegistration,
                    for: indexPath,
                    item: itemIdentifier
                )
                return cell
            }
        )
        
    }
    
    
    func updateSnapshot() {
        print("update snapshot")
        
        var snapshot = NSDiffableDataSourceSnapshot<Int, MusicItemTable>()
        snapshot.appendSections([0])
        snapshot.appendItems(viewModel.currentMusicList.value)
        dataSource?.apply(snapshot, animatingDifferences: true)
    }
    
}
