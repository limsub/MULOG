//
//  MonthCalendarViewController.swift
//  MyMusicDiary
//
//  Created by 임승섭 on 2023/10/02.
//

import UIKit
import FSCalendar
import Kingfisher
import MusicKit

// view - viewCont 구분
// 1. addTarget은 VC에서 (self 들어가는건 VC에서)


class MonthCalendarViewController: BaseViewController {
    
    var allShow = false
    
    /* viewModel */
    let viewModel = MonthCalendarViewModel()
    
    /* view */
    let monthView = MonthCalendarView()

    /* dataSource */
    var dataSource: UICollectionViewDiffableDataSource<Int, MusicItemTable>?
    
    // 캘린더 넘길 때 타이틀 텍스트 변화 + MonthScrollView 넘어갈 때 값전달
    var currentPageDate = Date()
    
    
    /* calendar 상단 버튼 + 수정 버튼 */
    func settingMenuButton() {
//        let favorite = UIAction(title: "기록 수정하기", image: UIImage(named: "monthCalendarView_modifyButton"), handler: { _ in print("즐겨찾기") })
//        let favorite1 = UIAction(title: "스크롤 화면으로 보기", image: UIImage(named: "monthCalendarView_menuDown2"), handler: { _ in print("즐겨찾기") })
//        let favorite2 = UIAction(title: "앨범 커버만 보기", image: UIImage(named: "monthCalendarView_showOnlyAlbums"), handler: { _ in print("즐겨찾기") })
//        let favorite3 = UIAction(title: "오늘로 돌아가기", image: UIImage(named: "monthCalendarView_todayButton2"), handler: { _ in
//
//            let kakaoTalk = "https://music.apple.com/kr/album/you-me/1709257167?i=1709257170"
////            let kakaoTalk = "https://music.youtube.com/playlist?list=OLAK5uy_nrM4rmY7_viP2CGPMXGr7VPXGv-pzrc0E"
////            let kakaoTalk = "https://www.melon.com/album/music.htm?albumId=354437"
////            let kakaoTalk = "https://kko.to/aS9ku2_xm4"
//
//
//            //URL 인스턴스를 만들어 주는 단계
//            let kakaoTalkURL = NSURL(string: kakaoTalk)
//
//
//            //canOpenURL(_:) 메소드를 통해서 URL 체계를 처리하는 데 앱을 사용할 수 있는지 여부를 확인
//            if (UIApplication.shared.canOpenURL(kakaoTalkURL! as URL)) {
//
//                //open(_:options:completionHandler:) 메소드를 호출해서 카카오톡 앱 열기
//                UIApplication.shared.open(kakaoTalkURL! as URL)
//            }
//            //사용 불가능한 URLScheme일 때(카카오톡이 설치되지 않았을 경우)
//            else {
//                print("No kakaotalk installed.")
//            }
//
//
//        })
//
//        monthView.menuButton.menu = UIMenu(
//            children: [
//                favorite,
//                favorite1,
//                favorite2,
//                favorite3
//            ]
//        )
//        favorite.title = "hi"
//
    }
    
