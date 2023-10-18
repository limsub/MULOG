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
    
    let genreView = GenreView()
    
    
    var dataSource: UICollectionViewDiffableDataSource<Int, MusicItem>?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        // 처음엔 무조건 로딩뷰 작동
        genreView.loadingIndicator(true)
        
        settingNavigation()
        settingGenreView()
        
        configureDataSource()
        bindModelData()
        
        
        // 전체 데이터를 로드한다 -> pagination에서 이용한다
        viewModel.fetchWholeMusic()
    }
    
    
    func settingNavigation() {
        navigationItem.title = viewModel.title
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    func settingGenreView() {
        genreView.collectionView.prefetchDataSource = self
        genreView.collectionView.delegate = self
    }
    
    
    // bind
    private func bindModelData() {
        print("musicList에 바인드 : updateSnapshot")
        viewModel.musicList.bind { _ in
            DispatchQueue.main.async {
                self.genreView.loadingIndicator(false)
                self.updateSnapshot()
            }
        }
    }
    
    // datasource
    private func configureDataSource() {
        let cellRegistration = UICollectionView.CellRegistration<SearchCatalogCell, MusicItem> { cell, indexPath, itemIdentifier in
            
            cell.designCell(itemIdentifier)
        }
        
        dataSource = UICollectionViewDiffableDataSource(
            collectionView: genreView.collectionView,
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
        
        for indexPath in indexPaths {
            if viewModel.isPossiblePagination(indexPath) {
                viewModel.updateMusicListFromWholeList()
            }
        }
        
    }
}

    
// delegate
extension GenreViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        delegate?.updateMusicList(item: viewModel.musicList.value[indexPath.row])
        
        dismiss(animated: true)
    }
}

