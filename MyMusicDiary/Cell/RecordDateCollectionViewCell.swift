//
//  RecordDateCollectionViewCell.swift
//  MyMusicDiary
//
//  Created by 임승섭 on 2023/10/10.
//

import UIKit


class RecordDateCollectionViewCell: BaseCollectionViewCell {
    
    let dateLabel = {
        let view = UILabel()
        view.textAlignment = .center
        view.clipsToBounds = true
        view.layer.borderColor = UIColor.lightGray.cgColor
        view.layer.borderWidth = 1
        view.layer.cornerRadius = 10
        return view
    }()
    
    
    
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
