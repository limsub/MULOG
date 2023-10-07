//
//  BarChartSideCollectionViewCell.swift
//  MyMusicDiary
//
//  Created by 임승섭 on 2023/10/07.
//

import UIKit

class BarChartSideCollectionViewCell: BaseCollectionViewCell {
    
    let colorImageView = {
        let view = UIImageView()
        view.clipsToBounds = true
        view.layer.cornerRadius = 8
        view.backgroundColor = .black
        return view
    }()
    
    let nameLabel = UILabel()
    
    override func setConfigure() {
        super.setConfigure()
        
        nameLabel.font = .systemFont(ofSize: 13)
        nameLabel.adjustsFontSizeToFitWidth = true
        
        contentView.addSubview(colorImageView)
        contentView.addSubview(nameLabel)
    }
    
    override func setConstraints() {
        super.setConstraints()
        
        self.backgroundColor = .white
        
        colorImageView.snp.makeConstraints { make in
            make.leading.equalTo(contentView).inset(4)
            make.centerY.equalTo(contentView)
            make.size.equalTo(16)
        }
        nameLabel.snp.makeConstraints { make in
            make.leading.equalTo(colorImageView.snp.trailing).offset(8)
            make.trailing.equalTo(contentView).inset(8)
            make.centerY.equalTo(contentView)
        }
    }
    
}
