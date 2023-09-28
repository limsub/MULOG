//
//  Genre1ViewController.swift
//  MyMusicDiary
//
//  Created by 임승섭 on 2023/09/27.
//

import UIKit
import MusicKit

class Genre1ViewController: BaseViewController {
    
    
    var delegate: UpdateDataDelegate?
    
    var myGenre = GenreDataModel.shared.genres[0]
    
    var musicList: Observable<[MusicItem]> = Observable([])
    
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
    
    var dataSource: UICollectionViewDiffableDataSource<Int, MusicItem>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("1 viewdidload")
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
                return .init(
                    id: $0.id.rawValue, name: $0.title, artist: $0.artistName,
                    bigImageURL: $0.artwork?.url(width: 700, height: 700)?.absoluteString,
                    smallImageURL: $0.artwork?.url(width: 150, height: 150)?.absoluteString,
                    previewURL: $0.previewAssets?[0].url, genres: $0.genreNames)
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
extension Genre1ViewController: UICollectionViewDataSourcePrefetching {
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        print("hi")
    }
    
    
}

// delegate
extension Genre1ViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        delegate?.updateMusicList(item: musicList.value[indexPath.row])
        
        guard let viewControllerStack = self.navigationController?.viewControllers else { return }
        // 뷰 스택에서 RedViewController를 찾아서 거기까지 pop 합니다.
        for viewController in viewControllerStack {
            if let saveVC = viewController as? SaveViewController {
                self.navigationController?.popToViewController(saveVC, animated: true)
            }
        }
    }
}
