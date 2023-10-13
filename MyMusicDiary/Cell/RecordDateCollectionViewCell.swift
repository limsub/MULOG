//
//  RecordDateCollectionViewCell.swift
//  MyMusicDiary
//
//  Created by 임승섭 on 2023/10/10.
//

import UIKit


class RecordDateCollectionViewCell: BaseCollectionViewCell {
    
    let dayLabel = {
        let view = UILabel()
        view.font = .boldSystemFont(ofSize: 24)
        view.textAlignment = .center
        view.adjustsFontSizeToFitWidth = true
//        view.textColor = Constant.Color.main3
        return view
    }()
    
    let yoilLabel = {
        let view = UILabel()
        view.font = .boldSystemFont(ofSize: 16)
        view.textAlignment = .center
        view.adjustsFontSizeToFitWidth = true
//        view.textColor = Constant.Color.main3
        return view
    }()
    
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
        
        contentView.addSubview(dayLabel)
        contentView.addSubview(yoilLabel)
        
//        contentView.addSubview(dateLabel)
        
    }
    
    override func setConstraints() {
        super.setConstraints()
        
        dayLabel.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(contentView).inset(4)
            make.centerY.equalTo(contentView).offset(-16)
        }
        yoilLabel.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(contentView).inset(4)
            make.top.equalTo(dayLabel.snp.bottom).offset(8)
        }
        
        
//        dateLabel.snp.makeConstraints { make in
//            make.edges.equalTo(contentView)
//        }
    }
    
    override func setting() {
        super.setting()
        
        contentView.clipsToBounds = true
//        contentView.layer.borderWidth = 2
        contentView.layer.cornerRadius = 20
//        contentView.backgroundColor = Constant.Color.main3.withAlphaComponent(0.5)
        contentView.backgroundColor = .white
        
    }
    
    func designCell(_ date: String) {
        let dayDate = date.toDate(to: .full)
        
        dayLabel.text = dayDate?.toString(of: .day)
        yoilLabel.text = dayDate?.toString(of: .yoil)
    }
    
}
