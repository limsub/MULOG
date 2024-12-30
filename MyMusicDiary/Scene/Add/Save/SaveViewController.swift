//
//  SaveViewController.swift
//  MyMusicDiary
//
//  Created by 임승섭 on 2023/09/27.
//

import UIKit
import GoogleMobileAds

// collectionView index 기반으로 구현

// 저장 버튼 눌렀을 때 이전화면 캘린더, 컬렉션뷰 리로드시켜주기 위함
protocol ReloadProtocol: AnyObject {
    func update()
}

// Save 화면의 데이터를 업데이트
protocol UpdateDataDelegate: AnyObject {
    func updateMusicList(item: MusicItem)
}


enum helpView: String {
    case showHelpView
}

class SaveViewController: BaseViewController {
    
    weak var delegate: ReloadProtocol?
    
    private var interstitial: GADInterstitialAd?    // Google AdMob

    /* 뷰모델 */
    let viewModel = SaveViewModel()
    
    /* 뷰 */
    let saveView = SaveView()
    
    /* setting */
    func settingSaveView() {
        saveView.fakeButton.addTarget(self, action: #selector(searchBarClicked), for: .touchUpInside)
        
//        saveView.genreCollectionView.delegate = self
//        saveView.genreCollectionView.dataSource = self
        
        saveView.helpButton.addTarget(self, action: #selector(helpButtonClicked), for: .touchUpInside)
        
        saveView.collectionView.delegate = self
        saveView.collectionView.dataSource = self
        saveView.collectionView.dragDelegate = self
        saveView.collectionView.dropDelegate = self
        saveView.collectionView.dragInteractionEnabled = true
        
    }
    
    func settingNavigation() {
        switch viewModel.saveType {
        case .addData:
            navigationItem.title = String(localized: "음악 기록하기")
        case .modifyData:
            navigationItem.title = String(localized: "음악 수정하기")
        default:
            navigationItem.title = String(localized: "음악 기록")
        }
        
        navigationItem.largeTitleDisplayMode = .never
        
        let saveButton = UIBarButtonItem(title: String(localized: "저장"), style: .plain, target: self, action: #selector(saveButtonClicked))
        navigationItem.rightBarButtonItem = saveButton
    }
    
    func settingScrollView() {
        saveView.todayMusicLabel.text = viewModel.makeDateLabelString()
    }
    
    /* bind */
    
    
    
    
    /* addTarget function */
    @objc
    func searchBarClicked() {
        // 만약 이미 3개를 등록했으면 alert
        if viewModel.numberOfItems() >= 3 {
            showSingleAlert(
                String(localized: "하루 최대 3개의 음악을 기록할 수 있습니다"),
                message: String(localized: "다른 곡 추가를 원하시면 기존의 곡을 지워주세요")
            )
            return
        }
        
        // 만약 이전 날짜의 데이터를 수정하려고 들어왔으면 alert
        if viewModel.impossibleAddMusic() {
            showSingleAlert(
                String(localized: "이전 날짜에는 곡을 추가할 수 없습니다"),
                message: String(localized: "순서 수정 또는 곡 삭제만 가능합니다")
            )
        }
        
        // 아니면
        let vc = SearchViewController()
        vc.delegate = self
        let nav = UINavigationController(rootViewController: vc)
        present(nav, animated: true)
    }
    
    @objc
    func helpButtonClicked() {
        
        let vc = HelpPageViewController()
        vc.viewModel.helpShowType = .selectButton
//        vc.helpShowType = .selectButton
        vc.modalPresentationStyle = .overFullScreen
        present(vc, animated: true)
    }
    
    @objc
    func saveButtonClicked() {
        
        // ===== 새로 짠 로직 =====
        viewModel.saveButtonClicked { [weak self] okClosure, cancelClosure in
            /* empty        : 선택한 음악이 없는 경우. 팝업 후 추가 기능 */
            print("empty CompletionHandler")
            self?.showAlertTwoCases(
                String(localized: "선택한 곡이 없습니다"),
                message: String(localized: "이대로 저장하시겠습니까?")) {
                okClosure()         // 데이터 없는 채로 저장
            } cancelCompletionHandler: {
                cancelClosure()     // 취소
            }
        } popViewCompletionHandler: { [weak self] in
            /* popView      : 작업 완료 후 뒤로 가기 */
            print("popView CompletionHandler")
            
            
            // UserDefualts 확인해서 true이면 광고 면제 시켜줌
            let pass = UserDefaults.standard.bool(forKey: "NoAdMobUser")
            print("UserDefault - NoAdMobUser Value : \(pass)")
            
            if pass {
                self?.successForSavingAndPopVC()
            } else {
                // Google AdMob
                // 광고 시청 완료되면 아래 코드 실행시키기
                let request = GADRequest()
                GADInterstitialAd.load(
                    // test id : ca-app-pub-3940256099942544/4411468910
                    // real id : ca-app-pub-8155830639201287/2218945200
                    withAdUnitID: "ca-app-pub-8155830639201287/2218945200",
                    request: request) { ad, error in
                        if let ad {
                            self?.interstitial = ad
                            self?.interstitial?.fullScreenContentDelegate = self
                            self?.showGoogleAdMobs()
                        }
                        
                        if let error {
                            print("Failed to load interstitial ad with error : \(error.localizedDescription)")
                            self?.successForSavingAndPopVC()    // 에러가 나면 어쩔 수 없이 그냥 성공 처리 해줌
                            return
                        }
                    }
            }
        } duplicationCompletionHandler: { [weak self] in
            /* duplication  : 중복된 곡인 경우 팝업 */
            print("duplication CompletionHandler")
            
            self?.showSingleAlert(
                String(localized: "같은 곡을 두 개 이상 저장할 수 없습니다"),
                message: String(localized: "중복되는 곡을 삭제해주세요"))
        }
    }
 
    
    override func loadView() {
        self.view = saveView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        // 이전 날짜라면, 얼럿 한 번 띄워주기
        if viewModel.currentDate?.toString(of: .full) != Date().toString(of: .full) {
            showSingleAlert(
                String(localized: "이전 날짜의 데이터를 수정할 때는 곡 추가가 불가능합니다"),
                message: String(localized: "곡 삭제 시 주의해주세요")
            )
        }
        
        settingSaveView()
        settingNavigation()
        settingScrollView()
        
        viewModel.updateMusicList()
        
        saveView.collectionView.reloadData() // 이건 왜 하고 있는거냐
        
        
        // userdefaults 확인해서 helpView 처음에 띄워주고, 다시 보지 않기 체크하면 UserDefaults값 바꿔준다
        
        if !UserDefaults.standard.bool(forKey: helpView.showHelpView.rawValue) {
            let vc = HelpPageViewController()
            vc.viewModel.helpShowType = .firstTime
//            vc.helpShowType = .firstTime
            vc.modalPresentationStyle = .overFullScreen
            present(vc, animated: true)
        }
    }
}






// datasource
extension SaveViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
//        if collectionView == saveView.genreCollectionView {
//            return viewModel.genreListCount()
//        } else {
        return viewModel.musicListCount()
//        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
//        if collectionView == saveView.genreCollectionView {
//            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GenreCatalogCell.description(), for: indexPath) as? GenreCatalogCell else { return UICollectionViewCell() }
//            
//            cell.nameLabel.text = viewModel.genreName(indexPath: indexPath)
//            cell.backView.backgroundColor = UIColor(hexCode: viewModel.genreColorName(indexPath: indexPath))
//            
//            
//            return cell
//        } else {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SaveCatalogCell.description(), for: indexPath) as? SaveCatalogCell else { return UICollectionViewCell() }
        
        
        let music = viewModel.music(indexPath)
        let recordCnt = viewModel.musicRecordCount(indexPath)
        
        cell.designCell(music, recordCnt: recordCnt, indexPath: indexPath)
        
        
        

        return cell
//        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool {
        return true
    }
}


protocol XButtonClickedProtocol: AnyObject {
    func xButtonClicked(_ indexPath: IndexPath)
}

extension SaveViewController: XButtonClickedProtocol {
    func xButtonClicked(_ indexPath: IndexPath) {
        print("셀 삭제하기")
        saveView.collectionView.performBatchUpdates {
            viewModel.removeMusic(indexPath)
            saveView.collectionView.deleteItems(at: [IndexPath(item: indexPath.item, section: 0)])
        } completion: { [weak self] _ in
            self?.saveView.collectionView.reloadData()
        }
    }
    
    
}

// delegate
extension SaveViewController: UICollectionViewDelegate {
    // 셀 클릭 시 셀 삭제
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
//        if collectionView == saveView.genreCollectionView {
//            print("장르 컬렉션뷰 선택됨")
//            if !NetworkMonitor.shared.isConnected {
//                showSingleAlert("네트워크 연결 상태가 좋지 않습니다", message: "연결 상태를 확인해주세요")
//            }
//            
//            if viewModel.numberOfItems() >= 3 {
//                showSingleAlert("하루 최대 3개의 음악을 기록할 수 있습니다", message: "다른 곡 추가를 원하시면 기존의 곡을 지워주세요")
//                return
//            }
//            
//            if viewModel.impossibleAddMusic() {
//                showSingleAlert("이전 날짜에는 곡을 추가할 수 없습니다", message: "순서 수정 또는 곡 삭제만 가능합니다")
//            }
//    
//            let vc = GenreViewController()
//            vc.delegate = self
//            vc.viewModel.title = viewModel.genreList[indexPath.item].koreanName
//            
//            // GenreData가 다 로드되었는지 확인
//            if !GenreDataModel.shared.isEmpty() {
//                // 다 로드 되었다면 -> 네트워크 통신 금방 함 -> 바로 음악들 로드 가능
//                print("다 로드 되었다면 -> 네트워크 통신 금방 함 -> 바로 음악들 로드 가능")
//
//                vc.viewModel.genre = GenreDataModel.shared.findGenre(viewModel.genreList[indexPath.item])
//                vc.viewModel.fetchInitialMusic()
//                
//                let nav = UINavigationController(rootViewController: vc)
//                present(nav, animated: true)
//                
//            } else {
//                // 아직 로드되지 않았다면 일단 present하고 로딩바 재생 -> 다시 로드 시작 -> completionHandler로 끝나는 시점에 연결
//                print("아직 로드되지 않았다면 -> 다시 로드 시작 -> completionHandler로 끝나는 시점에 연결")
//                
//                // vc 생성 (isLoading = false) -> viewDidLoad (true) -> updateSnapshot (false)
//                // 데이터 로드 끝나면 updateSnapshot
//                let nav = UINavigationController(rootViewController: vc)
//                present(nav, animated: true)
//                
//                GenreDataModel.shared.fetchGenreChart { [weak self] in
//                    print("다시 실행시킨 fetchGenre done")
//                    
//                    guard let genre = self?.viewModel.genreList[indexPath.item] else { return }
//                    
//                    vc.viewModel.genre = GenreDataModel.shared.findGenre(genre)
//                    vc.viewModel.fetchInitialMusic()
//                    
//                    
//                }
//            }
//            
//
//            
//            
//        }
//        else {
            
