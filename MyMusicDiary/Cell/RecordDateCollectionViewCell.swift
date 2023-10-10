//
//  RecordDateCollectionViewCell.swift
//  MyMusicDiary
//
//  Created by 임승섭 on 2023/10/10.
//

import UIKit


class RecordDateCollectionViewCell: BaseCollectionViewCell {
    
    let dateLabel = UILabel()
    
    
    
    override func setConfigure() {
        super.setConfigure()
        
        contentView.addSubview(dateLabel)
        
    }
    
    override func setConstraints() {
        super.setConstraints()
        
        
        dateLabel.snp.makeConstraints { make in
            make.edges.equalTo(contentView)
        }
    }
    
}
