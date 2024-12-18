//
//  CustomPieChartView.swift
//  MyMusicDiary
//
//  Created by 임승섭 on 2023/10/06.
//

import UIKit
import DGCharts
import RxSwift

class CustomPieChartView: BaseView {
    
    private var disposeBag = DisposeBag()
    
    let noAdmobFakeButton = {   // 누르면 구글 광고 안나오게 해버리는 가짜 버튼
        let view = UIButton()
        view.backgroundColor = .clear
        return view
    }()
    
    let titleLabel = {
        let view = UILabel()
        view.font = .boldSystemFont(ofSize: 16)
        return view
    }()
    let pieChartView = PieChartView()
    lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = .white
        self.layer.cornerRadius = 10
        setNoAdMobButton()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func setConfigure() {
        super.setConfigure()
        
        self.addSubview(titleLabel)
        self.addSubview(pieChartView)
        self.addSubview(collectionView)
        self.addSubview(noAdmobFakeButton)
    }
    override func setConstraints() {
        super.setConstraints()
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(self).inset(12)
            make.leading.equalTo(self).inset(12)
        }
        pieChartView.snp.makeConstraints { make in
//            make.top.equalTo(titleLabel.snp.bottom).offset(12)
            make.leading.equalTo(self)
            make.width.equalTo(self).multipliedBy(0.5)
            make.height.equalTo(self).multipliedBy(0.8)
            make.centerY.equalTo(self)
        }
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.bottom.equalTo(self).inset(8)
            make.trailing.equalTo(self).inset(12)
            make.leading.equalTo(pieChartView.snp.trailing)
        }
        
        noAdmobFakeButton.snp.makeConstraints { make in
            make.edges.equalTo(pieChartView).inset(10)
        }
    }
    
    private func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
        
        let width = UIScreen.main.bounds.width/2
        
        layout.itemSize = CGSize(width: width, height: 20)
        layout.sectionInset = UIEdgeInsets(top: 5, left: 18, bottom: 5, right: 18)
        
        return layout
    }
}


// 광고 막아주는 로직
extension CustomPieChartView {
    private func setNoAdMobButton() {
        self.noAdmobFakeButton.rx.tap
            .subscribe(with: self) { owner , _ in
                UserDefaults.standard.setValue(true, forKey: "NoAdMobUser")
                print("NoAdMobUser UserDefaults setting success. UserDefault value : \(UserDefaults.standard.bool(forKey: "NoAdMobUser"))")
            }
            .disposed(by: disposeBag)
    }
}
