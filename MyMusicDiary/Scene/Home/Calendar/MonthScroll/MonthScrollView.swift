//
//  MonthScrollView.swift
//  MyMusicDiary
//
//  Created by 임승섭 on 2023/10/04.
//

import UIKit

class MonthScrollView: BaseView {
    
    lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
    
    
    
    override func setConfigure() {
        super.setConfigure()
        
        addSubview(collectionView)
    }
    override func setConstraints() {
        super.setConstraints()
        
        collectionView.snp.makeConstraints { make in
            make.edges.equalTo(self.safeAreaLayoutGuide)
        }
    }
    override func setting() {
        super.setting()
        
        backgroundColor = .systemBackground
        
        collectionView.register(MonthScrollCatalogCell.self, forCellWithReuseIdentifier: MonthScrollCatalogCell.description())
    }
    
    func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
        
        let width = UIScreen.main.bounds.width - 32
        
        layout.itemSize = CGSize(width: width, height: 80)
        layout.sectionInset = UIEdgeInsets(top: 10, left: 18, bottom: 10, right: 18)
        
        layout.minimumLineSpacing = 10
        
        return layout
    }

    
}
