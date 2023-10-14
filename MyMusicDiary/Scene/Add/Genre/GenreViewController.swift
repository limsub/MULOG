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
        
//        viewModel.fetchMusic(offset: 1)
//        viewModel.fetchMusic(offset: 41)
//        viewModel.fetchMusic(offset: 81)
        
        
        
        view.addSubview(loadingView)
        loadingView.snp.makeConstraints { make in
            make.center.equalTo(view)
            make.size.equalTo(50)
        }
        
        // 처음엔 무조건 로딩뷰 작동
        viewModel.isLoading.value = true
//        loadingView.isHidden = false
        
        
        
        
        navigationItem.title = viewModel.title
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
        
        viewModel.isLoading.value = false
    }
    
}


// prefetch
extension GenreViewController: UICollectionViewDataSourcePrefetching {
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {

        print("prefetch, ", indexPaths)


        // 1 ~ 25
        // 26 ~ 45
        // 46 ~ 65
        // ...

        for indexPath in indexPaths {
            if indexPath.row == viewModel.musicList.value.count - 1 {
                
                guard viewModel.currentPage + 25 < viewModel.wholeData.count else { return }
                
                viewModel.musicList.value.append(contentsOf:
                    viewModel.wholeData[viewModel.currentPage..<viewModel.currentPage+25]
                )
                viewModel.currentPage += 25
            }
        }
    }


}
    
    //extension GenreViewController: UIScrollViewDelegate {
    //    func scrollViewDidScroll(_ scrollView: UIScrollView) {
    //        print("====================")
    //        print(scrollView.contentOffset.y, scrollView.contentSize.height)
    //
    //        if !viewModel.paginationDone && scrollView.contentSize.height - scrollView.contentOffset.y < 900 {
    //            viewModel.paginationDone = true
    //            viewModel.fetchMusic(offset: viewModel.currentPage * 25 + 1)
    //            viewModel.currentPage += 1
    //        }
    //
    //    }
    //}
    
    
    
// delegate
extension GenreViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        delegate?.updateMusicList(item: viewModel.musicList.value[indexPath.row])
        
        dismiss(animated: true)
        
    }
}

