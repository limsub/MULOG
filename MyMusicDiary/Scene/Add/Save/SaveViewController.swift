//
//  SaveViewController.swift
//  MyMusicDiary
//
//  Created by 임승섭 on 2023/09/27.
//

import UIKit

// collectionView index 기반으로 구현

// 저장 버튼 눌렀을 때 이전화면 캘린더, 컬렉션뷰 리로드시켜주기 위함
protocol ReloadProtocol: AnyObject {
    func update()
}

class SaveViewController: BaseViewController {
    
    weak var delegate: ReloadProtocol?

    let viewModel = SaveViewModel()
    
    
    
    
    
    // 10/11 UI 수정
    let scrollView = UIScrollView()
    let contentView = UIView()
    
    let searchMusicLabel = {
        let view = UILabel()
        view.text = "음악 검색"
        view.font = .boldSystemFont(ofSize: 18)
        return view
    }()
    let searchBar = {
        let view = UISearchBar()
        view.isUserInteractionEnabled = false
        view.placeholder = "오늘 들었던 음악을 검색하세요"
        view.layer.borderColor = UIColor.white.cgColor
        view.layer.borderWidth = 2
        view.backgroundColor = .clear
        return view
    }()
    lazy var fakeButton = {
        let view = UIButton()
        view.backgroundColor = .clear
        view.addTarget(self, action: #selector(searchBarClicked), for: .touchUpInside)
        return view
    }()
    
    let genreChartLabel = {
        let view = UILabel()
        view.text = "장르별 음악"
        view.font = .boldSystemFont(ofSize: 18)
        return view
    }()
    lazy var genreCollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: self.createGenreSaveLayout() )
        
        view.translatesAutoresizingMaskIntoConstraints = false
        view.showsHorizontalScrollIndicator = false
        
        view.delegate = self
        view.dataSource = self
        
        view.register(GenreCatalogCell.self, forCellWithReuseIdentifier: GenreCatalogCell.description())
        
        return view
    }()
    
    let todayMusicLabel = {
        let view = UILabel()
        view.text = "오늘의 음악 기록"
        view.font = .boldSystemFont(ofSize: 18)
        return view
    }()
    lazy var helpButton = {
        let view = UIButton()
        
        view.imageEdgeInsets = UIEdgeInsets(top: 22, left: 22, bottom: 22, right: 22)
         
        
        view.setImage(UIImage(named: "question"), for: .normal)
        view.addTarget(self, action: #selector(helpButtonClicked), for: .touchUpInside)
        return view
    }()
    lazy var collectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: self.createSaveLayout() )
        
        view.isScrollEnabled = false

        view.delegate = self
        view.dataSource = self
        view.dragDelegate = self
        view.dropDelegate = self
        view.dragInteractionEnabled = true
        
        view.register(SaveCatalogCell.self, forCellWithReuseIdentifier: SaveCatalogCell.description())
        return view
    }()
    
    
    
    
    
    
    @objc
    func searchBarClicked() {
        // 만약 이미 3개를 등록했으면 alert
        if viewModel.numberOfItems() >= 3 {
            showSingleAlert("하루 최대 3개의 음악을 기록할 수 있습니다", message: "다른 곡 추가를 원하시면 기존의 곡을 지워주세요")
            return
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
        vc.modalPresentationStyle = .overFullScreen
        present(vc, animated: true)
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        navigationItem.title = "음악 기록"
        navigationItem.largeTitleDisplayMode = .never

        
        
        
        
        scrollView.showsVerticalScrollIndicator = false
        
        let saveButton = UIBarButtonItem(title: "저장", style: .plain, target: self, action: #selector(saveButtonClicked))
        navigationItem.rightBarButtonItem = saveButton
        
        
        
        
        
        
        
        viewModel.musicList.value = viewModel.preMusicList.value
        
        print("1111111", viewModel.musicList.value)
        print("2222222", viewModel.preMusicList.value)
        collectionView.reloadData()
        
//        navigationController?.interactivePopGestureRecognizer?.addTarget(self, action: #selector(funcName))
////        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }
    
//    @objc func funcName(_ recognizer: UIGestureRecognizer) {
//        print("state: \(recognizer.state.rawValue)")
//    }
    

    
    @objc
    func saveButtonClicked() {
        print("데이터가 저장됩니다")
        print(viewModel.musicList.value)
        
        viewModel.addNewData()
        
        delegate?.update()
        
        navigationController?.popViewController(animated: true)

    }
    
    @objc
    func buttonClicked() {
        print("디비에 저장된 데이터입니다")

        let vc = SearchViewController()
        vc.delegate = self
        navigationController?.pushViewController(vc, animated: true)
    }
    
    override func setConfigure() {
        super.setConfigure()
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        contentView.addSubview(searchMusicLabel)
        contentView.addSubview(searchBar)
        contentView.addSubview(fakeButton)
        contentView.addSubview(genreChartLabel)
        contentView.addSubview(genreCollectionView)
        contentView.addSubview(todayMusicLabel)
        contentView.addSubview(helpButton)
        contentView.addSubview(collectionView)
        
    }
    
    override func setConstraints() {
        super.setConstraints()
        
        // 스크롤 뷰
        scrollView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        contentView.snp.makeConstraints { make in
            make.edges.equalTo(scrollView.contentLayoutGuide)
            make.height.greaterThanOrEqualTo(view.snp.height).priority(.low)
            make.width.equalTo(scrollView.snp.width)
        }
        
        // 음악 검색
        searchMusicLabel.snp.makeConstraints { make in
            make.top.equalTo(contentView.safeAreaLayoutGuide).inset(20)
            make.horizontalEdges.equalTo(contentView).inset(18)
        }
        searchBar.snp.makeConstraints { make in
            make.top.equalTo(searchMusicLabel.snp.bottom).offset(8)
            make.horizontalEdges.equalTo(contentView).inset(8)
            make.height.equalTo(40)
        }
        fakeButton.snp.makeConstraints { make in
            make.verticalEdges.equalTo(searchBar)
            make.horizontalEdges.equalTo(contentView)
        }
        
        // 장르별 음악
        genreChartLabel.snp.makeConstraints { make in
            make.top.equalTo(fakeButton.snp.bottom).offset(30)
            make.horizontalEdges.equalTo(contentView).inset(18)
        }
        genreCollectionView.snp.makeConstraints { make in
            make.top.equalTo(genreChartLabel.snp.bottom).offset(8)
            make.horizontalEdges.equalTo(contentView)
            make.height.equalTo(80)
        }
        
        // 오늘의 음악
        todayMusicLabel.snp.makeConstraints { make in
            make.top.equalTo(genreCollectionView.snp.bottom).offset(30)
            make.leading.equalTo(view).inset(18)
        }
        helpButton.snp.makeConstraints { make in
            make.leading.equalTo(todayMusicLabel.snp.trailing).offset(-8)
            make.height.equalTo(todayMusicLabel)
            make.width.equalTo(helpButton.snp.height)
            make.centerY.equalTo(todayMusicLabel)
        }
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(todayMusicLabel.snp.bottom).offset(8)
            make.horizontalEdges.equalTo(view).inset(18)
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }


        
    }

}






// datasource
extension SaveViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView == genreCollectionView {
            return viewModel.genreListCount()
        } else {
            return viewModel.musicListCount()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        print("cellForRowAt  cellForRowAt  cellForRowAt  cellForRowAt  cellForRowAt")
        
        
        if collectionView == genreCollectionView {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GenreCatalogCell.description(), for: indexPath) as? GenreCatalogCell else { return UICollectionViewCell() }
            
            cell.nameLabel.text = viewModel.genreName(indexPath: indexPath)
            cell.backView.backgroundColor = UIColor(hexCode: viewModel.genreColorName(indexPath: indexPath))
            
            return cell
        } else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SaveCatalogCell.description(), for: indexPath) as? SaveCatalogCell else { return UICollectionViewCell() }
            
            let music = viewModel.music(indexPath)
            let recordCnt = viewModel.musicRecordCount(indexPath)
            
            cell.designCell(music, recordCnt: recordCnt, indexPath: indexPath)

            return cell
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool {
        return true
    }
}



