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
        // pickerView 레이아웃은 frame으로 잡는다
        let view = UIPickerView(frame: CGRect(x: 0, y: -50, width: UIScreen.main.bounds.size.width, height: 0))
        view.backgroundColor = .clear
        view.layer.cornerRadius = 10
        return view
    }()
    
    let backView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 0))
        view.backgroundColor = .darkGray
        view.layer.cornerRadius = 10
        return view
    }()
    
    let tappableView = UIView()
    
    override func setConfigure() {
        super.setConfigure()
        
        addSubview(tappableView)
        addSubview(collectionView)
        addSubview(backView)
        backView.addSubview(pickerView)
    }
    override func setConstraints() {
        super.setConstraints()
        
        collectionView.snp.makeConstraints { make in
            make.edges.equalTo(self.safeAreaLayoutGuide)
        }
        tappableView.snp.makeConstraints { make in
            make.edges.equalTo(self.safeAreaLayoutGuide)
        }
    }
    override func setting() {
        super.setting()
        backgroundColor = .systemBackground
        
        pickerView.isHidden = true
        collectionView.register(MonthScrollCatalogCell.self, forCellWithReuseIdentifier: MonthScrollCatalogCell.description())
    }
    
    // collectionView Layout
    func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
        
        let width = UIScreen.main.bounds.width - 32
        
        layout.itemSize = CGSize(width: width, height: 80)
        layout.sectionInset = UIEdgeInsets(top: 10, left: 18, bottom: 10, right: 18)
        
        layout.minimumLineSpacing = 10
        
        return layout
    }

    
}
