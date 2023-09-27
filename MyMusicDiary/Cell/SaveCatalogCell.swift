//
//  SaveCatalogCell.swift
//  MyMusicDiary
//
//  Created by 임승섭 on 2023/09/27.
//

import UIKit
import Kingfisher


class SaveCatalogCell: BaseCollectionViewCell {
    
    let backView = {
        let view = UIView()
        view.backgroundColor = .lightGray.withAlphaComponent(0.05)
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
    
    let artistAndGenreLabel = {
        let view = UILabel()
        view.font = .systemFont(ofSize: 12)
        view.textColor = .lightGray
        return view
    }()
    
    let representView = {
        let view = UILabel()
        view.layer.cornerRadius = 30
        view.backgroundColor = .orange.withAlphaComponent(0.2)
        view.text = "대표"
        return view
    }()
    
    
    override func setConfigure() {
        super.setConfigure()
        
        contentView.addSubview(backView)
        contentView.addSubview(artworkImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(artistAndGenreLabel)
        contentView.addSubview(representView)
    }
    override func setConstraints() {
        super.setConstraints()
        
        backView.snp.makeConstraints { make in
            make.edges.equalTo(contentView)
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
        artistAndGenreLabel.snp.makeConstraints { make in
            make.leading.equalTo(artworkImageView.snp.trailing).offset(12)
            make.trailing.equalTo(backView).inset(12)
            make.bottom.equalTo(backView).inset(10)
        }
        representView.snp.makeConstraints { make in
            make.trailing.bottom.equalTo(backView).inset(10)
        }
    }
    
    func designCell(_ sender: MusicItem) {
        let url = sender.imageURL?.url(width: 100, height: 100)
        
        artworkImageView.kf.setImage(with: url)
        titleLabel.text = sender.name
        
        var genresText = ""
        if let genreArr = sender.genres {
            for (index, item) in genreArr.enumerated() {
                genresText += item
                if index != genreArr.count - 1 {
                    genresText += ", "
                }
            }
        }
        artistAndGenreLabel.text = "\(sender.artist) • \(genresText)"
        
        representView.isHidden = true
    }
    
}