        self.showAlert(
            String(localized: "곡을 삭제하시겠습니까?"),
            message: String(localized: "이전 날짜 데이터를 수정할 때는 곡 추가가 불가능합니다. 주의해주세요"),
            okTitle: String(localized: "확인")) { [weak self] in
                print("셀 삭제하기")
                collectionView.performBatchUpdates {
                    self?.viewModel.removeMusic(indexPath)
                    collectionView.deleteItems(at: [IndexPath(item: indexPath.item, section: 0)])
    
                } completion: { [weak self] _ in
                    self?.saveView.collectionView.reloadData()
                }
        }
            

//        }
        
    }
}

// drag and drop
extension SaveViewController: UICollectionViewDragDelegate, UICollectionViewDropDelegate {
    
    func collectionView(_ collectionView: UICollectionView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        print("itemsForBeginning", indexPath)
        
        return [UIDragItem(itemProvider: NSItemProvider())]
        
        // NSItemProvider: 현재 앱이 다른 앱에 데이터를 전달하는 목적으로 사용
        // drag and drop : 화면 하나에 여러 가지 앱이 띄워져 있을 경우, 다른 앱으로 drop하여 아이템을 전달할 때, 이 provider에 담아서 전송한다
    }
    
    
    func collectionView(_ collectionView: UICollectionView, performDropWith coordinator: UICollectionViewDropCoordinator) {
        print("performDropWith", coordinator.destinationIndexPath)
        
        var destinationIndexPath: IndexPath
        
        if let indexPath = coordinator.destinationIndexPath {
            destinationIndexPath = indexPath
        } else {
            let row = collectionView.numberOfItems(inSection: 0)
            destinationIndexPath = IndexPath(item: row - 1, section: 0)
        }
        
        if coordinator.proposal.operation == .move {
            move(coordinator: coordinator, destinationIndexPath: destinationIndexPath, collectionView: collectionView)
        }
    }
    
