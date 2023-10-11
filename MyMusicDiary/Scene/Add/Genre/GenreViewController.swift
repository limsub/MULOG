//
//  GenreViewController.swift
//  MyMusicDiary
//
//  Created by 임승섭 on 2023/10/11.
//

import UIKit

class GenreViewController: BaseViewController {
    
    weak var delegate: UpdateDataDelegate?
    
    let viewModel = GenreViewModel()
    
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
    
    var dataSource: UICollectionViewDiffableDataSource<Int, MusicItem>?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = viewModel.title()
        navigationController?.navigationBar.prefersLargeTitles = true
        
        view.backgroundColor = .systemBackground
        
        collectionView.prefetchDataSource = self
        collectionView.delegate = self
        
        configureDataSource()
        bindModelData()
        
    }
    
    
    // setting
    override func setConfigure() {
        super.setConfigure()
        
        view.addSubview(collectionView)
    }
    override func setConstraints() {
        super.setConstraints()
        
        collectionView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    
    // bind
    private func bindModelData() {
        print("musicList에 바인드 : updateSnapshot")
        viewModel.musicList.bind { _ in
            self.updateSnapshot()
        }
    }
    
    // datasource
    private func configureDataSource() {
        let cellRegistration = UICollectionView.CellRegistration<SearchCatalogCell, MusicItem> { cell, indexPath, itemIdentifier in
            
            cell.designCell(itemIdentifier)
            
        }
        
        dataSource = UICollectionViewDiffableDataSource(
            collectionView: collectionView,
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
    
    private func updateSnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<Int, MusicItem>()
        snapshot.appendSections([0])
        snapshot.appendItems(viewModel.musicList.value)
        dataSource?.apply(snapshot)
    }
    
}


// prefetch
extension GenreViewController: UICollectionViewDataSourcePrefetching {
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        
    }
    
    
}



// delegate
extension GenreViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        delegate?.updateMusicList(item: viewModel.musicList.value[indexPath.row])
        
        dismiss(animated: true)
        
//        guard let viewControllerStack = self.navigationController?.viewControllers else { return }
//        // 뷰 스택에서 RedViewController를 찾아서 거기까지 pop
//        for viewController in viewControllerStack {
//            if let saveVC = viewController as? SaveViewController {
//                self.navigationController?.popToViewController(saveVC, animated: true)
//            }
//        }
    }
}