    @objc
    private func menuButtonClicked() {  // 화면 전환
//        let vc = MonthScrollViewController()
//        vc.viewModel.currentPageDate = currentPageDate
//        navigationController?.pushViewController(vc, animated: true)
    }
    @objc
    private func reloadButtonClicked() {    // 오늘 날짜 선택
        // 0. UI
        monthView.calendar.setCurrentPage(Date(), animated: true)
        monthView.calendar.select(Date())
        
        
        // 1. selected date를 오늘 날짜로 업데이트한다
        viewModel.updateSelectedDate(Date())
        
        // 2 - 1. 캘린더 reload -> currentSelectedDate 기준으로 배경 alpha값 변경
        monthView.calendar.reloadData()
        
        // 2 - 2. 컬렉션뷰 reload -> currentSelectedDated 기준으로 data 다시 부르고, collectionView reload (update snapshot)
        viewModel.updateMusicList()
        updateSnapshot()
    }
    @objc
    private func plusButtonClicked() {
        Task {
            let status = await MusicAuthorization.request()
            
            switch status {
            case .notDetermined, .denied, .restricted:
                guard let url = URL(string: UIApplication.openSettingsURLString) else { return }
                self.showAlert("미디어 및 Apple Music에 대한 접근이 허용되어 있지 않습니다", message: "접근 권한이 없으면 음악 검색이 불가능합니다. 권한을 허용해주세요", okTitle: "설정으로 이동") {
                    if UIApplication.shared.canOpenURL(url) {
                        UIApplication.shared.open(url)
                    }
                }
            case .authorized:
                let vc = SaveViewController()
                // 값전달 1. 수정추가 enum, 2. 데이터 배열, 3. 날짜
                vc.viewModel.saveType = .addData        // 1
                vc.viewModel.preMusicList.value = []    // 2
                vc.viewModel.currentDate = viewModel.currentSelectedDate.value // 3
                
                // 저장 버튼 눌렀을 때 액션 연결시켜주기 위한 delegate
                vc.delegate = self
                navigationController?.pushViewController(vc, animated: true)
            @unknown default:
                break
            }
        }
    }
    @objc
    func modifyButtonClicked() {
        Task {
            let status = await MusicAuthorization.request()
            
            switch status {
            case .notDetermined, .denied, .restricted:
                guard let url = URL(string: UIApplication.openSettingsURLString) else { return }
                self.showAlert("미디어 및 Apple Music에 대한 접근이 허용되어 있지 않습니다", message: "접근 권한이 없으면 음악 검색이 불가능합니다. 권한을 허용해주세요", okTitle: "설정으로 이동") {
                    if UIApplication.shared.canOpenURL(url) {
                        UIApplication.shared.open(url)
                    }
                }
            case .authorized:
                let vc = SaveViewController()
                // 값전달 1. 수정추가 enum, 2. 데이터 배열, 3. 날짜
                vc.viewModel.saveType = .modifyData        // 1
                vc.viewModel.preMusicList.value = viewModel.currentMusicList.value.map { MusicItem($0) }    // 2
                vc.viewModel.currentDate = viewModel.currentSelectedDate.value // 3
                
                // 저장 버튼 눌렀을 때 액션 연결시켜주기 위한 delegate
                vc.delegate = self
                navigationController?.pushViewController(vc, animated: true)
                
                
            @unknown default:
                break
            }
        }
    }
    @objc
    func hideButtonClicked() {
        allShow.toggle()
        monthView.hideButton.isSelected = allShow
        monthView.calendar.reloadData()
    }
    
    
    func bindData() {
        viewModel.currentSelectedDate.bind { [weak self] _ in
            self?.checkPlusModifyButton()
            self?.checkShowNoDataView()
        }
    }
    