// delegate
extension SaveViewController: UICollectionViewDelegate {
    // 셀 클릭 시 셀 삭제
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        
        
        if collectionView == genreCollectionView {
            
            if viewModel.numberOfItems() >= 3 {
                showSingleAlert("하루 최대 3개의 음악을 기록할 수 있습니다", message: "다른 곡 추가를 원하시면 기존의 곡을 지워주세요")
                return
            }
            
            
            
            
            let vc = GenreViewController()
            vc.delegate = self
            vc.viewModel.title = viewModel.genreList[indexPath.item].koreanName
            
            // GenreData가 다 로드되었는지 확인
            if !GenreDataModel.shared.isEmpty() {
                // 다 로드 되었다면 -> 네트워크 통신 금방 함 -> 바로 음악들 로드 가능
                print("다 로드 되었다면 -> 네트워크 통신 금방 함 -> 바로 음악들 로드 가능")

                vc.viewModel.genre = GenreDataModel.shared.findGenre(viewModel.genreList[indexPath.item])
                vc.viewModel.fetchInitialMusic()
                
                let nav = UINavigationController(rootViewController: vc)
                present(nav, animated: true)
                
            } else {
                // 아직 로드되지 않았다면 일단 present하고 로딩바 재생 -> 다시 로드 시작 -> completionHandler로 끝나는 시점에 연결
                print("아직 로드되지 않았다면 -> 다시 로드 시작 -> completionHandler로 끝나는 시점에 연결")
                
                // vc 생성 (isLoading = false) -> viewDidLoad (true) -> updateSnapshot (false)
                // 데이터 로드 끝나면 updateSnapshot
                let nav = UINavigationController(rootViewController: vc)
                present(nav, animated: true)
                
                GenreDataModel.shared.fetchGenreChart { [weak self] in
                    print("다시 실행시킨 fetchGenre done")
                    
                    guard let genre = self?.viewModel.genreList[indexPath.item] else { return }
                    
                    vc.viewModel.genre = GenreDataModel.shared.findGenre(genre)
                    vc.viewModel.fetchInitialMusic()
                    
                    
                }
            }
            

            
            print("장르 컬렉션뷰 선택됨")
        } else {
            collectionView.performBatchUpdates {
                viewModel.removeMusic(indexPath)
                collectionView.deleteItems(at: [IndexPath(item: indexPath.item, section: 0)])
                
            } completion: { [weak self] _ in
                self?.collectionView.reloadData()
            }
        }
        
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
            self.collectionView.reloadData()
        }

    }
                
    private func move2(sourceIndexPath: IndexPath, destinationIndexPath: IndexPath) {
        
        let sourceItem = viewModel.music(sourceIndexPath)
        
        viewModel.removeMusic(sourceIndexPath)
        viewModel.insertMusic(sourceItem, indexPath: destinationIndexPath)

        collectionView.deleteItems(at: [sourceIndexPath])
        collectionView.insertItems(at: [destinationIndexPath])
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
        
        collectionView.reloadData()
    }
}
