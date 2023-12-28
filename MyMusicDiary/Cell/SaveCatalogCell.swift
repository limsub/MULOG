//
//  SaveCatalogCell.swift
//  MyMusicDiary
//
//  Created by 임승섭 on 2023/09/27.
//

import UIKit
import Kingfisher


class BasePaddingLabel: UILabel {
    private var padding = UIEdgeInsets(top: 16.0, left: 16.0, bottom: 16.0, right: 16.0)

    convenience init(padding: UIEdgeInsets) {
        self.init()
        self.padding = padding
    }

    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: padding))
    }

    override var intrinsicContentSize: CGSize {
        var contentSize = super.intrinsicContentSize
        contentSize.height += padding.top + padding.bottom
        contentSize.width += padding.left + padding.right

        return contentSize
    }
}


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
        view.backgroundColor = .blue.withAlphaComponent(0.1)
//        view.backgroundColor = .cyan.withAlphaComponent(0.1)
//        view.backgroundColor = .brown.withAlphaComponent(0.1)
//        view.backgroundColor = .lightGray.withAlphaComponent(0.1)
        
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
        view.font = .systemFont(ofSize: 13)
        view.textColor = .darkGray
        return view
    }()
    
    
    let genre1Label = {
        
        let view = BasePaddingLabel(padding: UIEdgeInsets(top: 4, left: 8, bottom: 4, right: 8))
    
        view.clipsToBounds = true
        view.layer.cornerRadius = 10
        view.layer.borderColor = UIColor.white.cgColor
        view.layer.borderWidth = 0.4
        view.backgroundColor = .white.withAlphaComponent(0.8)
        view.textColor = .lightGray
        view.font = .systemFont(ofSize: 14)
        view.textAlignment = .center
        return view
    }()
    let genre2Label = {
        let view = BasePaddingLabel(padding: UIEdgeInsets(top: 4, left: 8, bottom: 4, right: 8))
        
        view.clipsToBounds = true
        view.layer.cornerRadius = 10
        view.layer.borderColor = UIColor.white.cgColor
        view.layer.borderWidth = 0.4
        view.backgroundColor = .white.withAlphaComponent(0.8)
        view.textColor = .lightGray
        view.font = .systemFont(ofSize: 14)
        view.textAlignment = .center
        return view
    }()
    let genre3Label = {
        let view = BasePaddingLabel(padding: UIEdgeInsets(top: 4, left: 8, bottom: 4, right: 8))
        
        view.clipsToBounds = true
        view.layer.cornerRadius = 10
        view.layer.borderColor = UIColor.white.cgColor
        view.layer.borderWidth = 0.4
        view.backgroundColor = .white.withAlphaComponent(0.8)
        view.textColor = .lightGray
        view.font = .systemFont(ofSize: 14)
        view.textAlignment = .center
        return view
    }()
    
    let representLabel = {
        let view = BasePaddingLabel(padding: UIEdgeInsets(top: 6, left: 12, bottom: 6, right: 12))
        
        view.clipsToBounds = true
        view.layer.cornerRadius = 14
        
        view.backgroundColor = Constant.Color.main2.withAlphaComponent(0.3)
        
//        view.backgroundColor = Constant.Color.main.withAlphaComponent(0.4)
//        view.backgroundColor = UIColor(hexCode: "#FF9E85", alpha: 0.4)
//        view.layer.borderColor = UIColor(hexCode: "#FF9E85", alpha: 0.8).cgColor
//        view.layer.borderWidth = 1
        
        view.text = "대표"
        
        view.textColor = .white
        
        view.font = .boldSystemFont(ofSize: 16)
        
        view.textAlignment = .center
        return view
    }()
    
    let recordView = UIView()
    
    let cntLabel = {
        let view = UILabel()
        view.font = .boldSystemFont(ofSize: 20)
        view.textColor = .white
        view.text = "3"
        return view
    }()
    
    let recordLabel = {
        let view = UILabel()
        view.font = .boldSystemFont(ofSize: 14)
        view.textColor = .white
        view.text = "records"
        return view
    }()
    
