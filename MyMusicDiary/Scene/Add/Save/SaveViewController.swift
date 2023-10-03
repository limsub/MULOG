//
//  SaveViewController.swift
//  MyMusicDiary
//
//  Created by 임승섭 on 2023/09/27.
//

import UIKit

// collectionView index 기반으로 구현


class SaveViewController: BaseViewController {
    
    let repository = MusicItemTableRepository()
    
    let viewModel = SaveViewModel()
    
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: createSaveLayout() )
    
    let nextButton = {
        let view = UIButton()
        view.backgroundColor = .lightGray
        view.layer.cornerRadius = 20
        view.setTitle("음악 검색하러 가기", for: .normal)
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        
        
        // 임시
        let music = repository.fetchMusic().first!
        var musicGenres: [String] = []
        music.genres.forEach { item in
            musicGenres.append(item)
        }
        let music2 = MusicItem(id: music.id, name: music.name, artist: music.artist, bigImageURL: music.bigImageURL, smallImageURL: music.smallImageURL, previewURL: nil, genres: musicGenres
        )
        viewModel.musicList.value.append(music2)
        
        setCollectionView()
        
        let saveButton = UIBarButtonItem(title: "저장", style: .plain, target: self, action: #selector(saveButtonClicked))
        navigationItem.rightBarButtonItem = saveButton
        nextButton.addTarget(self, action: #selector(buttonClicked), for: .touchUpInside)
    }
    
    @objc
    func saveButtonClicked() {
        print("데이터가 저장됩니다")
        print(viewModel.musicList.value)
        
        // 오늘 날짜로 추가
        let todayNew = DayItemTable(day: Date())
        repository.createDayItem(todayNew)
        
        // 방금 추가한 데이터 가져옴
        guard let todayData = repository.fetchDay(Date()) else { return }
        
        // 저장할 음악 데이터들 loop
        viewModel.musicList.value.forEach {
            
            // 이미 저장된 음악 데이터인 경우
            if let alreadyData = repository.alreadySave($0.id) {
                // count를 1 증가시킨다
                repository.plusCnt(alreadyData)

                // 오늘 날짜 데이터의 musicItem에 추가
                repository.appendMusicItem(todayData, musicItem: alreadyData)
            }
            // 기존에 없는 음악 데이터인 경우
            else {
                // 새로운 테이블 생성
                let task = repository.makeMusicItemTable($0)
                
                // 오늘 날짜 데이터의 musicItem에 추가 -> 자동으로 musicItemTable에도 추가된다
                repository.appendMusicItem(todayData, musicItem: task)
            }
        }
    }
    
    @objc
    func buttonClicked() {
        
        print("디비에 저장된 데이터입니다")
        print(repository.fetchMusic())
        print(repository.fetchDay())
        
        let vc = SearchViewController()
        vc.delegate = self
        navigationController?.pushViewController(vc, animated: true)
    }
    
    override func setConfigure() {
        super.setConfigure()
        
        view.addSubview(collectionView)
        view.addSubview(nextButton)
    }
    
    override func setConstraints() {
        super.setConstraints()
        
        collectionView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        nextButton.snp.makeConstraints { make in
            make.horizontalEdges.bottom.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.height.equalTo(60)
        }
    }
    
    func setCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.dragDelegate = self
        collectionView.dropDelegate = self
        collectionView.dragInteractionEnabled = true
        
        collectionView.register(SaveCatalogCell.self, forCellWithReuseIdentifier: SaveCatalogCell.description())
    }
}

// datasource
extension SaveViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfItems()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        print("cellForRowAt  cellForRowAt  cellForRowAt  cellForRowAt  cellForRowAt")
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SaveCatalogCell.description(), for: indexPath) as? SaveCatalogCell else { return UICollectionViewCell() }
        
        cell.designCell(viewModel.musicList.value[indexPath.row])
        
        
        
        cell.representLabel.isHidden = (indexPath.item == 0) ? false : true
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool {
        return true
    }
}


// delegate
extension SaveViewController: UICollectionViewDelegate {
    // 셀 클릭 시 셀 삭제
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        collectionView.performBatchUpdates {
            viewModel.musicList.value.remove(at: indexPath.item)
            collectionView.deleteItems(at: [IndexPath(item: indexPath.item, section: 0)])
            nextButton.isHidden = false
        } completion: { [weak self] _ in
            self?.collectionView.reloadData()
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
        
        let sourceItem = viewModel.musicList.value[sourceIndexPath.item]
        
        viewModel.musicList.value.remove(at: sourceIndexPath.item)
        viewModel.musicList.value.insert(sourceItem, at: destinationIndexPath.item)
        
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
        viewModel.musicList.value.append(item)
        
        if viewModel.musicList.value.count == 3 {
            nextButton.isHidden = true
        } else {
            nextButton.isHidden = false
        }
        collectionView.reloadData()
    }
}
