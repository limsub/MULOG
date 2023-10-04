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
        view.font = .systemFont(ofSize: 18)
        view.textAlignment = .center
        return view
    }()
    
    let backView = {
        let view = UIView()
        view.backgroundColor = .lightGray
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
    
    
    override func setConfigure() {
        super.setConfigure()
        
        contentView.backgroundColor = .systemRed
        
        contentView.addSubview(dateLabel)
        contentView.addSubview(yoilLabel)
        contentView.addSubview(backView)
        backView.addSubview(artworkImageView)
        backView.addSubview(titleLabel)
        backView.addSubview(artistLabel)
    }
    override func setConstraints() {
        super.setConstraints()
        
        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(contentView).inset(8)
            make.leading.equalTo(contentView).inset(12)
            make.width.equalTo(contentView).multipliedBy(0.15)
        }
        yoilLabel.snp.makeConstraints { make in
            make.top.equalTo(dateLabel.snp.bottom).offset(8)
            make.centerX.equalTo(dateLabel)
        }
        backView.snp.makeConstraints { make in
            make.verticalEdges.trailing.equalTo(contentView)
            make.leading.equalTo(dateLabel.snp.trailing).offset(8)
        }
        artworkImageView.snp.makeConstraints { make in
            make.verticalEdges.leading.equalTo(backView).inset(5)
            make.width.equalTo(artworkImageView.snp.height)
        }
        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(artworkImageView.snp.trailing).offset(12)
            make.trailing.equalTo(backView).inset(12)
            make.top.equalTo(backView).inset(10)
        }
        artistLabel.snp.makeConstraints { make in
            make.leading.equalTo(artworkImageView.snp.trailing).offset(12)
            make.trailing.equalTo(backView).inset(12)
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
        }
    }
    
    
    func designCell(_ sender: MusicItemTable, day: String) {
        guard let date = Constant.DateFormat.realmDateFormatter.date(from: day) else { return }
        
        let dayFormat = DateFormatter()
        dayFormat.dateFormat = "dd"

        let yoilFormat = DateFormatter()
        yoilFormat.dateFormat = "EEE"
        
        dateLabel.text = dayFormat.string(from: date)
        yoilLabel.text = yoilFormat.string(from: date)
        
        guard let str = sender.smallImageURL, let url = URL(string: str) else { return }
        artworkImageView.kf.setImage(with: url)
        
        titleLabel.text = sender.name
        artistLabel.text = sender.artist
    }
}
