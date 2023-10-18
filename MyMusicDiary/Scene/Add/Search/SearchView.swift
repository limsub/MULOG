//
//  SearchView.swift
//  MyMusicDiary
//
//  Created by 임승섭 on 2023/10/18.
//

import UIKit

class SearchView: BaseView {
    
    let collectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: createSearchLayout())
        view.keyboardDismissMode = .onDrag
        return view
    }()
    
    lazy var activityIndicator = {
        let view = UIActivityIndicatorView()
        view.center = self.center
        view.hidesWhenStopped = true
        view.style = .medium
        view.stopAnimating()
        return view
    }()
    
    override func setConfigure() {
        super.setConfigure()
        
        addSubview(collectionView)
        addSubview(activityIndicator)
    }
    override func setConstraints() {
        super.setConstraints()
        
        collectionView.snp.makeConstraints { make in
            make.edges.equalTo(self.safeAreaLayoutGuide)
        }
        activityIndicator.snp.makeConstraints { make in
            make.center.equalTo(self)
        }
    }
    
    
    func loadingIndicator(_ value: Bool) {
        if value {
            activityIndicator.startAnimating()
        } else {
            activityIndicator.stopAnimating()
        }
    }
    
}



extension SearchView {
    
    
    static func createSearchLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
        
        let width = UIScreen.main.bounds.width - 32
        
        layout.itemSize = CGSize(width: width, height: 60)
        layout.sectionInset = UIEdgeInsets(top: 5, left: 18, bottom: 5, right: 18)
        
        return layout
    }
}
