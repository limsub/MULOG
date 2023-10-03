//
//  SearchViewController.swift
//  MyMusicDiary
//
//  Created by 임승섭 on 2023/09/27.
//

import UIKit

// 1. collectionView
    // custom Cell
// 2. searchBar


class SearchViewController: BaseViewController {
    
    // 값전달 (delegate)
    var delegate: UpdateDataDelegate?
    
    // ViewModel
    let viewModel = SearchViewModel()
    
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
    
    let searchController = UISearchController()
    
    var dataSource: UICollectionViewDiffableDataSource<Int, MusicItem>?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        settingCollectionView()
        settingNavigationItem()

        configureDataSource()
        bindModelData()
        viewModel.fetchMusic("블랙핑크")
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
    private func settingCollectionView() {
        collectionView.keyboardDismissMode = .onDrag
        collectionView.prefetchDataSource = self
        collectionView.delegate = self
    }
    private func settingNavigationItem() {
        navigationItem.searchController = searchController
        searchController.searchBar.delegate = self
        
        let tmpButton = UIBarButtonItem(image: UIImage(systemName: "pencil"), style: .plain, target: self, action: #selector(chartButtonClicked))
        navigationItem.rightBarButtonItem = tmpButton
    }
    
    
    // bind
    private func bindModelData() {
        print("musicList에 바인드 : updateSnapshot")
        viewModel.musicList.bind { _ in
            self.updateSnapshot()
        }
    }
    
    @objc
    private func chartButtonClicked() {
        if !GenreDataModel.shared.genres.isEmpty {  // 장르 데이터를 정상적으로 받아왔을 때 전환 가능
            let vc = TabViewController()
            vc.delegate = delegate
            navigationController?.pushViewController(vc, animated: true)
        } else {
            // 에러 발생 alert
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

// searchBar
extension SearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text else { return }
        viewModel.fetchMusic(text)
    }
}

// prefetch
extension SearchViewController: UICollectionViewDataSourcePrefetching {
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        print("prefetch. 추후 pagination 필요")
    }
}

// delegate
extension SearchViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        delegate?.updateMusicList(item: viewModel.musicList.value[indexPath.item])
        
        navigationController?.popViewController(animated: true)
    }
}
