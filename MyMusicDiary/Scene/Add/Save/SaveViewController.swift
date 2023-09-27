//
//  SaveViewController.swift
//  MyMusicDiary
//
//  Created by 임승섭 on 2023/09/27.
//

import UIKit

protocol UpdateDataDelegate {
    func updateMusicList(item: MusicItem)
}

class SaveViewController: BaseViewController {
    
    let viewModel = SaveViewModel()
    
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout() )
    
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
        
        
        GenreDataModel.shared.fetchGenreChart()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.dragDelegate = self
        collectionView.dropDelegate = self
        collectionView.dragInteractionEnabled = true
        
        collectionView.register(SaveCatalogCell.self, forCellWithReuseIdentifier: SaveCatalogCell.description())
        
        nextButton.addTarget(self, action: #selector(buttonClicked), for: .touchUpInside)
    }
    
    @objc
    func buttonClicked() {
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
}

// datasource
extension SaveViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfItems()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        print("cellForRowAtcellForRowAtcellForRowAtcellForRowAtcellForRowAt")
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SaveCatalogCell.description(), for: indexPath) as? SaveCatalogCell else { return UICollectionViewCell() }
        
        cell.designCell(viewModel.musicList.value[indexPath.row])
        
        cell.representView.isHidden = (indexPath.item == 0) ? false : true
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool {
        return true
    }
}


// delegate
extension SaveViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            
//        viewModel.musicList.value.remove(at: indexPath.item)
//        collectionView.deleteItems(at: [IndexPath(item: indexPath.item, section: 0)])
//
//        nextButton.isHidden = false
//
//        print("wowowowowowowowowowowowowowo")
//
//        collectionView.reloadData()
//        print("pqpqpqpqpqpqpqpqpqpqpqpqpqpqpq")
        
        collectionView.performBatchUpdates {
            viewModel.musicList.value.remove(at: indexPath.item)
            collectionView.deleteItems(at: [IndexPath(item: indexPath.item, section: 0)])
            nextButton.isHidden = false
        } completion: { [weak self] _ in
            self?.collectionView.reloadData()
        }

    }
    
//    @objc func didTapInsertButton(_ sender: Any) {
//        collectionView.performBatchUpdates {
//            dataSource.insert("123", at: 0)
//            collectionView.insertItems(at: [IndexPath(item: 0, section: 0)])
//
//            dataSource.remove(at: 5)
//            collectionView.deleteItems(at: [IndexPath(item: 5, section: 0)])
//        } completion: { [weak self] _ in
//            print(self?.collectionView.numberOfItems(inSection: 0))
//        }
//    }
}

// drag and drop
extension SaveViewController: UICollectionViewDragDelegate, UICollectionViewDropDelegate {
    
    func collectionView(_ collectionView: UICollectionView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        print("itemsForBeginning", indexPath)
        
        return [UIDragItem(itemProvider: NSItemProvider())]
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
    
    func collectionView(_ collectionView: UICollectionView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UICollectionViewDropProposal {
        
        
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
