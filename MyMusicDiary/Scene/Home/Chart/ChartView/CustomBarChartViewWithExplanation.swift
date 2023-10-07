//
//  CustomBarChartViewWithExplanation.swift
//  MyMusicDiary
//
//  Created by 임승섭 on 2023/10/07.
//

import UIKit


class CustomBarChartViewWithExplanation: BaseView {
    
    let titleLabel = UILabel()
    let barChartView = CustomBarChartView()
    
    lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
    
    private func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
        
        let width = UIScreen.main.bounds.width/2
        
        layout.itemSize = CGSize(width: width, height: 20)
        layout.sectionInset = UIEdgeInsets(top: 5, left: 18, bottom: 5, right: 18)
        
        return layout
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = .white
        self.layer.cornerRadius = 10
        
        barChartView.backgroundColor = .lightGray
        collectionView.backgroundColor = .black
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setConfigure() {
        super.setConfigure()
        self.addSubview(titleLabel)
        self.addSubview(barChartView)
        self.addSubview(collectionView)
    }
    override func setConstraints() {
        super.setConstraints()
        
        titleLabel.snp.makeConstraints { make in
            make.top.leading.equalTo(self).inset(12)
        }
        barChartView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.horizontalEdges.equalTo(self)
            make.height.equalTo(200)
        }
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(barChartView.snp.bottom).offset(8)
            make.horizontalEdges.equalTo(self)
            make.bottom.equalTo(self).inset(12)
        }
    }
}
