//
//  GenreViewController.swift
//  MyMusicDiary
//
//  Created by 임승섭 on 2023/10/11.
//

import UIKit

class GenreViewController: BaseViewController {
    
    let loadingView = {
        let view = UIView()
        view.backgroundColor = .red
        return view
    }()
    
    weak var delegate: UpdateDataDelegate?
    
    let viewModel = GenreViewModel()
    
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
    
    var dataSource: UICollectionViewDiffableDataSource<Int, MusicItem>?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        
        view.addSubview(loadingView)
        loadingView.snp.makeConstraints { make in
            make.center.equalTo(view)
            make.size.equalTo(50)
        }
        // 처음엔 무조건 로딩뷰 작동
        viewModel.isLoading.value = true
        
        
        settingNavigation()
        settingCollectionView()
        
        configureDataSource()
        bindModelData()
        
        
        // 전체 데이터를 로드한다 -> pagination에서 이용한다
        viewModel.fetchWholeMusic()
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
    func settingNavigation() {
        navigationItem.title = viewModel.title
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    func settingCollectionView() {
        collectionView.prefetchDataSource = self
        collectionView.delegate = self
    }
    
    
    // bind
    private func bindModelData() {
        print("musicList에 바인드 : updateSnapshot")
        viewModel.musicList.bind { _ in
            self.updateSnapshot()
        }
        
        viewModel.isLoading.bind { value in
            if value {
                // 로딩바 작동
                DispatchQueue.main.async {
                    self.loadingView.isHidden = false
                }
                
                print("로딩바 작동")
            } else {
                // 로딩바 해제
                DispatchQueue.main.async {
                    self.loadingView.isHidden = true
                }
                
                print("로딩바 해제")
            }
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
        
        // 컬렉션뷰 로드가 완료되면 false로 바꿔준다 -> bind에 의해 로딩뷰가 없어진다
        viewModel.isLoading.value = false
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

