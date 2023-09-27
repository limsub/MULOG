//
//  Genre4ViewController.swift
//  MyMusicDiary
//
//  Created by 임승섭 on 2023/09/27.
//

import UIKit
import MusicKit

class Genre4ViewController: BaseViewController {
    
    var myGenre = GenreDataModel.shared.genres[3]
    
    var musicList: Observable<[MusicItem]> = Observable([])
    
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
    
    var dataSource: UICollectionViewDiffableDataSource<Int, MusicItem>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("4 viewdidload")
        view.backgroundColor = .systemBackground
        
        collectionView.prefetchDataSource = self
        collectionView.delegate = self
        
        configureDataSource()
        
        fetchMusic()
        
    }
    
    // set
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
    
    func fetchMusic() {
        Task {
            var request = MusicCatalogChartsRequest(
                genre: myGenre,
                kinds: [.cityTop],
                types: [Song.self]
            )
            request.limit = 25
            request.offset = 1
            
            let result = try await request.response()
            
            self.musicList.value = result.songCharts[0].items.map {
                return .init(id: $0.id.rawValue, name: $0.title, artist: $0.artistName, imageURL: $0.artwork, previewURL: $0.previewAssets?[0].url, genres: $0.genreNames)
            }
            
            updateSnapshot()
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
        snapshot.appendItems(musicList.value)
        dataSource?.apply(snapshot)
    }
}

// prefetch
extension Genre4ViewController: UICollectionViewDataSourcePrefetching {
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        print("hi")
    }
    
    
}

// delegate
extension Genre4ViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if !GenreDataModel.shared.genres.isEmpty {
            let vc = TabViewController()
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}

