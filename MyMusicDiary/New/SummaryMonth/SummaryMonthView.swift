//
//  SummaryMonthView.swift
//  MyMusicDiary
//
//  Created by 임승섭 on 1/26/25.
//

import UIKit
import SnapKit
import Then

class SummaryMonthView: BaseView {
    
    let titleBaseView = UIView().then {
        $0.backgroundColor = .white
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 20
    }
    let beforeButton = UIButton().then {
        $0.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        $0.backgroundColor = .cyan
    }
    
    let titleLabel = UILabel().then {
        $0.text = "2024년 3월"
        $0.backgroundColor = .blue
    }
    
    let afterButton = UIButton().then {
        $0.setImage(UIImage(systemName: "chevron.right"), for: .normal)
        $0.backgroundColor = .brown
    }
    
    lazy var collectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: self.makeCollectionViewFlowLayout())
        view.register(UICollectionViewCell.self, forCellWithReuseIdentifier: UICollectionViewCell.description())
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isScrollEnabled = false
        view.backgroundColor = .white
        view.clipsToBounds = true
        view.layer.cornerRadius = 20
        return view
    }()
    
    let reloadButton = UIButton().then {
        $0.setImage(UIImage(systemName: "pencil"), for: .normal)
        $0.backgroundColor = .red
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 20
    }
    
    let downloadButton = UIButton().then {
        $0.backgroundColor = .blue
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 20
    }
    
    override func setConfigure() {
        super.setConfigure()
        
        [titleBaseView, collectionView, reloadButton, downloadButton].forEach {
            self.addSubview($0)
        }
        
        [beforeButton, titleLabel, afterButton].forEach {
            titleBaseView.addSubview($0)
        }
    }
    
    override func setConstraints() {
        super.setConstraints()
        
        titleBaseView.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide)
            make.horizontalEdges.equalToSuperview().inset(18)
            make.height.equalTo(50)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.height.equalTo(20)
            make.width.equalTo(100)
            make.centerX.equalToSuperview()
        }
        
        beforeButton.snp.makeConstraints { make in
            make.centerY.equalTo(titleLabel)
            make.trailing.equalTo(titleLabel.snp.leading).offset(-8)
        }
        
        afterButton.snp.makeConstraints { make in
            make.centerY.equalTo(titleLabel)
            make.leading.equalTo(titleLabel.snp.trailing).offset(8)
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(titleBaseView.snp.bottom).offset(12)
            make.horizontalEdges.equalToSuperview().inset(18)
            make.height.equalTo(collectionView.snp.width)
        }
        
        reloadButton.snp.makeConstraints { make in
            make.top.equalTo(collectionView.snp.bottom).offset(12)
            make.leading.equalToSuperview().inset(18)
            make.trailing.equalTo(self.snp.centerX).offset(-8)
            make.height.equalTo(52)
        }
        
        downloadButton.snp.makeConstraints { make in
            make.top.equalTo(collectionView.snp.bottom).offset(12)
            make.trailing.equalToSuperview().inset(18)
            make.leading.equalTo(self.snp.centerX).offset(8)
            make.height.equalTo(52)
        }
    }
    
    override func setting() {
        super.setting()
        
        self.backgroundColor = UIColor(hexCode: "#F6F6F6")
    }
    
}

// MARK: - private func
extension SummaryMonthView {
    private func makeCollectionViewFlowLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let w = (UIScreen.main.bounds.width - 32) / 5
        layout.itemSize = CGSize(
            width: w,
            height: w
        )
        layout.minimumInteritemSpacing = 4
        layout.minimumLineSpacing = 4
        return layout
    }
}

