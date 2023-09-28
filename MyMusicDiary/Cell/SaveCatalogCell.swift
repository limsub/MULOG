//
//  SaveCatalogCell.swift
//  MyMusicDiary
//
//  Created by 임승섭 on 2023/09/27.
//

import UIKit
import Kingfisher


class BezierView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        let path = UIBezierPath(
            ovalIn: CGRect(x: bounds.minX + bounds.width * 0.7, y: frame.minY - bounds.height * 0.1, width: bounds.width * 0.6, height: bounds.height * 2.2)
        )
        
        UIColor.white.withAlphaComponent(0.3).setFill()
        
        path.lineWidth = 0
        path.stroke()
        path.fill()
    }
}

class SaveCatalogCell: BaseCollectionViewCell {
    
    let backView = {
        let view = BezierView()
//        view.backgroundColor = .lightGray.withAlphaComponent(0.05)
//        view.backgroundColor = .systemPink.withAlphaComponent(0.2)
        view.backgroundColor = .cyan.withAlphaComponent(0.1)
//        view.backgroundColor = .brown.withAlphaComponent(0.1)
        view.clipsToBounds = true
        view.layer.cornerRadius = 5
        
        return view
    }()
    
    let artworkImageView = {
        let view = UIImageView()
        view.clipsToBounds = true
        view.layer.cornerRadius = 5
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    let titleLabel = {
        let view = UILabel()
        view.font = .systemFont(ofSize: 16)
        return view
    }()
    
    let artistLabel = {
        let view = UILabel()
        view.font = .systemFont(ofSize: 12)
        view.textColor = .lightGray
        return view
    }()
    
    
    let genre1Label = {
        let view = UILabel()
        view.clipsToBounds = true
        view.layer.cornerRadius = 20
        view.backgroundColor = .orange.withAlphaComponent(0.2)
//        view.text = "대표"
        view.textAlignment = .center
        return view
    }()
    let genre2Label = {
        let view = UILabel()
        view.clipsToBounds = true
        view.layer.cornerRadius = 20
        view.backgroundColor = .orange.withAlphaComponent(0.2)
//        view.text = "대표"
        view.textAlignment = .center
        return view
    }()
    let genre3Label = {
        let view = UILabel()
        view.clipsToBounds = true
        view.layer.cornerRadius = 20
        view.backgroundColor = .orange.withAlphaComponent(0.2)
//        view.text = "대표"
        view.textAlignment = .center
        return view
    }()
    
    let representLabel = {
        let view = UILabel()
        view.clipsToBounds = true
        view.layer.cornerRadius = 20
        view.backgroundColor = .orange.withAlphaComponent(0.2)
        view.text = "대표"
        view.textAlignment = .center
        return view
    }()
    
    
    override func setConfigure() {
        super.setConfigure()
        
        contentView.addSubview(backView)
        contentView.addSubview(artworkImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(artistLabel)
        contentView.addSubview(representLabel)
        contentView.addSubview(genre1Label)
        contentView.addSubview(genre2Label)
        contentView.addSubview(genre3Label)
    }
    override func setConstraints() {
        super.setConstraints()
        
        backView.snp.makeConstraints { make in
            make.edges.equalTo(contentView)
        }
        artworkImageView.snp.makeConstraints { make in
            make.top.leading.equalTo(backView).inset(8)
            make.height.equalTo(backView).multipliedBy(0.5)
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
        representLabel.snp.makeConstraints { make in
            make.trailing.bottom.equalTo(backView).inset(10)
            
            make.width.equalTo(50)
            make.height.equalTo(40)
        }
        genre1Label.snp.makeConstraints { make in
            make.leading.equalTo(artworkImageView.snp.centerX)
            make.bottom.equalTo(backView).inset(10)
            make.height.equalTo(40)
        }
        genre2Label.snp.makeConstraints { make in
            make.leading.equalTo(genre1Label.snp.trailing).offset(10)
            make.bottom.equalTo(backView).inset(10)
            make.height.equalTo(40)
        }
        genre3Label.snp.makeConstraints { make in
            make.leading.equalTo(genre2Label.snp.trailing).offset(10)
            make.bottom.equalTo(backView).inset(10)
            make.height.equalTo(40)
        }
    }
    
    func designCell(_ sender: MusicItem) {
//        let url = sender.imageURL?.url(width: 100, height: 100)
        guard let smallURL = sender.smallImageURL else { return }
        let url = URL(string: smallURL)
        
        artworkImageView.kf.setImage(with: url)
        titleLabel.text = sender.name
        artistLabel.text = "\(sender.artist)"
        
        
        // "음악" 제외 -> 모든 곡에 다 포함되어있음 -> genre count를 무조건 1 빼서 계산 -> 모든 곡의 두번째 인덱스가 "음악" -> 제외시킴
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
        
//
//        for (index, item) in sender.genres.enumerated() {
//            genresText += item
//            if index != sender.genres.count - 1 {
//                genresText += ", "
//            }
//        }
        
        
        representLabel.isHidden = true
    }
    
}

