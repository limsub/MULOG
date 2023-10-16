//
//  MonthScrollCatalogCell.swift
//  MyMusicDiary
//
//  Created by 임승섭 on 2023/10/04.
//

import UIKit
import Kingfisher

class MonthScrollCatalogCell: BaseCollectionViewCell {
    
    let dateLabel = {
        let view = UILabel()
        view.text = "날짜"
        view.font = .boldSystemFont(ofSize: 24)
        view.textAlignment = .center
        return view
    }()
    let yoilLabel = {
        let view = UILabel()
        view.text = "요일"
        view.font = .boldSystemFont(ofSize: 16)
        view.textAlignment = .center
        return view
    }()
    let dateBackView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.clipsToBounds = true
        view.layer.cornerRadius = 20
        return view
    }()
    
    let backView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        view.clipsToBounds = true
        view.layer.cornerRadius = 5
        return view
    }()
    
    let artworkImageView = {
        let view = UIImageView()
        view.backgroundColor = .blue
        view.clipsToBounds = true
        view.layer.cornerRadius = 5
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    let titleLabel = {
        let view = UILabel()
        view.text = "제목"
        view.font = .systemFont(ofSize: 16)
        return view
    }()
    
    let artistLabel = {
        let view = UILabel()
        view.text = "가수"
        view.font = .systemFont(ofSize: 13)
        view.textColor = .darkGray
        return view
    }()
    
    
    let genre1Label = {
        let view = BasePaddingLabel(padding: UIEdgeInsets(top: 2, left: 8, bottom: 2, right: 8))
    
        view.clipsToBounds = true
        view.layer.cornerRadius = 8
//        view.layer.borderColor = UIColor.lightGray.cgColor
//        view.layer.borderWidth = 0.4
//        view.backgroundColor = .white.withAlphaComponent(0.8)
        view.backgroundColor = .clear
        view.textColor = .lightGray
        view.font = .systemFont(ofSize: 14)
        view.textAlignment = .center
        
        view.text = "락"
        return view
    }()
    let genre2Label = {
        let view = BasePaddingLabel(padding: UIEdgeInsets(top: 2, left: 8, bottom: 2, right: 8))
    
        view.clipsToBounds = true
        view.layer.cornerRadius = 8
//        view.layer.borderColor = UIColor.lightGray.cgColor
//        view.layer.borderWidth = 0.4
//        view.backgroundColor = .white.withAlphaComponent(0.8)
        view.backgroundColor = .clear
        view.textColor = .lightGray
        view.font = .systemFont(ofSize: 14)
        view.textAlignment = .center
        
        view.text = "발라드"
        return view
    }()
    let genre3Label = {
        let view = BasePaddingLabel(padding: UIEdgeInsets(top: 2, left: 8, bottom: 2, right: 8))
    
        view.clipsToBounds = true
        view.layer.cornerRadius = 8
//        view.layer.borderColor = UIColor.lightGray.cgColor
//        view.layer.borderWidth = 0.4
//        view.backgroundColor = .white.withAlphaComponent(0.8)
        view.backgroundColor = .clear
        view.textColor = .lightGray
        view.font = .systemFont(ofSize: 14)
        view.textAlignment = .center
        
        view.text = "K-POP"
        return view
    }()
    
    
    let countBackView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    let countImageView = {
        let view = UIImageView()
        view.image = UIImage(systemName: "star")
        view.tintColor = .lightGray
        return view
    }()
    let countLabel = {
        let view = UILabel()
        view.text = "3"
        view.textAlignment = .center
        view.textColor = .lightGray
        view.font = .boldSystemFont(ofSize: 18)
        return view
    }()
    let countRecordLabel = {
        let view = UILabel()
        view.text = "record"
        view.textColor = .lightGray
        view.font = .boldSystemFont(ofSize: 12)
        view.textAlignment = .center
        return view
    }()
    
    
    override func setConfigure() {
        super.setConfigure()
        
//        contentView.backgroundColor = .systemRed
        
        contentView.addSubview(dateBackView)
        contentView.addSubview(dateLabel)
        contentView.addSubview(yoilLabel)
        contentView.addSubview(backView)
        backView.addSubview(artworkImageView)
        backView.addSubview(titleLabel)
        backView.addSubview(artistLabel)
        backView.addSubview(genre1Label)
        backView.addSubview(genre2Label)
        backView.addSubview(genre3Label)
        
        backView.addSubview(countBackView)
//        countBackView.addSubview(countImageView)
        countBackView.addSubview(countLabel)
        countBackView.addSubview(countRecordLabel)
    }
    override func setConstraints() {
        super.setConstraints()
        
//        dateLabel.snp.makeConstraints { make in
//            make.top.equalTo(contentView).inset(4)
//            make.leading.equalTo(contentView).inset(8)
//            make.width.equalTo(contentView).multipliedBy(0.15)
//        }
//        yoilLabel.snp.makeConstraints { make in
//            make.top.equalTo(dateLabel.snp.bottom).offset(4)
//            make.centerX.equalTo(dateLabel)
//        }
        dateBackView.snp.makeConstraints { make in
            make.verticalEdges.leading.equalTo(contentView)
            make.width.equalTo(contentView).multipliedBy(0.2)
        }
        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(dateBackView).inset(8)
            make.centerX.equalTo(dateBackView)
        }
        yoilLabel.snp.makeConstraints { make in
            make.top.equalTo(dateLabel.snp.bottom).offset(4)
            make.centerX.equalTo(dateBackView)
        }
        
        backView.snp.makeConstraints { make in
            make.verticalEdges.trailing.equalTo(contentView)
            make.leading.equalTo(dateBackView.snp.trailing)
        }
        artworkImageView.snp.makeConstraints { make in
            make.verticalEdges.leading.equalTo(backView).inset(5)
            make.width.equalTo(artworkImageView.snp.height)
        }
        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(artworkImageView.snp.trailing).offset(12)
            make.trailing.equalTo(backView).inset(50)
            make.top.equalTo(backView).inset(5)
        }
        artistLabel.snp.makeConstraints { make in
            make.leading.equalTo(artworkImageView.snp.trailing).offset(12)
            make.trailing.equalTo(backView).inset(12)
            make.top.equalTo(titleLabel.snp.bottom).offset(4)
        }
        
        genre1Label.snp.makeConstraints { make in
            make.leading.equalTo(artworkImageView.snp.trailing).offset(8)
            make.bottom.equalTo(backView).inset(5)
        }
        genre2Label.snp.makeConstraints { make in
            make.leading.equalTo(genre1Label.snp.trailing).offset(8)
            make.bottom.equalTo(backView).inset(5)
        }
        genre3Label.snp.makeConstraints { make in
            make.leading.equalTo(genre2Label.snp.trailing).offset(8)
            make.bottom.equalTo(backView).inset(5)
        }
        