    override func loadView() {
        self.view = monthView
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Constant.Color.background
        
        bindData()

        settingMenuButton()
        
        settingMonthView()
        
        settingNavigation()
        configureDataSource()
        
        monthView.calendar.reloadData()
        viewModel.updateMusicList()
        updateSnapshot()
        

        
        checkShowNoDataView()
        
        
        // 반대로 생각. left -> 이후 날짜 / right -> 이전 날짜
        let afterSwipeRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(afterSwipeAction(_:)))
        let beforeSwipeRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(beforeSwipeAction(_:)))
        afterSwipeRecognizer.direction = .left
        beforeSwipeRecognizer.direction = .right
        
        monthView.collectionView.addGestureRecognizer(afterSwipeRecognizer)
        monthView.collectionView.addGestureRecognizer(beforeSwipeRecognizer)
    }
    
    @objc
    func afterSwipeAction(_ sender: UISwipeGestureRecognizer) {
        print("left")
        
        // 1. selectedDate 변경
        viewModel.updateAfterSelectedDate()
        // 2. calendar selected date 변경 + 이미지 흐리게 처리
        monthView.calendar.select(viewModel.currentSelectedDate.value)
        monthView.calendar.reloadData()
        // 3. collectionView updatesnapshot
        viewModel.updateMusicList()
        updateSnapshot()
        checkShowNoDataView()
    }
    @objc
    func beforeSwipeAction(_ sender: UISwipeGestureRecognizer) {
        print("right")
        // 1. selectedDate 변경
        viewModel.updateBeforeSelectedDate()
        // 2. calendar selected date 변경 + 이미지 흐리게 처리
        monthView.calendar.select(viewModel.currentSelectedDate.value)
        monthView.calendar.reloadData()
        // 3. collectionView updatesnapshot
        viewModel.updateMusicList()
        updateSnapshot()
        checkShowNoDataView()
    }
  
    
    // 데이터 수정한 후 바로 반영될 수 있도록 설정
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        checkPlusModifyButton()
        checkShowNoDataView()
    }
    

    
    func settingNavigation() {
        // prefersLargeTitles 가 true인 상태에서,
        // largeTitleDisplayMode 로 현재 뷰컨의 nav 상태를 결정할 수 있다
        navigationItem.title = "Calendar"
        navigationController?.navigationBar.prefersLargeTitles = true
        
//        let monthScrollViewButton = UIBarButtonItem(image: UIImage(named: "monthCalendarView_menuDown"), style: .plain, target: self, action: #selector(monthScrollViewButtonClicked))
//        navigationItem.rightBarButtonItem = monthScrollViewButton
        
        
        
    }
    
    @objc
    func monthScrollViewButtonClicked() {
        let vc = MonthScrollViewController()
        vc.viewModel.currentPageDate = currentPageDate
        navigationController?.pushViewController(vc, animated: true)
    }
    
    

    // monthView 안에 있는 캘린더 프로토콜 연결 및 addtarget 연겨
    func settingMonthView() {
        
        monthView.calendar.delegate = self
        monthView.calendar.dataSource = self
        
        monthView.collectionView.delegate = self
        
        monthView.menuButton.addTarget(self, action: #selector(monthScrollViewButtonClicked), for: .touchUpInside)
        monthView.reloadButton.addTarget(self, action: #selector(reloadButtonClicked), for: .touchUpInside)
        monthView.hideButton.addTarget(self, action: #selector(hideButtonClicked), for: .touchUpInside)
        monthView.plusButton.addTarget(self, action: #selector(plusButtonClicked), for: .touchUpInside)
        monthView.modifyButton.addTarget(self, action: #selector(modifyButtonClicked), for: .touchUpInside)
        
    }
}


extension MonthCalendarViewController: FSCalendarDelegate, FSCalendarDataSource {
    
    func maximumDate(for calendar: FSCalendar) -> Date {
//        print(#function)
        return Date()
    }

    
    func calendar(_ calendar: FSCalendar, cellFor date: Date, at position: FSCalendarMonthPosition) -> FSCalendarCell {
  
        guard let cell = calendar.dequeueReusableCell(withIdentifier: CalendarCell.description(), for: date, at: position) as? CalendarCell else { return FSCalendarCell() }
        
        cell.titleLabel.isHidden = false
        cell.backImageView.image = nil
        
        viewModel.fetchArtwork(date) { url in
            cell.backImageView.kf.setImage(with: url)
            print(date)
        }
        
        cell.backImageView.alpha = viewModel.isCurrentSelected(date) ? 1 : 0.5
        
        
        if allShow {
            cell.titleLabel.isHidden = true
            cell.backImageView.alpha = 1
        }
        
        return cell
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        
//        print(#function, date)
        
        // currentSelectedDate 업데이트
        viewModel.updateSelectedDate(date)
        
        if !allShow {
            // calendar 업데이트 (reloadData 쓰는 것보다 나을 듯)
            if let previousCell = calendar.cell(for: viewModel.previousSelectedDate.value, at: monthPosition) as? CalendarCell {
                previousCell.backImageView.alpha = 0.5
            }
            if let currentCell = calendar.cell(for: viewModel.currentSelectedDate.value, at: monthPosition) as? CalendarCell {
                currentCell.backImageView.alpha = 1
            }
        }
        
        // collectionView
        viewModel.updateMusicList()
        updateSnapshot()
        checkShowNoDataView()


    }
    
    
    
    /* 셀을 선택할 때 배경색 변화시켜주는 로직 */
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
    
    
    // 캘린더 넘길 때, 타이틀 텍스트 바뀌게 하기 위함
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        currentPageDate = calendar.currentPage
        monthView.headerLabel.text = Constant.DateFormat.headerDateFormatter.string(from: currentPageDate)
        
        calendar.reloadData()
    }
}




// * CollectionView
extension MonthCalendarViewController {
    
    func configureDataSource() {
        // cellRegistration
         let cellRegistration = UICollectionView.CellRegistration<MonthCalendarCatalogCell, MusicItemTable> { cell, indexPath, itemIdentifier in

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
        var snapshot = NSDiffableDataSourceSnapshot<Int, MusicItemTable>()
        snapshot.appendSections([0])
        snapshot.appendItems(viewModel.currentMusicList.value)
        dataSource?.apply(snapshot, animatingDifferences: true)
    }
}

extension MonthCalendarViewController {
    // 추가 버튼, 수정 버튼, 빈 공간 결정하기
    func checkPlusModifyButton() {
        // 추가 : 오늘 날짜 선택 + 해당 날짜 일기 x
        // 수정 : (1). 오늘 날짜 선택 + 해당 날짜 일기 o
        //       (2). 이전 날짜 선택 + 해당 날짜 일기 o
        // 빈 공간 : 이전 날짜 선택 + 해당 날짜 일기 x
        
        // 분기 처리
        // 1. 선택된 날짜에 일기 있는지 -> true => 수정
        // false => 2. 오늘 날짜를 선택했는지 -> true => 추가
        //                                 false => 빈 공간
        
        // 실행해야 하는 시점
        // 1. viewWillAppear, 2. didSelect, 3. reloadButtonClicked
        // 2, 3 대신, currentSelectedDate에 bind로 걸어버리자
        
        if viewModel.isCurrentSelectedDateHaveData() {
            print("선택된 날짜에 이미 일기가 있습니다. 수정 버튼을 띄워야 합니다")
            monthView.plusButton.isHidden = true
            monthView.modifyButton.isHidden = false
        } else {
            print("선택된 날짜에 일기가 없습니다. 다음 분기 처리로 넘어갑니다", terminator: " -> ")
            if viewModel.isCurrentSelectedDateToday() {
                print("선택된 날짜가 오늘 날짜입니다. 추가 버튼을 띄워야 합니다")
                monthView.plusButton.isHidden = false
                monthView.modifyButton.isHidden = true
            } else {
                print("선택된 날짜가 이전 날짜입니다. 빈 공간으로 두어야 합니다")
                monthView.plusButton.isHidden = true
                monthView.modifyButton.isHidden = true
            }
        }
    }
    
    // 기록한 음악이 없습니다 기본 뷰
    func checkShowNoDataView() {
        // 1. 선택한 날짜에 데이터가 없는지
        // 2. 선택한 날짜가 오늘 날짜인지
        
        // 위 함수(plus, modify button)과 동일한 시점에 실행시켜주기
        
        if !viewModel.isCurrentSelectedDateHaveData() {
            if viewModel.isCurrentSelectedDateToday() {
                monthView.noDataViewToday.isHidden = false
                monthView.noDataViewPastDay.isHidden = true
            } else {
                monthView.noDataViewToday.isHidden = true
                monthView.noDataViewPastDay.isHidden = false
            }
        } else {
            monthView.noDataViewToday.isHidden = true
            monthView.noDataViewPastDay.isHidden = true
        }
    }
}


extension MonthCalendarViewController: ReloadProtocol {
    func update() {
        monthView.calendar.reloadData()
        viewModel.updateMusicList()
        updateSnapshot()
        checkShowNoDataView()
        checkPlusModifyButton() // 이게 있어야 하려나
    }
}



extension MonthCalendarViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        // 1. 현재 musicList의 indexPath에 접근
        // 2. 걔의 url or title 가져옴
        
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        guard let appleMusicURL = viewModel.currentMusicList.value[indexPath.item].appleMusicURL else {
            showSingleAlert("음악 데이터가 부족해서 앱을 실행할 수 없습니다", message: "")
            return }
        let appleMusic = UIAlertAction(title: "Apple Music 앱에서 듣기", style: .default) { _ in
//            URL 인스턴스를 만들어 주는 단계
                let kakaoTalkURL = NSURL(string: appleMusicURL)
    
    
                //canOpenURL(_:) 메소드를 통해서 URL 체계를 처리하는 데 앱을 사용할 수 있는지 여부를 확인
                if (UIApplication.shared.canOpenURL(kakaoTalkURL! as URL)) {
    
                    //open(_:options:completionHandler:) 메소드를 호출해서 카카오톡 앱 열기
                    UIApplication.shared.open(kakaoTalkURL! as URL)
                }
                //사용 불가능한 URLScheme일 때(카카오톡이 설치되지 않았을 경우)
                else {
                    print("No kakaotalk installed.")
                }
    
    
            }
        
        
        let title = viewModel.currentMusicList.value[indexPath.item].name
        let artist = viewModel.currentMusicList.value[indexPath.item].artist
        let youtubeMusicURL = "https://music.youtube.com/search?q=\(title) \(artist)"
         let encodedStr = youtubeMusicURL.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        
        
        let youtubeMusic = UIAlertAction(title: "Youtube Music 앱에서 듣기", style: .default) { _ in
            let kakaoTalkURL = NSURL(string: encodedStr)


            //canOpenURL(_:) 메소드를 통해서 URL 체계를 처리하는 데 앱을 사용할 수 있는지 여부를 확인
            if (UIApplication.shared.canOpenURL(kakaoTalkURL! as URL)) {

                //open(_:options:completionHandler:) 메소드를 호출해서 카카오톡 앱 열기
                UIApplication.shared.open(kakaoTalkURL! as URL)
            }
            //사용 불가능한 URLScheme일 때(카카오톡이 설치되지 않았을 경우)
            else {
                print("No kakaotalk installed.")
            }


        }
        
        let cancel = UIAlertAction(title: "취소", style: .cancel)
        
        alert.addAction(cancel)
        alert.addAction(appleMusic)
        alert.addAction(youtubeMusic)
        
        present(alert, animated: true)
        
    }
}