//    let xButton = {
//        let view = UIButton()
//        view.setImage(UIImage(systemName: "xmark"), for: .normal)
//        view.imageEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 12, right: 0)
//        view.tintColor = .lightGray
////        view.backgroundColor = .red
//        return view
//    }()
    
    
    
    override func setConfigure() {
        super.setConfigure()
        
    
        
        
        contentView.addSubview(backView)
        
        backView.addSubview(artworkImageView)
        backView.addSubview(titleLabel)
        backView.addSubview(artistLabel)
        
        backView.addSubview(genre1Label)
        backView.addSubview(genre2Label)
        backView.addSubview(genre3Label)
        
        
        recordView.addSubview(cntLabel)
        recordView.addSubview(recordLabel)
        
        
        backView.addSubview(recordView)
        
        backView.addSubview(representLabel)
        
        
//        backView.addSubview(xButton)
    }
    override func setConstraints() {
        super.setConstraints()
        
        backView.snp.makeConstraints { make in
            make.edges.equalTo(contentView).inset(5)
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
        
        genre1Label.snp.makeConstraints { make in
            make.leading.equalTo(artworkImageView.snp.trailing).offset(12)
            make.bottom.equalTo(backView).inset(10)
//            make.height.equalTo(30)
        }
        genre2Label.snp.makeConstraints { make in
            make.leading.equalTo(genre1Label.snp.trailing).offset(10)
            make.bottom.equalTo(backView).inset(10)
//            make.height.equalTo(30)
        }
        genre3Label.snp.makeConstraints { make in
            make.leading.equalTo(genre2Label.snp.trailing).offset(10)
            make.bottom.equalTo(backView).inset(10)
//            make.height.equalTo(30)
        }
        
        representLabel.snp.makeConstraints { make in
//            make.trailing.equalTo(backView).inset(10)
//            make.top.equalTo(titleLabel)
            
//            make.leading.equalTo(backView).inset(8)
            
            make.centerX.equalTo(artworkImageView)
            make.centerY.equalTo(genre1Label)
            
//            make.width.equalTo(50)
//            make.height.equalTo(40)
        }
        
        cntLabel.snp.makeConstraints { make in
            make.centerX.equalTo(recordView)
            make.top.equalTo(recordView)
        }
        recordLabel.snp.makeConstraints { make in
            make.centerX.equalTo(recordView)
            make.top.equalTo(cntLabel.snp.bottom)
            make.bottom.equalTo(recordView)
        }
        
        recordView.snp.makeConstraints { make in
            make.centerY.equalTo(backView)
            make.trailing.equalTo(backView).inset(40)
            
        }
        
//        xButton.snp.makeConstraints { make in
//            make.top.trailing.equalTo(backView)
//            make.size.equalTo(40)
//        }
    }
    
    func designCell(_ sender: MusicItem, recordCnt: Int, indexPath: IndexPath) {
        
        representLabel.isHidden = (indexPath.item == 0) ? false : true

        cntLabel.text = "\(recordCnt)"
        if recordCnt == 1 {
            recordLabel.text = "record"
        } else {
            recordLabel.text = "records"
        }
        
        
        guard let smallURL = sender.smallImageURL else { return }
        let url = URL(string: smallURL)
        
        // * 다운샘플링 필요
        artworkImageView.kf.setImage(with: url)
        titleLabel.text = sender.name
        artistLabel.text = "\(sender.artist)"
        
        
        
        if let backColor = sender.backgroundColor {
            backView.backgroundColor = UIColor(cgColor: backColor).withAlphaComponent(0.2)
        } else {
            backView.backgroundColor = .lightGray.withAlphaComponent(0.1)
        }
        
        
        
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
        
//        xButton.addTarget(self, action: #selector(xButtonClicked), for: .touchUpInside)
    }
    
}