//        countBackView.backgroundColor = .lightGray
//        countImageView.backgroundColor = .red
//        countLabel.backgroundColor = .blue
        
        countBackView.snp.makeConstraints { make in
            make.verticalEdges.trailing.equalTo(backView)
            make.width.equalTo(contentView).multipliedBy(0.2)
        }
//        countImageView.snp.makeConstraints { make in
//            make.centerY.equalTo(countBackView).offset(-12)
//            make.centerX.equalTo(countBackView).offset(8)
//            make.width.equalTo(countBackView).multipliedBy(0.35)
//            make.height.equalTo(countImageView.snp.width)
//        }
        countLabel.snp.makeConstraints { make in
            make.centerY.equalTo(countBackView).offset(-12)
            make.centerX.equalTo(countBackView).offset(8)
        }
        countRecordLabel.snp.makeConstraints { make in
            make.top.equalTo(countLabel.snp.bottom).offset(4)
            make.centerX.equalTo(countLabel)
        }
        
    }
    
    
    func designCell(_ sender: MusicItemTable, day: String, indexPath: IndexPath) {
        guard let date = Constant.DateFormat.realmDateFormatter.date(from: day) else { return }
        
        let dayFormat = DateFormatter()
        dayFormat.dateFormat = "dd"
        
        let yoilFormat = DateFormatter()
        yoilFormat.dateFormat = "EEE"
        yoilFormat.locale = Locale.init(identifier: "en")
        
        dateLabel.text = dayFormat.string(from: date)
        yoilLabel.text = yoilFormat.string(from: date)
        
        guard let str = sender.bigImageURL, let url = URL(string: str) else { return }
        artworkImageView.kf.setImage(with: url)
        
        titleLabel.text = sender.name
        artistLabel.text = sender.artist
        
        if indexPath.item != 0 {
            dateLabel.isHidden = true
            yoilLabel.isHidden = true
            dateBackView.isHidden = true
        }
        
        
        contentView.backgroundColor = .clear
        backView.backgroundColor = .white
        
        for (index, item) in [genre1Label, genre2Label, genre3Label].enumerated() {
            item.isHidden = false
            
            var genreIdx = index
            if index >= 1 {
                genreIdx = index + 1
            }
            
            if genreIdx <= sender.genres.count - 1 {
                item.text = sender.genres[genreIdx]
            } else {
                item.isHidden = true
            }
        }
        
        countLabel.text = "\(sender.count)"
        if sender.count > 2 {
            countRecordLabel.text = "records"
        } else {
            countRecordLabel.text = "record"
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        dateLabel.isHidden = false
        yoilLabel.isHidden = false
    }
}
