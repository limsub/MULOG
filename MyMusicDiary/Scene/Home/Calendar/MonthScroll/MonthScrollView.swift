//
//  MonthScrollView.swift
//  MyMusicDiary
//
//  Created by 임승섭 on 2023/10/04.
//

import UIKit

class MonthScrollView: BaseView {
    
    lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
    
    let pickerView = {
        let view = UIPickerView()
        view.backgroundColor = .lightGray
        return view
    }()
    
    override func setConfigure() {
        super.setConfigure()
        
        addSubview(collectionView)
        addSubview(pickerView)
    }
    override func setConstraints() {
        super.setConstraints()
        
        collectionView.snp.makeConstraints { make in
            make.edges.equalTo(self.safeAreaLayoutGuide)
        }
        pickerView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(self.safeAreaLayoutGuide)
            make.height.equalTo(200)
        }
    }
    override func setting() {
        super.setting()
        
        pickerView.isHidden = true
        
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
