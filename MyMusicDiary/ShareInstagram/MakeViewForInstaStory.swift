//
//  MakeViewForInstaStory.swift
//  MyMusicDiary
//
//  Created by 임승섭 on 7/15/24.
//

import UIKit

// 스토리에 공유하기 위한 뷰를 만든다.
class MakeViewForInstaStory {
    
    static let shared = MakeViewForInstaStory()
    private init() { }
    
    // 날짜, 앨범 커버 이미지, 노래제목, 아티스트 이름, 장르
    func makeViewForInstaStory(_ data: InstaStoryData) -> UIView {
        
        // UI Component
        let baseView = UIView(frame: CGRect(x: 0, y: 0, width: 300, height: 550))
        baseView.backgroundColor = .white
        baseView.clipsToBounds = true
        baseView.layer.cornerRadius = 20
        
        let logoView = {
            let view = UIImageView()
            view.image = UIImage(named: "mainLogo")
            view.contentMode = .scaleAspectFit
            return view
        }()
        let dateLabel = {
            let view = UILabel()
            view.textAlignment = .center
            view.font = .boldSystemFont(ofSize: 18)
            return view
        }()
        let imageView = {
            let view = UIImageView()
            view.contentMode = .scaleAspectFit
            view.clipsToBounds = true
            view.layer.cornerRadius = 10
            return view
        }()
        let titleLabel = {
            let view = UILabel()
            view.textAlignment = .center
            view.font = .boldSystemFont(ofSize: 26)
            return view
        }()
        let artistLabel = {
            let view = UILabel()
            view.textAlignment = .center
            view.font = .boldSystemFont(ofSize: 16)
            view.textColor = .lightGray
            return view
        }()
        let genre1Label = makeGenreLabel()
        let genre2Label = makeGenreLabel()
        let genre3Label = makeGenreLabel()
        let stackView = {
            let view = UIStackView()
            view.axis = .horizontal
            view.alignment = .fill
            view.distribution = .equalSpacing
            view.spacing = 8
            return view
        }()
        
        // addSubView
        [logoView, dateLabel, imageView, titleLabel, artistLabel, stackView].forEach { item in
            baseView.addSubview(item)
        }
        [genre1Label, genre2Label, genre3Label].forEach { item in
            stackView.addArrangedSubview(item)
        }
        
        // layouts
        logoView.snp.makeConstraints { make in
            make.top.equalTo(baseView).inset(16)
            make.centerX.equalTo(baseView)
            make.height.equalTo(70)
            make.width.equalTo(140)
        }
        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(logoView.snp.bottom).offset(8)
            make.horizontalEdges.equalTo(baseView).inset(12)
        }
        imageView.snp.makeConstraints { make in
//            make.top.equalTo(baseView).inset(14)
            make.top.equalTo(dateLabel.snp.bottom).offset(16)
            make.horizontalEdges.equalTo(baseView).inset(20)
            make.height.equalTo(imageView.snp.width)
        }
        titleLabel.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(baseView).inset(12)
            make.top.equalTo(imageView.snp.bottom).offset(18)
        }
        artistLabel.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(baseView).inset(12)
            make.top.equalTo(titleLabel.snp.bottom).offset(4)
        }
        stackView.snp.makeConstraints { make in
            make.top.equalTo(artistLabel.snp.bottom).offset(20)
            make.centerX.equalTo(baseView)
            make.height.equalTo(25)
        }
        
//        baseView.layoutIfNeeded()
        
        // Data Setting
        dateLabel.text = data.date.toString(of: .instaStory)
        imageView.kf.setImage(with: URL(string: data.imageURL))
        titleLabel.text = data.title
        artistLabel.text = data.artist
        for (idx, item) in [genre1Label, genre2Label, genre3Label].enumerated() {
            item.isHidden = false
            
            var genreIdx = idx
            if idx >= 1 { genreIdx = idx + 1}
            
            if genreIdx <= data.genres.count - 1 { item.text = data.genres[genreIdx] }
            else { item.isHidden  = true }
        }
        
        baseView.layoutIfNeeded()
        
        // return
        return baseView
    }
    
}

extension MakeViewForInstaStory {
    private func makeGenreLabel() -> BasePaddingLabel {
        let view = BasePaddingLabel(padding: UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8))
    
        view.clipsToBounds = true
        view.layer.cornerRadius = 10
        view.layer.borderColor = UIColor.lightGray.cgColor
        view.layer.borderWidth = 0.4
        view.backgroundColor = .white.withAlphaComponent(0.8)
        view.textColor = .lightGray
        view.font = .systemFont(ofSize: 14)
        view.textAlignment = .center
        
        return view
    }
}


struct InstaStoryData {
    let date: Date  // 7월 8일의 기록
    let imageURL: String  // 앨범 커버 이미지
    let title: String   // 제목
    let artist: String  // 아티스트
    let genres: [String]  // 장르. 최대 3개
}
