//
//  GenreCatalogCell.swift
//  MyMusicDiary
//
//  Created by 임승섭 on 2023/10/11.
//

import UIKit

class GenreCatalogCell: BaseCollectionViewCell {
    
    let backView = {
        let view = UIView()
        view.clipsToBounds = true
        view.layer.cornerRadius = 5
        view.backgroundColor = .black
        return view
    }()
    
    let nameLabel = {
        let view = UILabel()
        view.font = .boldSystemFont(ofSize: 24)
        view.textAlignment = .center
        view.textColor = .white
        view.adjustsFontSizeToFitWidth = true
        return view
    }()
    
    override func setConfigure() {
        super.setConfigure()
        
        contentView.addSubview(backView)
        backView.addSubview(nameLabel)
    }
    override func setConstraints() {
        super.setConstraints()
        
        backView.snp.makeConstraints { make in
            make.edges.equalTo(contentView)
        }
        nameLabel.snp.makeConstraints { make in
            make.edges.equalTo(backView).inset(10)
        }
    }
    
    override func setting() {
        super.setting()
        
    }
    
    
}
