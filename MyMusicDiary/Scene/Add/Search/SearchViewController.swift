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
    weak var delegate: UpdateDataDelegate?
    
    // ViewModel
    let viewModel = SearchViewModel()
    
    let searchBar = UISearchBar()
    
    let searchController = UISearchController()
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
    
    var dataSource: UICollectionViewDiffableDataSource<Int, MusicItem>?
    
    
    // view
    lazy var activityIndicator = {
        let view = UIActivityIndicatorView()
        view.center = self.view.center
        view.hidesWhenStopped = true
        view.style = .medium
        view.stopAnimating()
        return view
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        
        
        settingCollectionView()
        settingNavigationItem()

        configureDataSource()
        bindModelData()
    }
    
    
    
    // set
    override func setConfigure() {
        super.setConfigure()
        
        view.addSubview(collectionView)
        view.addSubview(activityIndicator)
    }
    override func setConstraints() {
        super.setConstraints()
        
        collectionView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        activityIndicator.snp.makeConstraints { make in
            make.center.equalTo(view)
        }
    }
    private func settingCollectionView() {
        collectionView.keyboardDismissMode = .onDrag
        collectionView.prefetchDataSource = self
        collectionView.delegate = self
    }
    private func settingNavigationItem() {
        
        
        
        navigationItem.titleView = searchBar
        searchBar.delegate = self
        searchBar.placeholder = "오늘 들었던 음악을 검색하세요"
        searchBar.becomeFirstResponder()
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

// searchBar
extension SearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        activityIndicator.startAnimating()
        guard let text = searchBar.text else { return }
        viewModel.searchTerm = text
        viewModel.page = 1
        viewModel.musicList.value.removeAll()
        viewModel.fetchSearchMusic {
            DispatchQueue.main.async {
                self.activityIndicator.stopAnimating()
            }
        }
    }
}

// prefetch
extension SearchViewController: UICollectionViewDataSourcePrefetching {
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        print("prefetch. 추후 pagination 필요")
        
        
        
        for indexPath in indexPaths {
            if indexPath.row == viewModel.musicList.value.count - 1 {
//                activityIndicator.startAnimating()    // 여긴 있는게 더 어색하다
                viewModel.page += 1
                viewModel.fetchSearchMusic {
                    
                }
            }
        }
        
    }
}

// delegate
extension SearchViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        delegate?.updateMusicList(item: viewModel.musicList.value[indexPath.item])
        
        dismiss(animated: true)
        
        
    }
}
