//
//  PieChartSideCollectionViewCell.swift
//  MyMusicDiary
//
//  Created by 임승섭 on 2023/10/06.
//

import UIKit

class PieChartSideCollectionViewCell: BaseCollectionViewCell {
    
    let colorImageView = {
        let view = UIImageView()
        view.clipsToBounds = true
        view.layer.cornerRadius = 8
        view.backgroundColor = .black
        return view
    }()
    
    let nameLabel = UILabel()
    let countLabel = UILabel()
    let percentLabel = UILabel()
    
    
    override func setConfigure() {
        super.setConfigure()
        
        [nameLabel, countLabel, percentLabel].forEach { item in
            item.font = .systemFont(ofSize: 13)
        }
        nameLabel.adjustsFontSizeToFitWidth = true
        countLabel.textAlignment = .right
        percentLabel.textAlignment = .right
        
        
        contentView.addSubview(colorImageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(countLabel)
        contentView.addSubview(percentLabel)
    }
    
    override func setConstraints() {
        super.setConstraints()
        
        colorImageView.snp.makeConstraints { make in
            make.leading.equalTo(contentView).inset(20)
            make.centerY.equalTo(contentView)
            make.size.equalTo(16)
        }
        nameLabel.snp.makeConstraints { make in
            make.leading.equalTo(colorImageView.snp.trailing).offset(4)
            make.width.equalTo(contentView).multipliedBy(0.3)
            make.centerY.equalTo(contentView)
        }
        countLabel.snp.makeConstraints { make in
            make.leading.equalTo(nameLabel.snp.trailing).offset(8)
            make.width.equalTo(contentView).multipliedBy(0.1)
            make.centerY.equalTo(contentView)
        }
        percentLabel.snp.makeConstraints { make in
            make.leading.equalTo(countLabel.snp.trailing).offset(8)
            make.trailing.equalTo(contentView).inset(12)
            make.centerY.equalTo(contentView)
        }
    }
}
