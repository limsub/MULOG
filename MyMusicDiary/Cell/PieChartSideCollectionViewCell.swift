//
//  PieChartSideCollectionViewCell.swift
//  MyMusicDiary
//
//  Created by 임승섭 on 2023/10/06.
//

import UIKit

class PieChartSideCollectionViewCell: BaseCollectionViewCell {
    
    let nameLabel = UILabel()
    let countLabel = UILabel()
    let percentLabel = UILabel()
    
    
    override func setConfigure() {
        super.setConfigure()
        
        [nameLabel, countLabel, percentLabel].forEach { item in
            item.font = .systemFont(ofSize: 13)
        }
        
        contentView.addSubview(nameLabel)
        contentView.addSubview(countLabel)
        contentView.addSubview(percentLabel)
    }
    
    override func setConstraints() {
        super.setConstraints()
        
        nameLabel.snp.makeConstraints { make in
            make.leading.equalTo(contentView).inset(20)
            make.width.equalTo(contentView).multipliedBy(0.3)
        }
        countLabel.snp.makeConstraints { make in
            make.leading.equalTo(nameLabel.snp.trailing).offset(8)
            make.width.equalTo(contentView).multipliedBy(0.3)
        }
        percentLabel.snp.makeConstraints { make in
            make.leading.equalTo(countLabel.snp.trailing).offset(8)
            make.trailing.equalTo(contentView).inset(8)
        }
    }
}
