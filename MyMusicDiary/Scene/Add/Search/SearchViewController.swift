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
        
        collectionView.keyboardDismissMode = .onDrag
        
        collectionView.prefetchDataSource = self
        collectionView.delegate = self
        
        navigationItem.searchController = searchController
        searchController.searchBar.delegate = self
        
        configureDataSource()
        bindModelData()
        viewModel.fetchMusic("블랙핑크")
        
        let tmpButton = UIBarButtonItem(image: UIImage(systemName: "pencil"), style: .plain, target: self, action: #selector(buttonClicked))
        navigationItem.rightBarButtonItem = tmpButton
        
    }
    
    @objc
    func buttonClicked() {
        if !GenreDataModel.shared.genres.isEmpty {
            let vc = TabViewController()
            vc.delegate = delegate
            navigationController?.pushViewController(vc, animated: true)
        }
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
    
    
    // bind
    func bindModelData() {
        viewModel.musicList.bind { _ in
            print("hi")
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
        print("hi")
    }
    
    
}

// delegate
extension SearchViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        delegate?.updateMusicList(item: viewModel.musicList.value[indexPath.item])
        
        navigationController?.popViewController(animated: true)
        
//        if !GenreDataModel.shared.genres.isEmpty {
//            let vc = TabViewController()
//            navigationController?.pushViewController(vc, animated: true)
//        }
    }
}