    private func move(coordinator: UICollectionViewDropCoordinator, destinationIndexPath: IndexPath, collectionView: UICollectionView) {
        guard let sourceItem = coordinator.items.first else { return }
        guard let sourceIndexPath = sourceItem.sourceIndexPath else { return }
        
        collectionView.performBatchUpdates { [weak self] in
            self?.move2(sourceIndexPath: sourceIndexPath, destinationIndexPath: destinationIndexPath)
        } completion: { finish in
            print("finish : ", finish)
            coordinator.drop(sourceItem.dragItem, toItemAt: destinationIndexPath)
            self.saveView.collectionView.reloadData()
        }

    }
                
    private func move2(sourceIndexPath: IndexPath, destinationIndexPath: IndexPath) {
        
        let sourceItem = viewModel.music(sourceIndexPath)
        
        viewModel.removeMusic(sourceIndexPath)
        viewModel.insertMusic(sourceItem, indexPath: destinationIndexPath)

        saveView.collectionView.deleteItems(at: [sourceIndexPath])
        saveView.collectionView.insertItems(at: [destinationIndexPath])
    }
    
    // dropSessionDidUpdate: drag하는 동안 계속 호출
    func collectionView(_ collectionView: UICollectionView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UICollectionViewDropProposal {
        
        // drag가 활성화되어 있는 경우에만 drop이 동작.
        if collectionView.hasActiveDrag {
            return UICollectionViewDropProposal(operation: .move, intent: .insertAtDestinationIndexPath)
        }
        return UICollectionViewDropProposal(operation: .forbidden)
    }
    
    func collectionView(_ collectionView: UICollectionView, dropSessionDidEnd session: UIDropSession) {
        collectionView.reloadData()
    }
}

// delegate function
extension SaveViewController: UpdateDataDelegate {
    
    func updateMusicList(item: MusicItem) {
        
        print("update :", item)
        print("data : ", viewModel.musicList.value)
        
        viewModel.appendMusic(item)
        
        saveView.collectionView.reloadData()
    }
}

// private func
extension SaveViewController {
    private func showGoogleAdMobs() {
        guard let interstitial = self.interstitial else { return }
        interstitial.present(fromRootViewController: self)
    }
    
    private func successForSavingAndPopVC() {
        self.delegate?.update()  // 캘린더뷰 + 컬렉션뷰 리로드
        self.navigationController?.popViewController(animated: true)
    }
}

// Google AdMobs
extension SaveViewController: GADFullScreenContentDelegate {
    
    /// Tells the delegate that the ad failed to present full screen content.
    func ad(_ ad: GADFullScreenPresentingAd, didFailToPresentFullScreenContentWithError error: Error) {
        print("Ad did fail to present full screen content.")
    }

    /// Tells the delegate that the ad will present full screen content.
    func adWillPresentFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        print("Ad will present full screen content.")
    }

    /// Tells the delegate that the ad dismissed full screen content.
    func adDidDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        print("Ad did dismiss full screen content.")
        successForSavingAndPopVC()
    }
    
}
